---
name: configure-scheduled-task
description: >
  Set up, change, or check a recurring scheduled run for a named agent (Vinnie,
  Dana, ...) so it runs unattended on a schedule. Use when someone wants an agent
  to run automatically ("schedule Vinnie", "run the vendor bill coder every
  morning", "automate the daily AP run"), wants to change or pause an existing
  schedule, or asks what is currently scheduled. Works for ANY agent by key or name.
triggers:
  - "schedule <agent>"
  - "set up a scheduled task"
  - "run <agent> every morning"
  - "automate <agent>"
  - "change <agent>'s schedule"
  - "what's scheduled"
  - "which agents run automatically"
---

# /configure-scheduled-task — put a named agent on a schedule

**This file is only a pointer.** Mission Control writes the instructions a scheduled
run follows; this skill collects the cadence and registers the task with the
scheduler on this computer.

**Why it works this way:** a scheduled run is a *cold session*. It has the Mission
Control and QuickBooks connectors, but it does **not** have this plugin — no skill
of ours is discoverable there. So the task's prompt has to stand completely on its
own, and Mission Control is what writes it, versioned, for every company at once.
**You never write, edit, summarize, or "improve" that prompt.** Pass it through
exactly as returned.

**Input:** the agent to schedule, by key or name (e.g. `vinnie-vendor-bill-coder`
or "Vinnie"). If the user named no agent, go to **Check mode** below.

## Step 1 — Resolve the agent and ask Mission Control

- Map the name to an `agent_key` ("Vinnie" → `vinnie-vendor-bill-coder`). If it is
  ambiguous, call `list_agent_configs` and ask which one.
- Call **`get_scheduled_task`** with that `agent_key`.

**If `get_scheduled_task` does not exist or is unavailable — STOP.** Report that
scheduled-task setup is not available and the Mission Control connector needs
updating. Do **not** write a task prompt yourself, and do **not** create a task
anyway. A missing tool means no schedule — never a hand-rolled one.

## Step 2 — Blockers and warnings

- **`ok: false`** — the agent cannot usefully run on a schedule yet. Present each
  blocker's `message` and `fix` in plain language and hand off to `/agent-config`.
  **Create nothing.** A task that fires at 8am and does nothing is worse than no task.
- **`ok: true`** — present any `warnings` and get an explicit yes before continuing.
  On `dry_run`, say **"the method is intended not to perform external writes"** —
  not "no writes will happen." Dry-run is procedure plus server-side coercion for
  work items, not a lock on the accounting tools. Never promise a guarantee the
  system cannot keep.

## Step 3 — Check for an existing schedule FIRST

Call **`list_scheduled_tasks`** and look for the `taskId` Mission Control returned.
**Never build a task id yourself** — always use the one from `get_scheduled_task`.

- **Found** → say so, show its current cadence and `nextRunAt`, and default to
  **`update_scheduled_task`**. Do not create a second task by accident.
- The user may still want an *additional* schedule. That is allowed, but only after
  they have been told one already exists, and only with an explicit suffix appended
  to Mission Control's id (`<taskId>-<suffix>`). Tell them plainly: two tasks means
  two independent runs of the same agent.

## Step 4 — Get the cadence from the user

Ask for it in their own words ("8am every Tuesday") and convert to a 5-field cron.
The scheduler reads cron in **this computer's local time**, so there is no timezone
to convert — say the time back to them and move on.

Avoid 01:00–03:00 local if the user is flexible: cron has no daylight-saving
awareness, so a time inside the transition window is skipped in spring and can fire
twice in autumn. Nudge to a neighbouring hour; do not silently move their time.

## Step 5 — Register it

Call `create_scheduled_task` (or `update_scheduled_task`) passing `prompt`,
`taskId`, `title`, and `description` **verbatim** from `get_scheduled_task`, plus
the cron you just agreed.

## Step 6 — Confirm against the scheduler, not your own arithmetic

Read the task back with `list_scheduled_tasks` and show the user its **`nextRunAt`**
in plain English — "next run: Tuesday 16 September, 8:00am." Translating words into
cron is easy to get subtly wrong (day-of-week numbering especially), and the
scheduler already computed the truth. If `nextRunAt` is not what they meant, fix the
cron and confirm again before finishing.

## Step 7 — Receipt

End with a short receipt: operation (created / updated), task id, cron, next run,
and `promptVersion`. Then state the agent's **current dry-run setting, read live
from Mission Control**, and note that it is dynamic — whatever `dry_run` says at fire
time is what applies, not what it said today.

## Check mode — no agent named

1. `list_scheduled_tasks`, keep the tasks whose id starts with `aipathway-`.
2. For each, read the `v<N>·<hash>` stamp out of its `description` and compare it to
   the `promptVersion` from `get_scheduled_task` for that agent. Offer to refresh any
   that are behind, with `update_scheduled_task`.
3. If a task's stamp is missing or unreadable, report **"unable to verify"** and offer
   a refresh. Never treat an unreadable task as up to date — a silently stale prompt
   is the exact thing this mode exists to catch.
4. Report each task's `enabled` flag. A **paused** task looks scheduled and produces
   nothing; offer to re-enable or delete it.

## Guardrails
- Never author, edit, or summarize the runner prompt. It comes from Mission Control
  or it does not exist.
- Never create a task for an agent that returned blockers.
- Never invent a task id, a cron the user did not agree to, or a schedule for an
  agent you could not resolve.
- You schedule agents here; you do not run them and you do not configure them
  (that is `/agent-config`).
