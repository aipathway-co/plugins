---
name: agent-config
description: >
  Configure a named agent's per-company settings in Mission Control — which
  vendors/accounts/jobs/schedule it uses, whether it runs in dry-run, and which
  email connections it may read. Use when someone wants to set up, configure,
  review, enable/disable, schedule, or turn dry-run on/off for a named agent
  (e.g. "configure Vinnie", "set up the vendor bill coder", "put Dana in
  dry-run", "what is Vinnie's config"). Works for ANY agent by key/name.
triggers:
  - "configure agent"
  - "agent config"
  - "set up <agent>"
  - "configure <agent>"
  - "review <agent> config"
  - "enable <agent>"
  - "put <agent> in dry run"
---

# /agent-config — configure a named agent (per-company data)

This skill sets the **per-company DATA** an agent needs. It does not change the
agent's **method** (that is the versioned skill served by Mission Control). Think:
this fills in *this company's* vendors, accounts, jobs, schedule, and switches —
the method stays the same for everyone.

**Input:** the agent to configure, by key or name (e.g. `vinnie-vendor-bill-coder`
or "Vinnie"). If the user didn't name one, ask which agent.

## Step 1 — Describe the agent and show current config

- Map the name to an `agent_key` (e.g. "Vinnie" → `vinnie-vendor-bill-coder`).
- Call **`describe_agent_config`** with that `agent_key`. In ONE call it returns
  everything you need:
  - `firstClassFields` — the cross-agent fields (enabled, `dry_run`,
    email_connections) with types and descriptions. (Agents always run the current
    skill version — there is no version to configure. **When an agent runs** is not
    configured here either — that is `/configure-scheduled-task`, which registers the
    cadence with the scheduler on this computer.)
  - `configSchema` — a JSON Schema for the agent-specific `config`: every field's
    name, type, allowed values, and description. This is authoritative — use it
    to know exactly what you may set; do not invent fields.
  - `configDefaults` — the defaults applied when a field is unset.
  - `current` — this company's current values, or null if never configured.
- Present the current state to the user (or "not configured yet"), and clearly
  state **`dry_run`** (true = performs no external writes) and `enabled`.

## Step 2 — Collect the changes

From `describe_agent_config`, walk the user through the fields that need setting or
changing. Only touch what they ask for. Note especially:
- `dry_run` — **defaults to true**; keep it true until the user has reviewed dry
  runs and explicitly wants live writes. Confirm before turning it off.
- `email_connections` — connection id(s) the agent may read; the user provides
  ids the company already owns.
- the agent-specific `config` — set exactly the fields the returned
  `configSchema` defines (e.g. for Vinnie: `searchQuery`, `vendors`, `jobAliases`,
  `roster`, thresholds).

## Step 3 — Apply with `upsert_agent_config`

- Call `upsert_agent_config` with the `agent_key` and only the fields being
  changed (it merges over existing values; `config` is merged then fully
  re-validated).
- If it returns a structured error (`isError` with `issues`), show the specific
  validation problems in plain language and correct them with the user — do not
  loop blindly. Common causes: an unknown field, a value out of range, a
  non-IANA timezone, or an `email_connections` id the company does not own
  (ownership is verified server-side and fails closed).

## Step 4 — Confirm

Read back the resulting config (from the tool's return), and explicitly restate
**dry-run and enabled** so the user knows whether the agent will actually write
anything on its next run.

## Guardrails
- Never invent config values. If you don't know a company's vendor id, GL
  account, or connection id, ask — do not guess.
- Turning `dry_run` off or `enabled` on means the agent can write to real systems
  on its next run. Confirm that's intended before doing it.
- You only configure agents here; you do not run them and you do not schedule them
  (that is `/configure-scheduled-task`).
