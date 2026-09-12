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
- [ ] A financial-analysis request calls `prepare_financial_analysis` with the
      user request as `query` and `response_format: "financial_analysis"`.
- [ ] A plan or roadmap request uses only `response_format: "30_60_90_plan"`.
- [ ] The stub follows `dataGatheringMethod`, retrieves only required data through
      approved MCP tools, then follows `finalAnalysisMethod` and the selected
      financial guidance.
- [ ] Missing or unavailable preparation, required data, or approved MCP tools
      stops the run without invented financial conclusions.
- [ ] The stub never calls `get_skill` for CFO financial analysis.

## Release mechanics
- [ ] `ai-staff/.claude-plugin/plugin.json` version bumped (CI fails without it).
- [ ] The Mission Control deploy carrying any new tool is **already live** — the stubs call
      tools only the new server has.
