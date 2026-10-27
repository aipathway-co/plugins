---
name: agent-config
description: >
  Change how a named agent OPERATES for this company: turn it on or off, put it
  in or take it out of practice mode (dry run), choose which mailbox it reads,
  confirm which QuickBooks company it works in, how many days back it looks,
  and where its run summary goes. Use for "turn Vinnie on", "take Vinnie out of
  practice mode", "change Vinnie's mailbox", "what are Vinnie's settings".
  NOT for vendors, jobs, accounts, classes or senders — those are TAUGHT, not
  configured: use teach-vinnie (or teach-dana for Dana).
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
sender is knowledge: the agent learns it from a person through its teach skill
(`teach-vinnie`, `teach-dana`) and through the bookkeeper's answers and
corrections. Mission Control refuses those keys here; do not try to put them in.

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

If it returns `configured: false` for Vinnie, he was never set up: offer `teach-vinnie`, which
sets these up first and then teaches. The same goes for Dana with `teach-dana`.

**Dana (`dana-deposit-matcher`) has Vinnie's settings.** `lookbackDays` is how
many days of bank deposits she reads. Her mailbox is optional: when one is bound
she reads customers' remittance emails to see what a deposit pays. Connecting
a bank account is not a setting here.

**Tina (`tina-timecard-validator`) has different settings and no teaching.** Show
her state (`state`, California only for now), time zone (`timeZone`, a name like
America/Los_Angeles), the day her work week starts (`workweekStartsOn`), when her
workday starts (`workdayStartsAt`, midnight if not set), and where her summary goes
(`summaryDelivery`, `summaryEmail`). The first four are set once and then locked;
read them back and confirm before saving. In practice mode Tina prints her
summary and never emails it; taking her out of practice mode means her weekly
summary is emailed to `summaryEmail`, on scheduled runs too. She never changes a
timecard. Her timecard database is connected by AI Pathway, not here.

## Step 2 — Change only what they asked

Call **`update_agent_settings`** with only the fields being changed:
`enabled`, `dry_run`, `email_connections` (ids from
`available_email_connections` — never guessed), and `settings`
(`lookbackDays`, `summaryDelivery`, `summaryEmail`, `expectedCompanyName`,
`expectedRealmId`; for Tina `state`, `timeZone`, `workweekStartsOn`,
`workdayStartsAt`, `summaryDelivery`, `summaryEmail`).

- **Practice mode off** or **turning the agent on** means real changes in
  QuickBooks once a person accepts a suggestion. Confirm that is intended.
- The QuickBooks company can be set once and is then locked. If Mission Control
  refuses a change to it, say so plainly: moving an agent to a different
  QuickBooks company is done by AI Pathway, not here.
- If Mission Control refuses a key because it is knowledge (a vendor, job,
  account…), explain that and offer `teach-vinnie` (or `teach-dana` for Dana).

## Step 3 — Confirm

Read back what the tool returned, and restate **on/off and practice mode** so
the person knows whether anything can be added to QuickBooks.

## Guardrails
- Never invent a value or an id. Ask.
- You do not teach, run or schedule agents here (`teach-vinnie`, `teach-dana`,
  "run vinnie", "run dana", `/configure-scheduled-task`).
