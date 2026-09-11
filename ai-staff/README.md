# AI Staff

Named back-office agents from [AI Pathway](https://aipathway.co) that run inside
your own Cowork — starting with **Vinnie the Vendor Bill Coder**.

Each agent in this plugin is intentionally **thin**: a discovery stub that, at run
time, fetches its authoritative and versioned procedure from the **Mission
Control** connector and follows it. The actual method (and your company's data)
never lives in this plugin — so agents improve on the server side without you
reinstalling anything.

## What's included
- **`ai-staff:vinnie-vendor-bill-coder`** — reads supplier invoices from your AP
  inbox and turns them into correctly coded QuickBooks bills (right vendor, job,
  cost account, class), holding anything it can't code confidently.
- **`ai-staff:agent-config`** — configure any agent's per-company settings
  (vendors, accounts, dry-run, email connections).
- **`ai-staff:configure-scheduled-task`** — put an agent on a recurring schedule so
  it runs unattended, change or pause an existing schedule, and check whether any
  scheduled task has fallen behind.
- **`ai-staff:review-work-items`** — see what the agents held for your decision,
  approve/reject in chat, and have approved items executed and audited immediately.

## Prerequisites (connect these first)
This plugin does nothing on its own. Before using it, your Cowork must be
connected to the two AI Pathway connectors, set up through your AI Pathway
onboarding:
1. **Mission Control** — serves each agent's method and holds config + audit.
2. **QuickBooks** — where bills are read and created.

Without both connected (and an active subscription), the agents will stop and tell
you they can't run — by design.

## Getting started
1. Add the marketplace and install:
   ```
   /plugin marketplace add aipathway-co/plugins
   /plugin install ai-staff
   ```
2. Configure an agent:
   ```
   /agent-config vinnie-vendor-bill-coder
   ```
   New configs start in **dry-run** (the agent analyzes and reports but writes
   nothing) — review a dry run before turning it live.
3. Run it (`run vinnie`), or put it on a schedule:
   ```
   /configure-scheduled-task vinnie
   ```

## Safety model
- **Dry-run by default** — no agent writes to QuickBooks or sends email until you
  deliberately turn dry-run off.
- **Fail closed** — if an agent can't load its method or verify entitlement, it
  stops rather than guessing.
- **Audited** — every write an agent makes is recorded in Mission Control.
- **Scheduled runs are unattended** — nobody is present to approve anything, so a
  scheduled run leaves decisions as work items for `/review-work-items` instead of
  acting on them. An agent that is switched off, unconfigured, or missing its mailbox
  will not be scheduled in the first place.

---
© AI Pathway. The agent stubs here are open; the methods they run and the Mission
Control service are proprietary.
