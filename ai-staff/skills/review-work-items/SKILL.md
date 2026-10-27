---
name: review-work-items
description: >
  Show what the AI staff (Vinnie, Dana, ...) are waiting on you for — suggested
  bills and payments to accept, reject or correct, questions, things to teach,
  settings to fix — and record your decisions. Accepted suggestions are written
  to QuickBooks right here in this chat and audited in Mission Control;
  corrections and answers teach the agent so it gets it right next time. Use
  when someone asks what needs them, wants to review suggestions, says "execute
  approved items", or when the review screen sends "Execute approved work
  items" or "I answered ... in the review".
triggers:
  - "review work items"
  - "what's pending"
  - "what needs my decision"
  - "review vinnie's suggestions"
  - "review dana's suggestions"
  - "approve held bills"
  - "approve suggested payments"
  - "execute approved work items"
  - "I answered questions in the review"
---

# /review-work-items — decide what the AI staff suggested

**This file is only a pointer.** Mission Control holds the items, the rules and
the procedure for each kind of write.

The person reading is a bookkeeper. They know QuickBooks, their invoices and
their bills. They never have to learn how the agents work. Show only what they
would recognize in QuickBooks, on an invoice or on a bank statement — never ids,
item types, revisions or tool names.

1. Call **`review_work_items`**. It returns groups with exact counts:
   **`invoices`** ("To review": suggestions and questions, oldest first),
   **`teach`** ("Please confirm": things an agent wants to confirm before it
   relies on them) and **`settings`**. Page with `cursor` when there are more.
   If the person said "execute approved", call `list_work_items` with state
   `approved` and go to step 4.
2. Show each item to review as it comes back: **title, amount, summary**, and
   any choices listed under it. Show teach items grouped the way they come.
   Mention settings by count.
3. Collect decisions in their words and match them to items yourself by what
   they named (an invoice number, a vendor, a customer, an amount). Call
   **`decide_work_items`** once with all of them. Every decision carries the
   item's **`revision`** exactly as returned, and a new **`decision_id`** (a
   fresh UUID per decision; reuse it only when retrying the same call).
   - "Add it" / "record it" → `approve`.
   - A change to a suggested bill → `approve` with a **`correction`** (`job`,
     `vendor`, `lines`) in QuickBooks ids you looked up; in practice mode,
     `answer` with `{ correction }` instead. For example (a bill): "it's the
     Main St job" or "line 2 is rental". "Put all the lines on one job" is the
     only job correction; if they say only some lines belong elsewhere, ask
     which, and pass it as an `answer`.
   - Any other change → `answer` with what they said, and the agent re-works
     the suggestion. For example (a payment): "it pays invoices 1043 and 1047,
     not 1042".
   - A question → `answer` with what they said.
   - A teach item → `answer` with the choice they confirm (or their
     correction), `reject` with their reason, or `dismiss` to skip.
   - "Don't add it" / "don't record it" → `reject` with their words as the
     reason.
   Mission Control saves what the agent learns from these decisions. Never call
   `remember` for a decided item.
   If a decision comes back **"changed since you looked"**, show the new
   version and ask again.
4. Every decided item comes back with a **`next`** and the **`procedure`** for
   that item's kind of write (a bill, a customer payment, ...). Follow the
   returned `procedure` exactly, now, in this chat — never one from memory or
   from another item.
   - `next: "execute"` (approved): the procedure claims the item
     (**`claim_execution`**), re-checks QuickBooks, writes exactly the approved
     transaction from `effectiveProposal`, verifies it, then records it with
     **`record_action`** and the claim. On failure, **`fail_work_item`**.
   - `next: "recode"` or `next: "code"` (answered or corrected): the agent named
     on the item re-works it with what it now knows, and it comes back for a
     yes.
5. End with one plain line in QuickBooks words. For example: "Added 5 bills.
   Skipped 1 — already in QuickBooks as bill 30412. Didn't add 1." or "Recorded
   3 customer payments. Skipped 1 — already in QuickBooks." After corrections or
   answers, say what happens from now on. For example: "Got it. PO 'QQ 48-241'
   goes to the Main St job from now on." or "Got it. Deposits that say 'ACME
   BUILDERS' are from Acme Builders from now on."

## If a tool is missing or fails — STOP
Do not improvise a decision or a write. Report the error.
