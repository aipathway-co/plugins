---
name: review-work-items
description: >
  Show what the AI staff (Vinnie, Dana, ...) are waiting on you to decide —
  held bills, detections, questions — and record your decisions. Approved
  items are executed immediately in this chat and audited in Mission Control.
  Use when someone asks what needs their decision/approval, wants to review or
  approve held items, says "execute approved items", or when a review widget
  sends "Execute approved work items".
triggers:
  - "review work items"
  - "what's pending"
  - "what needs my decision"
  - "approve held bills"
  - "execute approved work items"
  - "what did <agent> hold"
---

# /review-work-items — decide what the AI staff held for you

**This file is only a pointer.** Mission Control holds the items and the rules.

1. Call **`list_work_items`** (state `pending`, optionally `agent_key`). If the user
   said "execute approved", list state `approved` instead.
2. Present each item: agent, title, summary (why it was held), amount, confidence,
   and for approvals the proposal in plain words. Never invent details.
3. Collect decisions. Then call **`decide_work_items`** with ALL of them in one
   batch: `approve` (optionally with `edits`), `reject` (a `reason` is required),
   `dismiss` / `acknowledge` for detections. `decided_via: "chat"`.
4. For every returned item with `next: "execute"`, follow the returned
   **`procedure`** exactly and immediately, in this chat: check the system of
   record first, execute `effectiveProposal`, verify after write, then
   **`record_action`** with `work_item_id`. On failure **`fail_work_item`**.
5. End with one counted line: "N approved and executed, M rejected, K failed".

## If a tool is missing or fails — STOP
Do not improvise a decision or a write. Report the error.
