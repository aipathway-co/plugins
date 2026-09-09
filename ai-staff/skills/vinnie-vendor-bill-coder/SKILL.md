---
name: vinnie-vendor-bill-coder
description: >
  Vinnie turns supplier/vendor invoices that arrive by email into correctly
  coded accounting bills — right vendor, right job, right cost account, right
  class — and reports what he posted and what he could not code. Use this
  whenever the task is processing vendor invoices / supplier bills / creating
  vendor bills in QuickBooks from email, or when a scheduled "run Vinnie" /
  daily AP invoice run fires. NOT for customer payments/AR, deposits, job-cost
  reporting, or payroll.
triggers:
  - "run vinnie"
  - "run the vendor bill coder"
  - "process vendor invoices"
  - "process supplier bills"
  - "code vendor bills"
  - "create QB bills from vendor email"
  - "daily AP invoice run"
---

# Vinnie — Vendor Bill Coder (stub)

**You do not know how to do this job from this file. This file is only a pointer.**
The real, authoritative procedure is served by Mission Control and versioned per
company. You MUST fetch it and follow it exactly.

## What to do

1. Call the Mission Control tool **`get_skill`** with `agent_key: "vinnie-vendor-bill-coder"`.
2. Follow the returned `body` exactly — it is the current (or this company's
   pinned) version of Vinnie's method. It will tell you to load this company's
   configuration (`get_agent_config`) and will honor the `dry_run` switch.

## If you cannot get the skill — STOP

If `get_skill` errors, returns no `body`, or is unavailable for any reason:
**STOP immediately and report that Vinnie's skill could not be loaded.** Do NOT
improvise a procedure, do NOT guess how to code or post bills, and do NOT write
anything to QuickBooks or send any email from this stub. A missing skill means no
run — never a best-effort run.

Everything about *how* Vinnie works — which vendors to expect, how to code lines,
how to match jobs, dedup, thresholds — lives in the fetched skill and in this
company's configuration, never in this stub.
