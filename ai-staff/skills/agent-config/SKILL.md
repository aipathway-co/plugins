---
name: agent-config
description: >
  Change how a named agent OPERATES for this company: turn it on or off, put it
  in or take it out of practice mode (dry run), choose which mailbox it reads,
  confirm which QuickBooks company it works in, how many days back it looks,
  and where its run summary goes. Use for "turn Vinnie on", "take Vinnie out of
  practice mode", "change Vinnie's mailbox", "what are Vinnie's settings".
  NOT for vendors, jobs, accounts, classes or senders — those are TAUGHT, not
  configured: use teach-vinnie.
triggers:
  - "agent settings"
  - "turn <agent> on"
  - "turn <agent> off"
  - "put <agent> in practice mode"
  - "take <agent> out of practice mode"
  - "change <agent>'s mailbox"
  - "what are <agent>'s settings"
---

# /agent-config — how an agent operates (settings only)

Settings say how an agent **operates**. They never say how the company **codes
bills**. Anything that names a supplier, account, class, job, PO, ship-to or
sender is knowledge: the agent learns it from a person through `teach-vinnie`
and through the bookkeeper's answers and corrections. Mission Control refuses
those keys here; do not try to put them in.

**Input:** the agent, by key or name ("Vinnie" → `vinnie-vendor-bill-coder`).
If none was named or it is ambiguous, call `list_agents` and ask.

## Step 1 — Show the current settings

Call **`get_agent_settings`** with the `agent_key`. Show, in plain words:
- on or off (`enabled`)
- practice mode (`dryRun`): true means the agent suggests but never adds
  anything to QuickBooks
- the mailbox it reads (by address or label from `available_email_connections`,
  never by id)
- the QuickBooks company it is locked to (`expectedCompanyName`), if set
- how many days back it looks (`lookbackDays`) and where its summary goes
  (`summaryDelivery`, `summaryEmail`)

If it returns `configured: false`, the agent was never set up: offer `teach-vinnie`, which
sets these up first and then teaches.

## Step 2 — Change only what they asked

Call **`update_agent_settings`** with only the fields being changed:
`enabled`, `dry_run`, `email_connections` (ids from
`available_email_connections` — never guessed), and `settings`
(`lookbackDays`, `summaryDelivery`, `summaryEmail`, `expectedCompanyName`,
`expectedRealmId`).

- **Practice mode off** or **turning the agent on** means real changes in
  QuickBooks once a person accepts a suggestion. Confirm that is intended.
- The QuickBooks company can be set once and is then locked. If Mission Control
  refuses a change to it, say so plainly: moving an agent to a different
  QuickBooks company is done by AI Pathway, not here.
- If Mission Control refuses a key because it is knowledge (a vendor, job,
  account…), explain that and offer `teach-vinnie`.

## Step 3 — Confirm

Read back what the tool returned, and restate **on/off and practice mode** so
the person knows whether anything can be added to QuickBooks.

## Guardrails
- Never invent a value or an id. Ask.
- You do not teach, run or schedule agents here (`teach-vinnie`, "run vinnie",
  `/configure-scheduled-task`).
