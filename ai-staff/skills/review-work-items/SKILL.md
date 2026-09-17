---
name: review-work-items
description: >
  Show what the AI staff (Vinnie, Dana, ...) are waiting on you to decide —
  held bills, questions, settings to fix — and record your decisions and
  answers. Approved items are executed immediately in this chat and audited in
  Mission Control; answers are remembered so the agent never asks again.
  Use when someone asks what needs their decision/approval, wants to review or
  approve held items, says "execute approved items", or when a review widget
  sends "Execute approved work items" or "I answered ... in the review".
triggers:
  - "review work items"
  - "what's pending"
  - "what needs my decision"
  - "approve held bills"
  - "execute approved work items"
  - "I answered questions in the review"
  - "what did <agent> hold"
---

# /review-work-items — decide what the AI staff held for you

**This file is only a pointer.** Mission Control holds the items and the rules.

The person reading is a bookkeeper. They know QuickBooks and the invoices. They
do not know how the agents work and never have to learn it. Everything you show
them uses only what they would recognize in QuickBooks or on the invoice.

1. Call **`review_work_items`** (optionally `agent_key`). It returns two lists:
   **invoices** that need a decision, oldest first, and **settings to fix**. If the
   user said "execute approved", call `list_work_items` with state `approved`
   instead. If they said they answered questions in the review, call
   `list_work_items` with state `answered` and go straight to step 4.
2. Show each invoice as it comes back: **title, amount, summary.** Nothing else —
   no agent name, no confidence, no item type, no ids, no expiry. For an approval,
   the summary already says what would be added and where. Never invent details.
   A question may list choices under it; show them as it gives them. Mention the
   settings list by count ("3 settings to fix") and show its titles only if the
   user asks.
3. Collect decisions in their words ("add INV-10442", "the SHOP one is
   Riverside Clinic", "skip the credit"). Match them to items yourself by invoice
   number and vendor; never ask for an id. Then call **`decide_work_items`** with
   ALL of them in one batch: `approve` (optionally with `edits`), `reject` (a
   `reason` is required — use their words), `dismiss` / `acknowledge` for
   settings items. **When they say what is RIGHT** — "the SHOP one is Riverside
   Clinic", "that's a business expense", "wrong job, it's the Lofts" — that is
   `answer`, not reject: pass `answer` with what they said, in the QuickBooks
   ids you looked up. `decided_via: "chat"`.
4. For every returned item with `next: "execute"`, follow the returned
   **`procedure`** exactly and immediately, in this chat: check QuickBooks first,
   execute `effectiveProposal`, verify after write, then **`record_action`** with
   `work_item_id`. On failure **`fail_work_item`**. For every item with
   `next: "code"` (or listed as `answered`), follow its **`procedure`**: it
   loads the agent's method, has you **`remember`** the lesson, and brings the
   invoice back re-coded for them to approve.
5. End with one plain line in QuickBooks words, invoice numbers and QuickBooks
   bill numbers only: "Added 5. Skipped 1 — already in QuickBooks as QB bill
   30412. Didn't add 1." After answers, say what will happen from now on:
   "Got it. Ship-to 'ACME #1420' goes to Riverside Clinic from now on."

## If a tool is missing or fails — STOP
Do not improvise a decision or a write. Report the error.
