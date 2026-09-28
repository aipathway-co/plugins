# Creator IP gating via authenticated remote MCP: technical feasibility, leakage, and platform risks (as of 2026-09-28)

## 1. Exfiltration: how easily can a paying user dump method text returned into model context?

### Takeaway
Very easily. Anything a tool returns into the model's context should be treated as disclosed to the paying user. Studies of custom GPTs find system-prompt and file extraction success above 90%, and "please don't reveal this" defensive prompts are routinely bypassed. On top of that, MCP tool results pass through the client and are stored in plain local transcripts. Even without direct access, prompts can be rebuilt approximately from outputs alone. Revoking access stops future updates and server-side work. It does nothing about text that has already been delivered.

### Cited Findings
- OWASP Top 10 for LLM Apps 2025 lists System Prompt Leakage as LLM07. It states the system prompt "should not be considered a secret, nor should it be used as a security control." — [OWASP GenAI LLM07:2025](https://genai.owasp.org/llmrisk/llm07-insecure-plugin-design/); summary in [StackHawk](https://www.stackhawk.com/blog/owasp-system-prompt-leakage/)
- The most common leak point is at inference time, when users deliberately try to override or extract the instructions. — [A10 Networks LLM07 explainer](https://www.a10networks.com/glossary/system-prompt-leakage/)
- Northwestern study (Yu et al., arXiv 2311.11538v2) of 216 custom GPTs: **97.2% system-prompt extraction success** and **100% file-leakage success** on GPTs with uploaded files. GPTs with Code Interpreter were extractable in 120 of 120 cases. — [arXiv 2311.11538v2](https://arxiv.org/html/2311.11538v2)
- In the same study, four security experts bypassed *all* defensive prompts ("do not reveal your instructions") within 10 attempts each. The authors conclude that "solely relying on defensive prompts for security is inadequate." — [arXiv 2311.11538v2](https://arxiv.org/html/2311.11538v2)
- Large-scale study of **14,904 custom GPTs** (Ogundoyin et al., arXiv 2505.08148, 2025): **92.20% vulnerable to system prompt leakage** and 96.51% susceptible to roleplay-based attacks. Over 95% lacked adequate security protections. — [arXiv 2505.08148](https://arxiv.org/abs/2505.08148)
- Researchers sometimes got the full prompt and confidential data simply by asking for the GPT's "initial prompt". — [Decrypt](https://decrypt.co/209353/your-custom-gpt-could-be-tricked-into-giving-up-your-data)
- **Prompt stealing without direct access.** "Prompt Stealing Attacks Against LLMs" (arXiv 2402.12959) rebuilds prompts from generated answers alone, using a parameter extractor plus a prompt reconstructor. — [arXiv 2402.12959](https://arxiv.org/abs/2402.12959)
- PRSA (USENIX Security 2025) rebuilds commercial prompts from PromptBase and the GPT Store using only input-output examples. It frames this as a structural threat to the prompt-marketplace business model. The proposed defenses (obfuscation, access controls) each have limits. — [USENIX Sec '25 PRSA paper](https://www.usenix.org/system/files/usenixsecurity25-yang-yong.pdf). Note: my summary of this PDF came through a fetch tool and exact success percentages were not extracted.
- **MCP-specific exposure in Claude Code:** Claude Code stores every conversation locally as JSONL under `~/.claude/projects/`, one file per session. Default retention is 30 days (`cleanupPeriodDays`) and users can raise it. — [DevelopersIO](https://dev.classmethod.jp/en/articles/claude-code-conversation-history-retention/); [Claude Code docs: .claude directory](https://code.claude.com/docs/en/claude-directory)
- When an MCP tool result is too long (default 25,000-token cap; a warning appears above 10,000 tokens), Claude Code "saves it to a file and replaces it in the conversation with a message that names the file path." A large `get_skill` payload therefore lands as a plain file on the buyer's disk. — [Claude Code MCP docs](https://code.claude.com/docs/en/mcp)
- **Bearer tokens are held by the client.** ChatGPT "directly attaches the access token it received to subsequent MCP requests (`Authorization: Bearer …`)". Claude Code stores OAuth tokens and refreshes them automatically. In the standard MCP OAuth model, the user-side client holds a working credential for the server. — [OpenAI plugin auth docs](https://developers.openai.com/plugins/build/auth); [Claude Code MCP docs](https://code.claude.com/docs/en/mcp)
- On Claude.ai web, Cowork and Desktop, custom connectors are called *from Anthropic's infrastructure*: "Your MCP server must be reachable over the public internet from Anthropic's IP ranges." — [Claude Help Center: custom connectors](https://support.claude.com/en/articles/11175166-get-started-with-custom-connectors-using-remote-mcp)

### Inferences
- **Exfiltration paths, easiest first:**
  1. Ask the model to print or summarize what the tool returned. The GPT studies show defenses fail at 90%+ rates.
  2. In Claude Code, read the local JSONL transcript or the spilled tool-result file. No model cooperation is needed.
  3. Point any MCP client at the server with one's own OAuth token (for example a generic MCP client or a script) and call `get_skill` directly. The server cannot tell a "legitimate" agent call from a scraper using the same token.
  4. Where the MCP client runs locally (Claude Code, Cursor, VS Code), put a local HTTPS proxy in the path.

  On Claude.ai-hosted connectors, direct traffic interception is harder because Anthropic's servers make the call. Paths 1 and 3 still work there.
- **What revocation actually protects:** revocation keeps (a) future updates, (b) server-side computation, data and integrations, and (c) convenience. It does not recover any method text already sent to the client. For a static method, one paid month is enough to capture all of it. A plausible estimate is near 0% protection for static prompt text after one full fetch cycle, if a determined user wants it. This is my inference, not a measured figure.
- Splitting a method into many small fetches only raises the effort. A determined user can script every branch.

### Gaps
- I found no published case study or measurement specific to MCP (as opposed to custom GPTs) of skill or instruction exfiltration by paying users.
- I could not confirm how Claude.ai's web UI displays raw MCP tool results to end users (for example, whether they appear in an expandable panel). It is likely, but I did not verify it.
- I did not extract exact PRSA reconstruction-fidelity percentages.

## 2. Stronger patterns: what actually makes protection hold?

### Takeaway
Protection only holds for whatever never leaves the server. That means server-side execution that returns results rather than instructions, plus proprietary data, state and integrations, and continuous updates. Canary or watermark tokens and per-user audit logs help with *detection and deterrence*, not prevention, and paraphrasing defeats canaries. Separately, Anthropic's directory policy now effectively pushes listed software toward server-side execution rather than pulled instructions (see Section 4).

### Cited Findings
- OWASP guidance: do not put sensitive logic or credentials in prompts, and enforce security controls outside the LLM. — [OWASP LLM07:2025](https://genai.owasp.org/llmrisk/llm07-insecure-plugin-design/); [Indusface LLM07 mitigation summary](https://www.indusface.com/learning/owasp-llm-system-prompt-leakage/)
- Custom-GPT researchers recommend "avoiding sensitive data in system prompts entirely" and disabling code interpreters where possible. — [arXiv 2311.11538v2](https://arxiv.org/html/2311.11538v2)
- **Canary tokens:** a unique random string planted in the prompt and checked for in outputs, "zero false positives by construction." A per-request token cannot be predicted or filtered. — [DEV: canary tokens for prompt leaks](https://dev.to/yohannsidot/how-canary-tokens-detect-system-prompt-leaks-in-real-time-74p)
- **Canary limits:** similarity- or string-based detection fails against paraphrase, translation or partial extraction. In experiments, leaked instructions appeared without the canary word. — [DEV canary article](https://dev.to/yohannsidot/how-canary-tokens-detect-system-prompt-leaks-in-real-time-74p); [arXiv 2506.19109 early-detection evaluation](https://arxiv.org/pdf/2506.19109)
- ContextLeak (arXiv 2512.16059) uses uniquely identifiable canary tokens embedded in exemplars to *audit* leakage. This supports the idea of per-customer fingerprinting as an audit tool. — [arXiv 2512.16059](https://arxiv.org/html/2512.16059v1)
- The MCP server sees every call with a validated bearer token. OpenAI tells builders to perform "the full set of resource-server checks yourself — signature validation, issuer and audience matching, expiry, replay considerations, and scope enforcement." This is the basis for per-user rate limiting and audit trails. — [OpenAI plugin auth](https://developers.openai.com/plugins/build/auth)
- OpenAI's plugin guidelines require tool responses to "return only data that is directly relevant to the user's request" and to exclude diagnostic or internal identifiers such as session IDs, trace IDs and request IDs. This limits visible per-response watermarking in ChatGPT plugins. — [OpenAI plugin/app submission guidelines](https://developers.openai.com/apps-sdk/app-submission-guidelines)
- The plugin tool name for a Claude Code plugin-bundled MCP server takes the form `mcp__plugin_<plugin>_<server>__<tool>`. Admins can set tools to `ask` or `blocked`. — [Claude Code MCP docs](https://code.claude.com/docs/en/mcp)

### Inferences
- **Protection ladder, weakest to strongest:**
  1. A monolithic `get_skill` that returns the whole method. This is fully leakable, and in the Claude directory arguably non-compliant (Section 4).
  2. Many small context-dependent fetches. This makes scraping more expensive but does not stop it, and the pieces are still reconstructable.
  3. Hybrid: public or skeletal instructions, with proprietary *scoring, templates, rubrics or data lookups* running server-side and returning results only.
  4. Full server-side execution with a proprietary dataset, stateful per-customer memory or history, and third-party integrations. This is the SaaS/API model, where the value is the running service and not the text.
- The SaaS analogy: API businesses protect their value by never shipping the logic (the model or algorithm runs server-side), by metering usage, and by relying on data network effects and updates. Rate limits and anomaly detection (for example, one user enumerating every branch of the method in a short window) are standard. Per-customer invisible fingerprints (distinct but equivalent phrasings or examples per tenant) can support attributing a public leak to a customer and enforcing the contract (ToS or DMCA). This is legal and deterrent value, not technical prevention. These points are inferences. I did not retrieve a dedicated source on SaaS moat strategy.
- Watermarking must survive paraphrase. Structural fingerprints (distinct example sets, numeric constants, ordering) are likely more robust than literal canary strings. This is also an inference.

### Gaps
- I found no authoritative source measuring how well per-customer text fingerprinting survives LLM paraphrase in practice.
- I retrieved no primary source on how established SaaS or API companies frame "logic stays server-side" as an IP strategy. The analogy above is my reasoning.

## 3. MCP authorization state of the art (2026) and the end-user install/auth experience

### Takeaway
The auth plumbing is mature. The MCP spec (revision 2025-11-25) standardizes OAuth 2.1 with Protected Resource Metadata. Client ID Metadata Documents (CIMD) are now the preferred client-registration method, with Dynamic Client Registration kept as a fallback. Claude (web, Desktop, Cowork, mobile, Claude Code) and ChatGPT (plugins and developer mode) both support per-user OAuth to remote MCP servers. The main friction is organizational rather than protocol-level: on Claude Team and Enterprise, only an Owner can add a custom connector. ChatGPT custom MCP requires developer mode, which workspace admins can gate. Claude Free is limited to one custom connector.

### Cited Findings
- MCP spec: servers MUST implement OAuth 2.0 Protected Resource Metadata (RFC 9728), and clients MUST use it to discover the authorization server. Authorization servers and clients SHOULD support OAuth Client ID Metadata Documents. — [MCP spec: Authorization (draft)](https://modelcontextprotocol.io/specification/draft/basic/authorization)
- The 2025-11-25 revision made CIMD the primary client-registration path and demoted DCR to a compatibility option. Order of preference: pre-registered credentials, then CIMD, then DCR. — [WorkOS on CIMD](https://workos.com/blog/client-id-metadata-documents-cimd-oauth-client-registration-mcp); [Datawiza](https://www.datawiza.com/blog/mcp-authentication-explained)
- **Claude.ai custom connectors:** available on Free, Pro, Max, Team and Enterprise, but "Free users are limited to one custom connector." On Team and Enterprise, "only Owners can add them"; members then authenticate individually. There is an optional OAuth Client ID and Secret under Advanced settings. Connectors work in Claude, Cowork, Claude Desktop and mobile. The server must be reachable from Anthropic's IP ranges. Anthropic warns that custom connectors "have not been verified by Anthropic." — [Claude Help Center](https://support.claude.com/en/articles/11175166-get-started-with-custom-connectors-using-remote-mcp)
- **Claude Code:** HTTP transport is "the recommended option for connecting to remote MCP servers". OAuth runs via `/mcp` or `claude mcp login`, and tokens are "stored securely and refreshed automatically". It supports DCR, pre-configured client ID and secret, and CIMD, which it "discovers … automatically". Plugins can bundle MCP servers via `.mcp.json`, which start automatically when the plugin is enabled. Admins can enforce `allowedMcpServers` / `deniedMcpServers` and per-tool `ask` or `blocked`. — [Claude Code MCP docs](https://code.claude.com/docs/en/mcp)
- **ChatGPT/OpenAI:** for an authenticated MCP server, builders are "expected to implement an OAuth 2.1 flow that conforms to the MCP authorization spec". CIMD is preferred and DCR is the fallback. Users can connect more than one account. OpenAI "strongly" recommends using an established identity provider. — [OpenAI plugin auth docs](https://developers.openai.com/plugins/build/auth)
- ChatGPT developer mode is a beta with full MCP client support, including write tools. It is toggled under Workspace Settings → Permissions & Roles. Pasting a custom MCP URL is the only path for servers that OpenAI has not packaged. — [OpenAI Developer mode guide](https://developers.openai.com/api/docs/guides/developer-mode); [OpenAI Help: developer mode](https://help.openai.com/en/articles/12584461-developer-mode-and-mcp-apps-in-chatgpt)
- OpenAI's app directory became a **plugin directory on July 9, 2026**, shared between ChatGPT and Codex. Plugins can bundle apps, skills or app templates. — per search-result summary of [OpenAI Help: Plugins in ChatGPT and Codex](https://help.openai.com/en/articles/20001256-plugins-in-chatgpt-and-codex) (the page returned 403 on direct fetch, so this is unverified beyond the search snippet)
- Anthropic's directory requires that "Remote MCP servers that connect to a remote service and require authentication must use secure OAuth 2.0 with certificates from recognized authorities." — [Anthropic Software Directory Policy](https://support.claude.com/en/articles/13145358-anthropic-software-directory-policy)

### Inferences
- For individual Pro/Max buyers and Claude Code users, the setup is: install the stub plugin or paste the URL, then complete one OAuth consent. That is smooth enough.
- For team buyers on Claude Team/Enterprise or managed ChatGPT workspaces, the admin gate adds a sales-cycle step, and security review of an "unverified" connector is likely.
- The Free-plan one-connector limit makes Free users a poor target.
- Cursor and VS Code also support remote MCP with OAuth, but I did not verify their current behavior in this pass.

### Gaps
- I did not verify current (2026) OAuth support details for Cursor, VS Code/GitHub Copilot, Windsurf or Gemini CLI.
- I have no quantified data on OAuth drop-off or install-completion rates for MCP connectors.

## 4. Platform risk: native marketplaces, licensing, and ToS

### Takeaway
Platform risk is live and rising. Anthropic launched the **Claude Marketplace (Sept 23, 2026)** with 2,000+ connectors and plugins and a paid "agents and products" section. It also opened a plugin submission portal (around Sept 25, 2026). No self-serve paid-plugin licensing for individual creators was announced, but the direction is clear. More directly, **Anthropic's Software Directory Policy bans the core mechanic of this product**: "Instructional Software must not direct Claude to dynamically pull behavioral instructions from external sources for Claude to execute." Hidden or obfuscated instructions are also banned. OpenAI's plugin rules forbid selling digital goods or subscriptions inside plugins, but allow sign-in to an existing paid account.

### Cited Findings
- Claude Marketplace launched **September 23, 2026**. It has three sections (connectors and plugins; agents and products; service partners) and 2,000+ connectors and plugins at launch, from Atlassian, Google, Microsoft, Notion, Salesforce and others. Customers "can use a portion of their committed Anthropic spend" on partner products such as CrowdStrike, Cursor, Harvey, Legora, Lovable and Snowflake. Builders create connectors and plugins using MCP and Agent Skills. The launch post gives no individual-creator revenue share or per-plugin pricing. — [Claude blog: Claude Marketplace](https://claude.com/blog/claude-marketplace); [BleepingComputer](https://www.bleepingcomputer.com/news/artificial-intelligence/anthropic-turns-claude-into-an-ai-marketplace-with-2-000-plus-plugins-and-connectors/); [gHacks](https://www.ghacks.net/2026/09/27/anthropic-launches-claude-marketplace-with-more-than-2000-connectors-and-plugins/)
- The directory submission portal is open to developers on paid Claude plans (live around Sept 25, 2026, per secondary reports). It accepts a remote MCP connector or a plugin bundle (MCP plus skills, hosted on GitHub). Submissions are safety-scanned and reviewed, and are reviewed again after listing. Publishers get install and listing analytics. — [Unite.AI](https://www.unite.ai/anthropic-opens-directory-submission-portal-for-claude-plugins/); [Crypto Briefing](https://cryptobriefing.com/claude-plugin-mcp-connector-submission-portal/) (secondary sources)
- **Anthropic Software Directory Policy (key conflict):**
  - "Instructional Software must not direct Claude to dynamically pull behavioral instructions from external sources for Claude to execute."
  - "Instructional Software must not contain hidden, obfuscated, or encoded instructions. All behavioral guidance must be human-readable."
  - Tool descriptions "must precisely match actual functionality."
  - "Software must not collect extraneous conversation data."
  - Unsupported: software that serves advertisements, sponsored content, paid product placements, or exists primarily as a promotional vehicle.
  - Prohibited: software that "transfers money … or executes financial transactions."

  — [Anthropic Software Directory Policy](https://support.claude.com/en/articles/13145358-anthropic-software-directory-policy)
- Directory Terms: submitters warrant that they "have and will maintain all necessary rights to provide your software." — [Anthropic Software Directory Terms](https://support.claude.com/en/articles/13145338-anthropic-software-directory-terms) (per search snippet)
- **OpenAI plugin guidelines:** "plugins may conduct commerce only for physical goods. Selling digital products or services — including subscriptions, digital content, tokens, or credits — is not allowed." "Users may sign in to an existing paid account and access features already included in their subscription. Plugins must not display subscription plans, initiate new subscriptions, or promote upgrades." — [OpenAI app/plugin submission guidelines](https://developers.openai.com/apps-sdk/app-submission-guidelines)
- OpenAI's checkout docs say current approval is "limited to plugins for physical goods purchases." The in-ChatGPT payment sheet is in private beta for select marketplaces. — [OpenAI Plugins: Checkout/monetization](https://developers.openai.com/plugins/build/monetization)
- OpenAI launched Instant Checkout via the Agentic Commerce Protocol (with Stripe) and charges merchants a 4% fee per completed purchase (secondary source). — [OpenAI: Buy it in ChatGPT](https://openai.com/index/buy-it-in-chatgpt/); [Ekamoira (fee claim, secondary)](https://www.ekamoira.com/blog/chatgpt-instant-checkout-agentic-commerce-protocol-2026)
- Third-party skill marketplaces already exist (for example Agensi, where most skills are priced at $5–15 one-time). — [Agensi marketplace comparison](https://www.agensi.io/learn/best-ai-agent-skills-marketplaces-2026) (vendor source; treat as indicative)

### Inferences
- **Directory policy is the biggest single structural risk to the `get_skill` design.** A stub skill that tells Claude to fetch its instructions from a remote MCP tool and follow them is, on a plain reading, "direct[ing] Claude to dynamically pull behavioral instructions from external sources for Claude to execute." Such a product is unlikely to be listable in Anthropic's official directory or Marketplace. It can still be distributed off-directory (custom connector URL or a self-hosted Claude Code plugin marketplace). That forfeits discovery and adds the Team/Enterprise owner gate plus "unverified connector" warnings. Server-side execution tools that return *results* (not instructions) fit the policy.
- The ban on "hidden, obfuscated, or encoded instructions" also rules out obfuscating the stub to protect IP within the directory.
- If Anthropic or OpenAI add native per-seat licensing for plugins (Anthropic already lets committed spend buy partner products), the "turn off the spigot" billing layer becomes a platform feature. The remaining differentiation would be multi-platform reach and server-side hosting. This is a forward-looking inference; I found no announcement of creator-level paid plugin licensing as of 2026-09-28.
- For ChatGPT, subscriptions must be sold off-platform, with sign-in to an existing account inside the plugin. This is compatible with an external billing plus OAuth model, but forbids in-plugin upsell.

### Gaps
- There is no public revenue-share or creator-payout program for Claude Marketplace plugins in the sources found.
- I did not fetch Anthropic's Commercial or Consumer Terms on reselling access. It is unclear whether a third-party "access broker" for creator content triggers any clause beyond the directory policy.
- I have not confirmed how strictly the "dynamically pull behavioral instructions" rule is enforced in review, or whether it also applies to self-hosted (non-directory) plugin marketplaces. It appears to apply only to directory listings.

## 5. Commoditization risk: is the "method" defensible?

### Takeaway
Mixed. Good curated skills measurably help agents: +16.2pp on average in SkillsBench, and up to +51.9pp in some domains. Models cannot reliably write equivalent skills themselves (self-generated skills gave no average benefit). So well-crafted domain methods do have real, measurable value. But once leaked, the text is trivially copyable, and it can be approximately rebuilt from outputs. Durable value therefore sits in the creator's domain depth, continuous updates, brand and community, and server-side data, not in secrecy of the text.

### Cited Findings
- SkillsBench (arXiv 2602.12670, Feb 2026) covered 86 tasks across 11 domains and 7,308 trajectories. Curated skills raise the average pass rate by **16.2pp**, ranging from +4.5pp in software engineering to +51.9pp in healthcare. 16 of 84 tasks show *negative* deltas. "Self-generated Skills provide no benefit on average, showing that models cannot reliably author the procedural knowledge they benefit from consuming." — [arXiv 2602.12670](https://arxiv.org/abs/2602.12670)
- Industry commentary claims "generic skills are commoditizing toward zero; the durable value is in deep, domain-specific procedures," and that business-function skills are growing faster than coding skills. — [Agentman: Agent Skills Ecosystem 2026](https://agentman.ai/blog/agent-skills-ecosystem-report-2026) (vendor blog; lower reliability)
- Community concern: if agent capabilities ship as copy-pasteable files, "competitors can clone them in an afternoon." — [Startup Fortune community thread](https://startupfortune.com/community/is-shipping-your-agent-logic-as-shareable-skills-actually-a-moat-or-just-a-commo) (forum; opinion)
- Prompt-stealing research shows the prompts behind marketplace products (PromptBase, GPT Store) can be approximately rebuilt from input-output behavior. — [PRSA, USENIX Sec '25](https://www.usenix.org/system/files/usenixsecurity25-yang-yong.pdf); [arXiv 2402.12959](https://arxiv.org/abs/2402.12959)
- Custom GPTs, the previous "sell your instructions" platform, saw 92–97% extractability, which enabled cloning. — [arXiv 2311.11538v2](https://arxiv.org/html/2311.11538v2); [arXiv 2505.08148](https://arxiv.org/abs/2505.08148)

### Inferences
- SkillsBench suggests a "the model can just write it" argument is weaker than commonly assumed. Good curated procedural knowledge is not trivially regenerated by the model itself, which gives creators real value. That value is fragile once the text leaks, because copying requires no model capability at all.
- **Defensibility ranking:**
  1. Server-side data, state and integrations: strong.
  2. Cadence of updates, tied to fast-changing domains (regulations, platform algorithms, market data): moderate to strong.
  3. Creator brand, trust and community: moderate, and not technical.
  4. Static method text: weak.
- The pitch "preserve your IP" is accurate only for pattern (4) in Section 2. "Turn off the spigot" is accurate for updates and server-side work, not for text already delivered. A more honest framing is "subscription access to a living, server-run method," not "DRM for prompts."

### Gaps
- There are no empirical data on how fast leaked paid skills or prompts are redistributed (for example, GitHub leak-repo growth over time).
- There are no data on churn or retention for subscription-gated skills compared with one-time skill sales.
