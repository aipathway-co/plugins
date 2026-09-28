# Competitive landscape: monetizing and access-gating MCP servers, Claude skills and plugins, and AI workflow IP for creators

Research date: 2026-09-28. Scope: direct and adjacent competitors to a product that hosts a creator's proprietary skills, methods and prompts behind an authenticated multi-tenant MCP server. Buyers install a thin public plugin stub that fetches the method at runtime. Access is tied to a subscription (Stripe, Skool, Whop and similar) and revoked when payment lapses, with per-customer audit logs and versioning.

Staleness warning: much of the MCP-monetization coverage comes from vendor blogs, including competitor-authored comparison posts from MCPize, Agensi, Nevermined and mcp-marketplace.io, and SEO content farms. These are flagged where used. Traction numbers are mostly self-reported.

---

## Q1. MCP monetization and hosting platforms: which let a creator charge per-end-user subscriptions and revoke access, and who does each one target?

### Takeaway
A crowded developer-oriented layer now exists. It includes MCPize, Apify, mcp-marketplace.io, Zuplo, xpay, PayMCP, the Stripe/Cloudflare paid-MCP SDKs, Nevermined and Cloudflare's Monetization Gateway. Several already do per-subscriber API keys and automatic revocation (Zuplo explicitly; MCPize with one API key per subscriber). None of them targets audience-led creators, integrates with Skool or Whop entitlements, or is designed around hiding prompt or skill IP delivered into Claude through a plugin stub. Discovery registries (Smithery, Glama, mcp.so, PulseMCP) do not pay creators at all.

### Cited Findings

**MCPize (closest "MCP marketplace plus hosting plus payments" competitor)**
- Positions itself as "MCP Server Hosting: Like Vercel, but Your Server Earns Money". It handles hosting, payments, support and compliance — [MCPize hosting](https://mcpize.com/hosting); [MCPize developers](https://mcpize.com/developers)
- Revenue share is 80% to the developer (20% platform fee), with "Stripe Connect payouts every month", "Tax handling included" and a "0% platform fee for the first month" promo — [MCPize developers](https://mcpize.com/developers)
- A secondary source says an 85% "Founding Member" rate applied to servers that activated monetization before June 10, 2026, and the standard fee is 20% after that — [Godberry Studios](https://godberrystudios.com/posts/how-to-monetize-mcp-servers-2026/) (secondary; not confirmed on MCPize primary page)
- Pricing models: subscription ("monthly plans with included usage and overage rates") and pay-per-call via x402 in USDC on Base — [MCPize developers](https://mcpize.com/developers)
- Access control: "One API key per subscriber" — [MCPize developers](https://mcpize.com/developers)
- Self-reported traction: "900+ MCP servers", "450+ publishing developers", "5,000+ MCP developers" in community — [MCPize developers](https://mcpize.com/developers)
- Described as launching in early 2026, with an audience "smaller and less established" than Apify's — [Godberry Studios](https://godberrystudios.com/posts/how-to-monetize-mcp-servers-2026/)
- No funding disclosed on its site — [MCPize developers](https://mcpize.com/developers)

**Apify (largest paying MCP/tool marketplace by payouts)**
- Monetizes MCP servers as Actors using pay-per-event (PPE): "Users pay for specific events that are programmatically triggered from the Actor's source code" — [Apify docs: monetize](https://docs.apify.com/platform/actors/publishing/monetize)
- Developers receive 80% of PPE revenue — [ChatAds summary](https://www.getchatads.com/blog/tools-for-monetizing-mcp-servers/); [Godberry Studios](https://godberrystudios.com/posts/how-to-monetize-mcp-servers-2026/)
- The rental model is being sunset: new rental Actors stopped April 1, 2026, and rental Actors are fully retired October 1, 2026 — [Godberry Studios migration playbook](https://godberrystudios.com/posts/apify-pay-per-event-migration-playbook-2026/)
- Primary claims: "$500k+ payouts to developers every month", "36K+ active developer community", "130k+ signups … every month", "7,000+ tools". Servers are automatically distributed to Make, n8n and Gumloop. The developer retains "full ownership of your code and intellectual property" — [Apify MCP developers](https://apify.com/mcp/developers)
- CONFLICT: a secondary source claims Apify paid "$1.4M monthly across roughly 3,000 developers (~$470 avg)" — [Godberry Studios](https://godberrystudios.com/posts/how-to-monetize-mcp-servers-2026/). This conflicts with Apify's own "$500k+", which may be a stale page figure.
- Buyers authenticate via Apify account/token URLs (the "generated URL with authentication credentials"). The model is usage-billed per event, not a creator-owned subscription tied to an external community — [Apify MCP developers](https://apify.com/mcp/developers)

**MCP Marketplace (mcp-marketplace.io)**
- A self-published comparison lists MCP Marketplace at an 85/15 split via Stripe Connect, with "License key SDKs (Python & TypeScript)", "key verification against the API, local caching for fast startup, graceful fallback when offline" and one-click install. Suggested price points are $5–25 one-time or $5–50/month — [MCP Marketplace blog, Mar 2026](https://mcp-marketplace.io/blog/state-of-mcp-monetization-2026) (vendor-authored)
- The same source says Anthropic Connectors, mcp.so, Smithery, PulseMCP and Glama have no paid listings — [MCP Marketplace blog](https://mcp-marketplace.io/blog/state-of-mcp-monetization-2026)

**Smithery (registry/hosting; acquired)**
- Arcade.dev acquired Smithery; the announcement is dated August 5, 2026. Co-founder Anirudh Kamath joined Arcade and terms were undisclosed — [Arcade blog](https://www.arcade.dev/blog/smithery-joins-arcade/); [Dealroom](https://app.dealroom.co/news/feed/arcade-acquires-smithery-to-control-mcp-registry-and-runtime-layer)
- Coverage: [Forbes, Aug 10, 2026](https://www.forbes.com/sites/janakirammsv/2026/08/10/arcade-acquires-smithery-to-own-the-agent-tool-supply-chain/) (403 on fetch; headline only)
- Arcade is positioned as an enterprise "secure action layer" for authorization and auditing of agent tools — [Dealroom](https://app.dealroom.co/news/feed/arcade-acquires-smithery-to-control-mcp-registry-and-runtime-layer)
- Arcade raised a $60M Series A (June 2026, led by SYN Ventures, with Morgan Stanley and Wipro strategic), for $72M total — per search summary of [Forbes](https://www.forbes.com/sites/janakirammsv/2026/08/10/arcade-acquires-smithery-to-own-the-agent-tool-supply-chain/) (not directly verified)
- Smithery lists 7,300+ servers — [awesome-mcp-monetization](https://github.com/xpaysh/awesome-mcp-monetization)
- Creators do not earn on Smithery ("the creator is the one paying") — [MCPize alternatives page](https://mcpize.com/alternatives/smithery) (competitor-authored)

**Glama, mcp.so, PulseMCP, Official MCP Registry (discovery only)**
- mcp.so lists 17,700+ servers. Glama offers a hosted proxy and usage analytics. The official registry is maintained under modelcontextprotocol — [awesome-mcp-monetization](https://github.com/xpaysh/awesome-mcp-monetization)
- None supports paid listings — [MCP Marketplace blog](https://mcp-marketplace.io/blog/state-of-mcp-monetization-2026)

**Stripe (payments SDK plus agentic protocols; developer-targeted)**
- Stripe's agent toolkit exposes `PaidMcpAgent` / `registerPaidTool()`, which wraps MCP tools with payment verification. It looks up or creates a Stripe customer by the user's email and checks for a paid checkout session or subscription before running the tool. It was built with Cloudflare — [DeepWiki stripe/ai](https://deepwiki.com/stripe/ai/3-model-context-protocol-(mcp)-server); [dev.to hands-on](https://dev.to/hideokamoto/exploring-paid-mcp-servers-with-stripe-and-cloudflare-my-hands-on-experience-3le9)
- Stripe Sessions (April 29, 2026) announced 288 launches, among them:
  - the Machine Payments Protocol (MPP), "microtransactions, recurring payments, and more", with stablecoins and fiat via Shared Payment Tokens
  - a Link agent wallet
  - Metronome + Tempo "streaming payments"
  - subscription metrics via the Stripe MCP
  - Agentic Commerce Suite partnerships with Meta and Google

  There was no creator-facing "sell your MCP" product — [Stripe Sessions 2026 recap](https://stripe.com/blog/everything-we-announced-at-sessions-2026); [MPP blog](https://stripe.com/blog/machine-payments-protocol)
- Stripe hosts its own remote MCP server at mcp.stripe.com with OAuth — [Stripe MCP docs](https://docs.stripe.com/mcp)

**Cloudflare (remote MCP hosting plus x402)**
- The Agents SDK supports `withX402` and `paidTool` to charge USDC per MCP tool call. Clients get HTTP 402, pay, then retry — [Cloudflare x402 docs](https://developers.cloudflare.com/agents/tools/payments/x402/); [Cloudflare x402 Foundation blog](https://blog.cloudflare.com/x402/)
- The Monetization Gateway was announced July 1, 2026. It charges for "web pages, datasets, APIs, and MCP tools", is usage-based only, uses stablecoins only at launch, is at the waitlist stage, and offers optional Web Bot Auth account-based pricing — [Cloudflare blog](https://blog.cloudflare.com/monetization-gateway/)
- Cloudflare and AWS embed x402 at the edge — [InfoQ, Jul 2026](https://www.infoq.com/news/2026/07/cloudflare-aws-x402-micropayment/)
- Community boilerplate: Cloudflare remote MCP with Google/GitHub login and Stripe for paid tools — [iannuttall/mcp-boilerplate](https://github.com/iannuttall/mcp-boilerplate)

**Zuplo (API/MCP gateway with subscription monetization; closest on revocation mechanics)**
- API Monetization entered public beta in March 2026 — [Zuplo changelog](https://zuplo.com/changelog/2026/03/26/api-monetization-beta)
- "Plan-scoped API keys are issued automatically when a customer subscribes". Zuplo issues Stripe invoices for fixed plus metered fees, and "the gateway revokes access automatically when a payment goes overdue". The same plans cover MCP traffic — [Zuplo monetization](https://zuplo.com/features/api-monetization); [Zuplo: monetize an MCP](https://zuplo.com/blog/monetize-an-mcp-server); [Zuplo solutions](https://zuplo.com/solutions/monetize-and-control)
- Target: API/enterprise developer teams — [Zuplo](https://zuplo.com/)

**Open-source SDKs, boilerplates and micro-SaaS**
- PayMCP (Python and TypeScript): `@price(...)` and `@subscription(...)` decorators gate tools behind active subscriptions. It supports Stripe, x402 and wallets, with modes including ELICITATION and DYNAMIC_TOOLS — [PayMCP GitHub](https://github.com/PayMCP/paymcp); [paymcp-ts](https://github.com/PayMCP/paymcp-ts)
- xpay: "No-code MCP monetization platform. Register your server, set per-tool prices, and get a proxy URL in under 2 minutes" — [awesome-mcp-monetization](https://github.com/xpaysh/awesome-mcp-monetization)
- Other x402 and Lightning libraries: MCPay, PaidMCP (Lightning/NWC), x402-mcp (Vercel AI SDK), Coinbase Payments MCP — [awesome-mcp-monetization](https://github.com/xpaysh/awesome-mcp-monetization)
- MCP-Billing is a self-hosted Next.js boilerplate for OAuth 2.1 + PKCE, API-key rotation and Stripe usage billing. It costs a one-time €79 with no revenue share and got 116 upvotes on Product Hunt (2026) — [Product Hunt](https://www.producthunt.com/products/mcp-billing)
- xmcp + Polar: validates a `license-key` header via Polar's `validateLicenseKey`, with optional meter-credit events per tool call — [xmcp blog](https://xmcp.dev/blog/polar-integration)

**Nevermined, Moesif and ad networks (adjacent)**
- Nevermined is AI-native billing (usage, outcome and credits) supporting x402, A2A, MCP and AP2. It is headquartered in Zug and self-describes as a 2026 Gartner Cool Vendor — [Nevermined blog](https://nevermined.ai/blog/ai-agent-payment-systems); [Nevermined MCP monetization](https://nevermined.ai/blog/mcp-monetization-ai-agents)
- Moesif offers usage-based metering for enterprise API teams — [ChatAds summary](https://www.getchatads.com/blog/tools-for-monetizing-mcp-servers/)
- Ad monetization for MCP (ChatAds, ZeroClick, Dappier, Koah, Adsbind) is a different model — [ChatAds](https://www.getchatads.com/blog/tools-for-monetizing-mcp-servers/)

**Composio, Pipedream (integration platforms, not creator monetization)**
- Composio raised a $25M Series A led by Lightspeed (July 2025), about $29M total — [SiliconANGLE](https://siliconangle.com/2025/07/22/composio-raises-25m-funding-ease-ai-agent-development/); [Composio blog](https://composio.dev/blog/series-a)
- Workday agreed to acquire Pipedream on Nov 19, 2025. Pipedream's MCP exposes ~10,000 tools across ~3,000 apps with managed OAuth — [Workday newsroom](https://newsroom.workday.com/2025-11-19-Workday-Signs-Definitive-Agreement-to-Acquire-Pipedream); [Peliqan comparison](https://peliqan.io/blog/composio-pipedream-peliqan-mcp/)

### Inferences
- Per-subscriber gating and automatic revocation on payment lapse are already commoditized at the gateway and SDK layer (Zuplo, MCPize, PayMCP, Stripe `registerPaidTool`). The product cannot differentiate on "Stripe-gated MCP" alone.
- The platforms fall into three groups:
  - developer/utility-tool marketplaces (Apify, MCPize, mcp-marketplace.io), where the value is a tool or API
  - enterprise gateways (Zuplo, Kong, Moesif, Arcade)
  - crypto micropayments (x402, Cloudflare, Nevermined)
- None frames the sold asset as "a creator's method or prompt IP delivered into Claude", and none integrates with community entitlement systems (Skool, Whop, Discord roles).
- Smithery moving into Arcade's enterprise-governance orbit suggests registries are drifting toward enterprise, not creators.
- x402 and MPP per-call models suit agent-to-agent utility calls poorly for creators whose audiences pay monthly community-style subscriptions.

### Gaps
- MCPize funding, founders and verified revenue: not found.
- mcp-marketplace.io traction: not found; its comparison table is self-authored.
- xpay pricing and take rate: not verified (only the awesome-list description).
- Kong's MCP gateway monetization specifics: not researched in depth due to the tool-call budget.
- Whether MCPize or mcp-marketplace.io hide server source from buyers is not stated. mcp-marketplace.io's "local caching … offline fallback" license-key model implies local code, so IP is exposed.
- Vercel's MCP offering (hosting adapter, skills.sh) was only touched via skills.sh (Q4); Vercel-specific paid-MCP features are unverified.

---

## Q2. Anthropic's own surfaces (plugin marketplaces, skills, connectors, paid marketplace plans) and OpenAI's (GPT Store revenue share, Apps SDK monetization, Agentic Commerce)

### Takeaway
As of late September 2026, Anthropic has launched Claude Marketplace (Sept 23, 2026). It has over 2,000 connectors and plugins, and enterprise customers can buy partner agents and products against committed Anthropic spend. However, no primary source shows a creator revenue share or paid listings for individual plugins and skills. Plugin distribution copies files to the user's machine, so IP is exposed. OpenAI's Apps SDK still does not allow digital-goods or subscription sales in-app, and GPT Store revenue share remains murky or limited.

### Cited Findings

**Anthropic: Claude Marketplace**
- Launched September 23, 2026. It is a destination to add connectors and plugins, buy Claude-powered agents and products, and find service partners, with "more than 2,000" connectors and plugins at launch — [Claude blog](https://claude.com/blog/claude-marketplace); [BleepingComputer](https://www.bleepingcomputer.com/news/artificial-intelligence/anthropic-turns-claude-into-an-ai-marketplace-with-2-000-plus-plugins-and-connectors/); [gHacks](https://www.ghacks.net/2026/09/27/anthropic-launches-claude-marketplace-with-more-than-2000-connectors-and-plugins/)
- Paid agents and products (CrowdStrike, Cursor, Harvey, Hebbia, Legora, Lovable, Snowflake) can be bought with "a portion of their committed Anthropic spend" — [Claude blog](https://claude.com/blog/claude-marketplace); [Claude Marketplace page](https://claude.com/platform/marketplace); [Digital Applied](https://www.digitalapplied.com/blog/claude-marketplace-committed-spend-agent-software)
- There are three routes in: (1) build connectors or plugins with MCP and Agent Skills; (2) apply to list Claude-powered agents or products; (3) join the Claude Partner Network — [Claude blog](https://claude.com/blog/claude-marketplace)
- Neither the blog nor BleepingComputer states a take rate or whether individual developers can charge for plugins or connectors — [Claude blog](https://claude.com/blog/claude-marketplace); [BleepingComputer](https://www.bleepingcomputer.com/news/artificial-intelligence/anthropic-turns-claude-into-an-ai-marketplace-with-2-000-plus-plugins-and-connectors/)
- A directory submission portal went live September 25, 2026 for Pro, Max, Team and Enterprise users. It has two paths (a single remote MCP connector, or a full plugin bundle hosted on GitHub), automated validation and safety scans, status tracking and post-approval usage analytics. It says nothing about paid listings — [Crypto Briefing](https://cryptobriefing.com/claude-plugin-mcp-connector-submission-portal/)

**Anthropic: plugin marketplace mechanics (relevant to the "thin stub" design)**
- A marketplace is a git repo with `.claude-plugin/marketplace.json`, and "the repository can be private". Sources can be GitHub, git URL, zip archive over HTTPS, npm, or `command`. Admins can require a marketplace org-wide — [Claude Code docs: plugin marketplaces](https://code.claude.com/docs/en/plugin-marketplaces)
- "People who install from your hosted marketplace get a copy in the plugin cache". Plugin files are therefore copied locally, and a plain plugin exposes its skill and prompt contents — [Claude Code docs](https://code.claude.com/docs/en/plugin-marketplaces)
- The official Anthropic-managed directory is at [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official). Agent37 describes the Claude plugin marketplace as "free-only distribution; no monetization support" — [Agent37](https://www.agent37.com/blog/monetize-claude-code-skills) (competitor-authored)

**Unverified or likely unreliable claim**
- One source asserts that Anthropic launched a "Skills Marketplace" on May 1, 2026. It claims about 600 skills and a 15% Anthropic cut on paid skills (one-time or monthly) — [500k.io](https://500k.io/journal/anthropic-skills-marketplace-launch)
- It cites no Anthropic announcement. No Anthropic, Claude or Claude Code primary page found in this research mentions paid skills or a creator revenue share ([site-restricted search results](https://www.anthropic.com/news/skills)).
- Treat this as UNVERIFIED and likely inaccurate. Search-result summaries elsewhere also say Anthropic "publishes no … revenue share for developers in the broader plugin marketplace" — [gHacks](https://www.ghacks.net/2026/09/27/anthropic-launches-claude-marketplace-with-more-than-2000-connectors-and-plugins/) (via search summary)

**OpenAI**
- Apps in ChatGPT and the Apps SDK are built on MCP. OpenAI had promised a public directory, "monetization tools for developers" and ACP instant checkout — [OpenAI: Introducing apps in ChatGPT](https://openai.com/index/introducing-apps-in-chatgpt/)
- OpenAI later began accepting third-party app submissions and launched an App Directory — [OpenAI](https://openai.com/index/developers-can-now-submit-apps-to-chatgpt/); [VentureBeat](https://venturebeat.com/technology/openai-now-accepting-chatgpt-app-submissions-from-third-party-devs-launches)
- The current Apps SDK monetization docs recommend external checkout on the developer's own domain, framed around physical goods. Embedded or instant checkout is a private beta for "select marketplaces". Per search-indexed text of the same page, "selling digital goods, subscriptions, or in-app services isn't yet allowed" — [OpenAI Apps SDK monetization](https://developers.openai.com/apps-sdk/build/monetization)
- The Agentic Commerce Protocol was released with Stripe on Sept 29, 2025 under Apache 2.0. There is a reported 4% fee on Instant Checkout merchant transactions — [OpenAI ACP](https://developers.openai.com/commerce); [OpenAI: Buy it in ChatGPT](https://openai.com/index/buy-it-in-chatgpt/); fee figure via [Ekamoira](https://www.ekamoira.com/blog/chatgpt-instant-checkout-agentic-commerce-protocol-2026) (secondary)
- GPT Store revenue share: CONFLICTING and low-quality evidence. One guide says it "never broadly launched … invite-only pilot restricted to a small group of US-based builders", yet also says payouts rolled out "to most major markets" — [Digital Applied](https://www.digitalapplied.com/blog/gpt-store-custom-gpts-business-guide-2026)
- Developers have long complained about the lack of clarity — [OpenAI community thread](https://community.openai.com/t/what-is-the-status-with-gpt-store-revenue-share/839172)

### Inferences
- Anthropic's 2026 marketplace monetizes at the enterprise level: committed-spend drawdown for vetted partners. It does not offer per-creator subscriptions for individual skills or plugins, which leaves the creator long tail unserved for now.
- There is platform risk: Anthropic could add paid-listing support (a 15% take is rumored but unverified) or native entitlement checks for plugins. That would commoditize the "gated plugin" layer.
- The product's architecture (a public stub plus a remote authenticated MCP) fits both paths through Anthropic's own submission portal (a remote MCP connector, or a GitHub plugin bundle). It could list in the official directory while billing off-platform.
- The same MCP server could also back a ChatGPT app. OpenAI's no-digital-goods rule means creators must sell outside ChatGPT and gate by OAuth or entitlement, which is exactly the product's model.

### Gaps
- No primary Anthropic source found on whether directory-listed plugins may be paid, require OAuth, or can link to off-platform subscriptions.
- The terms for third-party "agents and products" sellers (take rate, eligibility) are unpublished.
- The GPT Store payout program's current status (Sept 2026) is not confirmed by any OpenAI primary source.

---

## Q3. Creator commerce with license keys and access control (Gumroad, Lemon Squeezy, Whop, Skool, Patreon, Polar, Keygen): do any integrate with MCP or AI agent access?

### Takeaway
All of these handle payments and some form of entitlement, and several (Polar, Lemon Squeezy, Gumroad, Keygen) expose license-key validation APIs a developer could call from an MCP server. Polar plus xmcp is the only documented turnkey "paywall MCP tools with license keys" path. Whop and Polar ship MCP servers, but for the merchant to operate their own store, not for gating buyer access to AI IP. Skool has no public API or webhooks, a real integration gap that a product could fill (via Stripe or Zapier workarounds).

### Cited Findings
- **Polar.sh:**
  - Merchant of Record with license-key "benefits"
  - its official MCP server lets agents manage products, subscriptions, benefits and license keys via OAuth — [Polar MCP docs](https://polar.sh/docs/integrate/mcp)
  - the xmcp framework integration validates a buyer's `license-key` header to paywall MCP tools, with meter credits for per-tool usage — [xmcp blog](https://xmcp.dev/blog/polar-integration)
- **Lemon Squeezy:**
  - a License API to activate, validate and deactivate keys tied to orders and subscriptions, rate-limited to 60 requests/min — [Lemon Squeezy License API](https://docs.lemonsqueezy.com/api/license-api); [licensing help](https://docs.lemonsqueezy.com/help/licensing)
  - Stripe acquired Lemon Squeezy in 2024 — [search summary via Lemon Squeezy docs results](https://docs.lemonsqueezy.com/guides/tutorials/license-keys) (acquisition widely reported; primary Stripe link not fetched)
- **Gumroad:** auto-generates license keys for software products and has a verification API for validating keys and tracking activations — [ToolVS](https://toolvs.co/features/gumroad-license-keys) (secondary). Gumroad is a common channel for selling Claude skill bundles as downloads, e.g. [a Gumroad Claude skills bundle](https://inflectual.gumroad.com/l/master-marketing-claude-skills-bundle)
- **Whop:**
  - runs two MCP servers: one for docs and one to "operate on live Whop data", with a Whop plugin for Claude Code — [Whop docs: AI and MCP](https://docs.whop.com/developer/guides/ai_and_mcp)
  - this is merchant-side tooling, not buyer-side gating of AI IP — [Whop docs](https://docs.whop.com/developer/guides/ai_and_mcp)
  - manages memberships with automated Discord and Telegram role access control — [Sacra](https://sacra.com/c/whop/)
- **Whop funding (CONFLICTING):**
  - Feb 2026 strategic investment by Tether at a $1.6B valuation, with a $200M raise — [Sacra](https://sacra.com/c/whop/)
  - a separate report says a "$17M Series B led by Inspired Capital at a $1.6B valuation" — [Dealroom](https://dealroom.co/news/134677-whop-raises-17m-series-b-led-by-inspired-capital-at-a-1-6b-valuation/)
  - traction: about $3B annual creator payouts, 18.4M+ users and 183,628 sellers (as of June 2025) — [Sacra](https://sacra.com/c/whop/) via search summary
- **Skool:**
  - no documented public REST or GraphQL API; "the only official programmatic interface is Stripe webhooks for payment events"
  - Zapier exposes "Invite Member" and "Unlock Course for Member", and this is "currently the only supported way to let an agent act inside a Skool group" — [RevenueGeeks: Skool API 2026](https://revenuegeeks.com/software/skool/api); [Tools4Skool](https://tools4skool.com/integrations/skool-api); [Zapier Skool webhooks](https://zapier.com/apps/skool/integrations/webhook)
  - third-party scraper APIs exist on Apify — [Apify Skool API](https://apify.com/cristiantala/skool-all-in-one-api)
- **Patreon and Keygen:** no MCP- or agent-specific integration found in this research (see Gaps).

### Inferences
- These platforms are integration partners (sources of entitlement truth), not competitors, unless one of them ships "gate an MCP or Claude plugin by membership" natively.
- Whop is the most likely to do this: it already has MCP servers, a Claude Code plugin, apps and Discord role gating, and ample capital.
- Polar is the closest existing developer-grade analog (license key → MCP tool paywall). It is developer-centric, has no hosted IP vault, and no Skool or Whop tie-in.
- Skool's lack of an API makes "revoke on lapse" hard to do there. A product that solves Skool entitlement sync (e.g., via the Skool owner's Stripe webhooks or Zapier) would fill a real wedge for Skool-based AI educators.

### Gaps
- Patreon API / MCP integrations and Keygen's positioning for AI tools were not researched (budget).
- Whether Whop's app store has AI-app or MCP-gating apps built by third parties is unknown.
- Gumroad's current fee (10% plus processing, historically) was not re-verified for 2026.

---

## Q4. Startups doing "sell your prompts, skills or agents" with DRM or hosted execution (PromptBase, skill marketplaces, hosted GPT wrappers, agent marketplaces, n8n/Make/Zapier templates)

### Takeaway
The closest direct competitors are hosted-execution skill platforms: Agent37 (it hosts Claude Code skills server-side, hides source and paywalls access), Agensi (a paid skill marketplace at 70–80% creator share, with a $9/mo MCP-based live-access tier) and ClaudeSkills.ai (90% creator share via Stripe Connect). Pickaxe is the leading "hosted GPT wrapper with Stripe subscriptions" for creators. PromptBase is the incumbent prompt marketplace. None found combines "IP stays server-side" with "runs natively inside the buyer's own Claude Code or Claude session via a stub" and "Skool/Whop entitlement sync".

### Cited Findings

**Agent37 (hosted Claude skills; most direct IP-protection competitor)**
- Hosted execution: skills run on Agent37's servers, and "customers never download or see the skill files"
- It offers a browser workspace with terminal, scheduled jobs, 1,000+ integrations via Composio, and white-label (customers never see Agent37 branding)
- Hosting starts at $3.99/month. The creator "bill[s] customers directly". No take rate or traction is disclosed.
- It frames the market as "users pay for access to a running skill" rather than licensing files, which "leaks IP completely"
- Source: [Agent37 blog](https://www.agent37.com/blog/monetize-claude-code-skills); [Agent37 marketplace post](https://www.agent37.com/blog/claude-skills-marketplace)
- Difference from the product: execution happens in Agent37's hosted browser workspace, not in the buyer's own Claude client via MCP.

**Agensi (paid skills marketplace)**
- Claims to be the only skills marketplace that compensates creators. Every submission gets an 8-point security scan. It had 200+ skills in April 2026 ([Agensi comparison, Apr 20, 2026](https://www.agensi.io/learn/best-ai-agent-skills-marketplaces-2026), vendor-authored); a later page advertises "7,000+ Skills" ([Agensi Claude marketplace](https://www.agensi.io/claude-marketplace)). The two counts conflict and may reflect aggregated free skills.
- Creator share is 80% per its comparison ([Agensi](https://www.agensi.io/learn/best-ai-agent-skills-marketplaces-2026)) versus "70% of sales monthly" in its creator guide ([Agensi creator guide](https://www.agensi.io/learn/how-to-sell-skills-on-agensi)). This is CONFLICTING; the 70/30 split is also cited for its agent marketplace ([Agensi landscape](https://www.agensi.io/learn/ai-agent-marketplace-landscape-2026)).
- Delivery is download plus "MCP-based live access through a $9/month Pro tier" (buyer-side subscription to the catalog) — [Agensi](https://www.agensi.io/learn/best-ai-agent-skills-marketplaces-2026)

**Other skills marketplaces (mostly free, IP exposed)**
- ClaudeSkills.ai: creators keep 90%, paid via Stripe Connect — [ClaudeSkills.ai](https://claudeskills.ai/)
- SkillsMP indexes 3M+ (elsewhere 800,000+) public GitHub skills and is free — [SkillsMP](https://skillsmp.com/); [Agensi comparison](https://www.agensi.io/learn/best-ai-agent-skills-marketplaces-2026)
- skills.sh is Vercel-backed, launched January 2026 as an npm-style skills CLI, and is free — [Agensi comparison](https://www.agensi.io/learn/best-ai-agent-skills-marketplaces-2026) (search summary)
- MCP Market is a skills directory — [MCP Market skills](https://mcpmarket.com/tools/skills)
- KissMySkills sells role-based skills at $29 each — [KissMySkills](https://kissmyskills.com/blogs/news/best-claude-skills-marketplaces-2026)
- The ecosystem grew "from one registry in December 2025 to eight major marketplaces by Q2 2026" — [Agensi comparison](https://www.agensi.io/learn/best-ai-agent-skills-marketplaces-2026) (search summary)

**Pickaxe (hosted AI-tool builder for creators; adjacent and strong)**
- Plans: Gold $29/mo, Pro $116/mo, Business $597/mo (annual pricing)
- Creators monetize agents via "subscription fees when you put them in a Studio" with Stripe. Per the fetched page summary, the platform retains a tier-dependent share of workspace revenue (Gold 90%, Pro 92%, Business up to 98%). This is ambiguous and likely means the creator keeps these percentages, i.e., a 10%/8%/2% platform fee; verify on page.
- Source: [Pickaxe pricing](https://pickaxe.co/pricing); [Pickaxe monetize AI agents 2026](https://pickaxe.co/post/monetize-ai-agents-2026)
- Buyers use the creator's hosted chatbot, so prompts are server-side by construction. MCP support was not confirmed.

**PromptBase (incumbent prompt marketplace)**
- 20% commission on marketplace sales, 0% via the seller's referral link, and 10% on custom jobs. New sellers are capped at $4.99 per listing, with weekly payouts via PayPal/Stripe — [PromptBase sell](https://promptbase.com/sell); [PromptBase support](https://promptbase.com/support); [AI Profit Mode](https://aiprofitmode.com/how-to-sell-on-promptbase.html) (secondary)
- The prompt is delivered to the buyer after purchase: a one-time sale with no revocation — [PromptBase sell](https://promptbase.com/sell)

**Agent marketplaces**
- Agent.ai is described as an aggregator: "a catalog, an auth handshake, a billing rail, and a revenue-share agreement", running nothing itself — [search summary of agent-marketplace analyses](https://www.digitalapplied.com/blog/ai-agent-marketplaces-2026-discovery-distribution) (secondary; exact source attribution uncertain)
- Most developer marketplaces take 15–30%, while Microsoft Marketplace charges a flat 3% — same secondary sources ([Agensi landscape](https://www.agensi.io/learn/ai-agent-marketplace-landscape-2026))
- Relevance AI marketplace specifics: not verified.

**n8n / Make / Zapier templates**
- n8n's Creator Hub offers free template-gallery exposure. Monetization is mainly through the affiliate program (30% commission on n8n Cloud referrals for the first year, per the affiliate page summary) or selling templates on Gumroad — [n8n affiliates](https://n8n.io/affiliates/); [n8n community thread](https://community.n8n.io/t/monetization-of-n8n-templates/262982); [n8n creator hub guide](https://slashpage.com/n8n-guide/qpv5x427g58882kyn3dw?lang=en&tl=en)
- The n8n workflow gallery lists 12,572 workflows — [n8n workflows](https://n8n.io/workflows/)
- Templates are JSON files that buyers import, so the IP is fully exposed on delivery — [n8n community](https://community.n8n.io/t/ok-to-create-paid-n8n-templates-bundle-library/170798)

### Inferences
- Whether the IP is hidden splits the market cleanly:
  - Exposed (sell a file): PromptBase, Gumroad bundles, n8n templates, most skill marketplaces, standard Claude plugins.
  - Hidden (sell access to hosted execution): Agent37, Pickaxe, Apify, MCPize.
- Only the hidden models support subscription revocation meaningfully.
- The product's niche sits between these groups. The IP is hidden as with Agent37 or Pickaxe, but execution stays inside the buyer's own Claude Code or Claude (via MCP plus a stub), so buyers keep their own tools, files and model subscription. For Claude Code power users, that is a UX advantage over Agent37's hosted workspace and Pickaxe's chat UI.
- Agent37 and Agensi are the most direct threats. Either could add "MCP-served skill with per-buyer entitlement" quickly; Agensi already offers MCP-based live access, though as a catalog subscription rather than a per-creator paywall.
- A likely technical attack surface for all "hidden method" products: a skill fetched at runtime into the model context can be exfiltrated by the buyer asking Claude to print it. Neither Agent37 nor anyone else found publishes a solution. True IP protection likely requires server-side execution of the proprietary steps (MCP tools returning results) rather than returning raw prompt text. This inference is not sourced.

### Gaps
- No traction or funding found for Agent37, Agensi, ClaudeSkills.ai or Pickaxe (Pickaxe funding not searched).
- Make/Zapier template marketplace monetization was not researched (budget).
- Relevance AI and Agent.ai creator revenue terms were not verified from primary sources.
- No startup was found that explicitly markets "skill DRM for Claude plugins via MCP with Skool/Whop entitlement". That is absence of evidence from a limited search, not proof.

---

## Q5. Summary comparison vs. the target product (per-end-user subscription, revocation, IP hiding, target customer)

### Takeaway
No surveyed competitor combines all six of the product's pillars:

1. creator/audience focus
2. hidden IP
3. runs inside the buyer's own Claude via stub + MCP
4. entitlement from community platforms (Skool, Whop)
5. auto-revocation
6. per-customer audit and versioning

Each pillar exists somewhere on its own.

### Cited Findings

| Player | Target customer | Per-end-user subscription | Auto-revoke on lapse | IP hidden from buyer | Take rate / price | Source |
|---|---|---|---|---|---|---|
| MCPize | MCP developers | Yes (API key per subscriber) | Implied via subscription keys (not explicit) | Hosted server (not stated) | 20% (15% founding) | [MCPize](https://mcpize.com/developers) |
| Apify | Tool/scraper devs | No (pay-per-event via Apify account) | N/A | Hosted Actor | 20% | [Apify](https://apify.com/mcp/developers) |
| mcp-marketplace.io | MCP devs | Yes (license keys, tiers) | Via key checks | No (local install) | 15% | [MCP Marketplace](https://mcp-marketplace.io/blog/state-of-mcp-monetization-2026) |
| Zuplo | API/enterprise teams | Yes (plan-scoped keys) | Yes, explicit | Gateway in front of your server | Zuplo plan pricing | [Zuplo](https://zuplo.com/features/api-monetization) |
| Stripe `registerPaidTool` | Developers (SDK) | Yes (checks subscription) | Yes, per call check | Depends on host | Stripe fees | [DeepWiki](https://deepwiki.com/stripe/ai/3-model-context-protocol-(mcp)-server) |
| Cloudflare x402 / Monetization Gateway | Devs, publishers | No (per-request, stablecoin) | N/A | Hosted | Waitlist | [Cloudflare](https://blog.cloudflare.com/monetization-gateway/) |
| PayMCP | Developers (OSS) | Yes (`@subscription`) | Yes | Depends on host | Free OSS | [PayMCP](https://github.com/PayMCP/paymcp) |
| Polar + xmcp | Developers | Yes (license-key benefit) | Via key validation | Depends on host | Polar MoR fees | [xmcp](https://xmcp.dev/blog/polar-integration) |
| Agent37 | Skill creators | Yes (paywalls, trials) | Presumably | Yes (hosted workspace) | From $3.99/mo hosting | [Agent37](https://www.agent37.com/blog/monetize-claude-code-skills) |
| Agensi | Skill creators | Catalog sub ($9/mo MCP Pro) | N/A | Partly (download + MCP) | 20–30% | [Agensi](https://www.agensi.io/learn/best-ai-agent-skills-marketplaces-2026) |
| Pickaxe | Non-technical creators | Yes (Stripe Studio) | Yes (hosted) | Yes (hosted chatbot) | $29–597/mo + small % | [Pickaxe](https://pickaxe.co/pricing) |
| PromptBase | Prompt sellers | No (one-time) | No | No | 20% | [PromptBase](https://promptbase.com/sell) |
| Claude Marketplace | Enterprises / vetted partners | Enterprise committed spend | N/A | Plugins copied locally | Undisclosed | [Claude blog](https://claude.com/blog/claude-marketplace) |
| OpenAI Apps SDK | Brands/devs | No in-app digital subs | N/A | Remote MCP | ACP ~4% (physical) | [OpenAI](https://developers.openai.com/apps-sdk/build/monetization) |

### Inferences
- The most defensible wedge is the combination of creator-native entitlement sync (Skool, Whop, Stripe), native in-Claude delivery via MCP, and server-side IP. Payment gating alone is not defensible.
- The biggest platform risks are Anthropic adding paid plugin listings or entitlement to its marketplace, and Whop shipping native MCP/AI-app gating.
- The biggest startup risks are Agent37, Agensi and MCPize moving toward creators.

### Gaps
- Per-customer audit logs and versioning, as offered by any competitor, were not verified. Arcade (post-Smithery) advertises auditing, but for enterprise agents — [Dealroom](https://app.dealroom.co/news/feed/arcade-acquires-smithery-to-control-mcp-registry-and-runtime-layer).
- Pricing for Zuplo monetization tiers and Polar fees was not captured.
