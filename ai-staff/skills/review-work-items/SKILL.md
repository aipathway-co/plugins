---
name: review-work-items
description: >
  Show what the AI staff (Vinnie, ...) are waiting on you for — suggested bills
  to accept, reject or correct, questions, things to teach, settings to fix —
  and record your decisions. Accepted bills are added right here in this chat
  and audited in Mission Control; corrections and answers teach the agent so it
  gets it right next time. Use when someone asks what needs them, wants to
  review suggestions, says "execute approved items", or when the review screen
  sends "Execute approved work items" or "I answered ... in the review".
triggers:
  - "review work items"
  - "what's pending"
  - "what needs my decision"
  - "review vinnie's suggestions"
  - "approve held bills"
  - "execute approved work items"
  - "I answered questions in the review"
---

# /review-work-items — decide what the AI staff suggested

**This file is only a pointer.** Mission Control holds the items and the rules.

The person reading is a bookkeeper. They know QuickBooks and the invoices. They
never have to learn how the agents work. Show only what they would recognize in
QuickBooks or on the invoice — never ids, item types, revisions or tool names.

1. Call **`review_work_items`**. It returns groups with exact counts:
   **invoices** (suggested bills and questions, oldest first), **teach**
   (things Vinnie wants to confirm before he relies on them) and **settings**.
   Page with `cursor` when there are more. If the person said "execute
   approved", call `list_work_items` with state `approved` and go to step 4.
2. Show each invoice as it comes back: **title, amount, summary**, and any
   choices listed under it. Show teach items grouped the way they come (by
   supplier, then job). Mention settings by count.
3. Collect decisions in their words and match them to items yourself by
   invoice number and vendor. Call **`decide_work_items`** once with all of
   them. Every decision carries the item's **`revision`** exactly as returned,
   and a new **`decision_id`** (a fresh UUID per decision; reuse it only when
   retrying the same call).
   - "Add it" → `approve`.
   - "It's the Friars Rd job" / "wrong vendor, it's Morsco" / "line 2 is
     rental" → `approve` with a **`correction`** (`job`, `vendor`, `lines`) in
     QuickBooks ids you looked up. In practice mode, `answer` with
     `{ correction }` instead. "Put all the lines on one job" is the only job
     correction; if they say only some lines belong elsewhere, ask which, and
     pass it as an `answer` so Vinnie re-codes it.
   - A question → `answer` with what they said.
   - A teach item → `answer` with the choice they confirm (or their
     correction), `reject` with their reason, or `dismiss` to skip.
   - "Don't add it" → `reject` with their words as the reason.
   Mission Control saves what the agent learns from these decisions. Never call
   `remember` for a decided item.
   If a decision comes back **"changed since you looked"**, show the new
   version and ask again.
4. For every item returned with `next: "execute"`, follow its **`procedure`**
   exactly, now, in this chat: it starts with **`claim_execution`**, checks
   QuickBooks, adds the bill from `effectiveProposal`, verifies it, then
   **`record_action`** with the claim. On failure **`fail_work_item`**.
   For `next: "recode"` or `next: "code"`, follow its **`procedure`**: Vinnie
   updates the suggestion with what he now knows and it comes back for a yes.
5. End with one plain line in QuickBooks words: "Added 5. Skipped 1 — already
   in QuickBooks as QB bill 30412. Didn't add 1." After corrections or answers,
   say what happens from now on: "Got it. PO 'QQ 48-241' goes to Friars Rd from
   now on."

## If a tool is missing or fails — STOP
Do not improvise a decision or a write. Report the error.
