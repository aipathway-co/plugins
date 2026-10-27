---
name: teach-dana
description: >
  Set Dana up for this company and teach her how its customer payments arrive —
  which QuickBooks account each connected bank account deposits into, which
  words on a bank deposit mean which customer, which remittance senders belong
  to which customer, and which deposits are not customer money (transfers,
  interest, refunds). Also answers "what does Dana know?".
  Use for "set up Dana", "teach Dana", "this deposit is from …, remember
  that", "what does Dana know".
triggers:
  - "teach dana"
  - "set up dana"
  - "onboard dana"
  - "dana learn from"
  - "what does dana know"
  - "teach dana a customer"
---

# Teach Dana (stub)

**You do not know how to do this from this file. This file is only a pointer.**
The real procedure is served by Mission Control. You MUST fetch it and follow it
exactly.

1. Call the Mission Control tool **`get_skill`** with
   `agent_key: "dana-deposit-matcher"` and `procedure: "teach"`.
2. Follow the returned `body` exactly.

## If you cannot get the procedure — STOP

If `get_skill` errors, returns no `body`, or is unavailable: **stop and report
that Dana's teaching procedure could not be loaded.** Do not teach from memory,
do not save lessons, and do not change settings from this stub.
