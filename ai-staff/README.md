# AI Staff

Named back-office agents from [AI Pathway](https://aipathway.co) that run inside
your own Cowork — **Vinnie the Vendor Bill Coder**, **Tina the Timecard
Validator** and **Dana the Deposit Matcher**.

Each agent in this plugin is intentionally **thin**: a discovery stub that, at run
time, fetches its authoritative and versioned procedure from the **Mission
Control** connector and follows it. The actual method (and your company's data)
never lives in this plugin — so agents improve on the server side without you
reinstalling anything.

## What's included
- **`ai-staff:vinnie-vendor-bill-coder`** — reads supplier invoices from your AP
  inbox and suggests a correctly coded QuickBooks bill for each (right vendor,
  job, cost account, class). Nothing is added until a person says yes. When he
  is not sure he says so: those suggestions are labeled "Best guess", and
  approving one teaches him.
- **`ai-staff:teach-vinnie`** — set Vinnie up and teach him how your company
  codes bills (suppliers, jobs, accounts), including rules of thumb Vinnie
  applies with judgment; ask what he knows.
- **`ai-staff:tina-timecard-validator`** — checks the timecards for the two work
  weeks just ended, before payroll, and reports what to fix. She changes nothing.
- **`ai-staff:dana-deposit-matcher`** — matches money that arrived in your bank
  accounts to customer invoices and suggests recording each customer payment in
  QuickBooks. Nothing is recorded until a person says yes.
- **`ai-staff:teach-dana`** — set Dana up and teach her how your customers' payments
  arrive (which bank account deposits into which QuickBooks account, who a deposit
  is from, which deposits are not customer money); ask what she knows.
- **`ai-staff:agent-config`** — how an agent operates: on/off, practice mode,
  mailbox, QuickBooks company, summary delivery. Never vendors or jobs.
- **`ai-staff:configure-scheduled-task`** — put an agent on a recurring schedule so
  it runs unattended, change or pause an existing schedule, and check whether any
  scheduled task has fallen behind.
- **`ai-staff:review-work-items`** — accept, reject or correct the agents'
  suggestions in chat; accepted bills are added and audited immediately, and
  corrections teach the agent.
- **`ai-staff:cfo-financial-analysis`** — prepares a financial analysis, or a
  30/60/90 financial plan when requested, using Mission Control's financial
  analysis preparation.

## Prerequisites (connect these first)
This plugin does nothing on its own. Before using it, your Cowork must be
connected to the two AI Pathway connectors, set up through your AI Pathway
onboarding:
1. **Mission Control** — serves each agent's method and holds its settings,
   what it has been taught, and the audit.
2. **QuickBooks** — where bills are read and created.

Without both connected (and an active subscription), the agents will stop and tell
you they can't run — by design.

## Getting started
1. Add the marketplace and install:
   ```
   /plugin marketplace add aipathway-co/plugins
   /plugin install ai-staff
   ```
2. Set up and teach Vinnie (one session with your bookkeeper):
   ```
   teach vinnie
   ```
   Vinnie starts in **practice mode**: he suggests bills but adds nothing.
   When his suggestions look right, take him out of practice mode with
   `/agent-config`.
3. Run it (`run vinnie`), or put it on a schedule:
   ```
   /configure-scheduled-task vinnie
   ```

## Safety model
- **Nothing is added without a yes** — every bill is a suggestion a person
  accepts, rejects or corrects.
- **Best guesses are labeled** — and never added without a yes.
- **Practice mode by default** — no agent writes to QuickBooks or sends email
  until you deliberately turn practice mode off.
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
