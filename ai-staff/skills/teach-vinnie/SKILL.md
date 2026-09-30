---
name: teach-vinnie
description: >
  Set Vinnie up for this company and teach him how it codes supplier bills —
  which QuickBooks vendor and account each supplier uses, which job a ship-to,
  PO or account number belongs to, which PO words are just crew shorthand,
  which senders never send invoices. Also answers "what does Vinnie know?".
  Use for "set up Vinnie", "teach Vinnie", "Vinnie, learn from what we
  entered", "this invoice goes to …, remember that", "what does Vinnie know".
triggers:
  - "teach vinnie"
  - "set up vinnie"
  - "onboard vinnie"
  - "vinnie learn from"
  - "what does vinnie know"
  - "show vinnie an invoice"
---

# Teach Vinnie (stub)

**You do not know how to do this from this file. This file is only a pointer.**
The real procedure is served by Mission Control. You MUST fetch it and follow it
exactly.

1. Call the Mission Control tool **`get_skill`** with
   `agent_key: "vinnie-vendor-bill-coder"` and `procedure: "teach"`.
2. Follow the returned `body` exactly.

## If you cannot get the procedure — STOP

If `get_skill` errors, returns no `body`, or is unavailable: **stop and report
that Vinnie's teaching procedure could not be loaded.** Do not teach from memory,
do not save lessons, and do not change settings from this stub.
