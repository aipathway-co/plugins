# AI Staff — pre-release QA checklist

Walk this before every plugin release. These are the branches automated gates
cannot reach: the skills are prose, so the only way to know they behave is to put
an agent through each path and watch.

Record the result (pass / fail / n-a) and the plugin version next to each run.

## `/configure-scheduled-task`

**Happy path**
- [ ] `/configure-scheduled-task vinnie` on a fully configured, enabled agent creates a
      task. The `prompt`, `taskId`, `title` and `description` written to the scheduler
      are **byte-identical** to what `get_scheduled_task` returned — nothing rewritten,
      summarized, or "tidied".
- [ ] The confirmation quotes `nextRunAt` read back from the scheduler, not a time the
      model computed.
- [ ] The receipt names the operation, task id, cron, next run and `promptVersion`.

**Agent resolution**
- [ ] A bare nickname ("schedule Dana") resolves to the right `agent_key`.
- [ ] An ambiguous or unknown name asks rather than guessing.

**Blockers (each should create NOTHING and hand off to `/agent-config`)**
- [ ] Never-configured agent.
- [ ] `enabled: false`.
- [ ] Agent whose `usesEmail` is true with no bound mailbox.
- [ ] Agent with no published skill version, or a pin at a version that no longer resolves.

**Duplicate detection**
- [ ] Re-running for an already-scheduled agent reports the existing task and its cadence,
      and defaults to updating rather than creating a second.
- [ ] Asking for a *second* schedule anyway warns that two tasks means two independent
      runs, and the new id is MC's canonical id plus a suffix.

**Cadence**
- [ ] "8am every Tuesday" produces a cron whose `nextRunAt` really is the next Tuesday 8am.
- [ ] A day-of-week phrase ("weekdays", "every Sunday") lands on the right days — this is
      the easiest thing to get subtly wrong.
- [ ] A time inside 01:00–03:00 prompts the daylight-saving nudge and does not move the
      user's time without asking.

**Dry-run wording**
- [ ] The flow says *"the method is intended not to perform external writes"* and never
      "no writes will happen."

**Failure handling**
- [ ] `get_scheduled_task` unavailable (old connector) → STOPS, writes no prompt of its own,
      creates no task.
- [ ] The scheduler call itself failing is reported, not silently swallowed.
- [ ] User declines at the confirmation → nothing is created.

**Check mode (`/configure-scheduled-task` with no agent)**
- [ ] Lists only `aipathway-` tasks and maps each back to its agent.
- [ ] A task stamped with an older `promptVersion` is offered a refresh.
- [ ] A task whose stamp is missing or malformed reports **"unable to verify"** and offers a
      refresh — never treated as current.
- [ ] A paused (host-`enabled: false`) task is reported as producing nothing, with an offer
      to re-enable or delete.

## `/agent-config`
- [ ] No longer offers `schedule` or `timezone`, and points scheduling at
      `/configure-scheduled-task`.

## `cfo-financial-analysis`

**Request shaping**
- [ ] A financial-analysis request calls `prepare_financial_analysis` with the
      user request as `query` and `response_format: "financial_analysis"`.
- [ ] Only an explicit plan or roadmap request uses
      `response_format: "30_60_90_plan"`; e.g., “analyze our cash position” is
      `financial_analysis`, while “give me a 90-day cash-improvement roadmap” is
      `30_60_90_plan`.
- [ ] The caller infers `focus` from the request and passes only applicable enum
      values: `profitability`, `cash_liquidity`, `project_labor`, or `cogs`.
      It adds no domain selection rules and omits `focus` when none applies.
- [ ] `accounting_basis` is passed only as `Cash` or `Accrual` when known;
      otherwise it is omitted and the returned basis probe is followed.

**Mission Control response contract and dry read**
- [ ] Run dry reads against the live `prepare_financial_analysis` MCP tool for
      default focus, `cash_liquidity` without `accounting_basis`, and
      `project_labor` + `cogs` with `accounting_basis: "Cash"`; record each
      unmodified response with the plugin version.
- [ ] From each real response, verify that every field referenced by the stub
      exists and is usable: `phases.data_gathering`, `phases.final_analysis`,
      `selected_guidance_modules`, `required_data` entries with `{item}`,
      `optional_data`, and `response_contract` (plus the basis discovery from
      the balance sheet when `accounting_basis` was omitted).
- [ ] Confirm each healthy dry-read response has usable non-empty phases and
      selected guidance, so no preparation STOP condition applies. If any field
      is absent or unusable, mark the check failed; do not waive it by inventing
      a response shape.

**Execution and failure handling**
- [ ] The stub follows only `phases.data_gathering`, `phases.final_analysis`, and
      `selected_guidance_modules`, and structures the response using
      `response_contract` sections and rules.
- [ ] Each required-data item is retrieved using the available connected tools;
      the stub does not require another MCP server's tool name or parameters.
- [ ] If any required-data item cannot be retrieved because no suitable tool is
      connected or retrieval fails, the run stops, names that item, and provides
      no financial conclusions.
- [ ] Optional-data failures or unavailable optional-data tools continue the run
      and appear in **Data gaps and assumptions**; they do not stop the run.
- [ ] The reporting period and any comparison period come from the request. If no
      period is stated, the stub uses the most recent complete month and says so
      in **Scope, basis, and period** (or **Data gaps and assumptions** for a
      30/60/90 plan).
- [ ] When `accounting_basis` was omitted and the balance sheet identifies the
      company's basis, the stub calls `prepare_financial_analysis` again with
      that basis before final analysis.
- [ ] Preparation failure or unavailability, or any missing/unusable required
      top-level method field (`phases.data_gathering`, `phases.final_analysis`,
      `selected_guidance_modules`), stops the run with no financial conclusions.
- [ ] The stub never calls `get_skill` for CFO financial analysis, never writes
      to an accounting system, never invents data, and labels any estimates,
      projections, or assumptions.

## Release mechanics
- [ ] `ai-staff/.claude-plugin/plugin.json` version bumped (CI fails without it).
- [ ] The Mission Control deploy carrying any new tool is **already live** — the stubs call
      tools only the new server has.
