---
name: cfo-financial-analysis
description: >
  Prepare a CFO financial analysis or a 30/60/90 plan through Mission Control.
  Use when someone asks for financial analysis, a CFO review, or a financial
  plan/roadmap. NOT for vendor-bill coding, agent configuration, or work-item
  approval.
triggers:
  - "financial analysis"
  - "CFO analysis"
  - "CFO review"
  - "financial plan"
  - "financial roadmap"
  - "30 60 90 financial plan"
---

# CFO Financial Analysis (stub)

**You do not know how to perform this work from this file. This file is only a
pointer.** Mission Control is the sole authoritative source for the method and
financial guidance. Do not call `get_skill` or any named-agent skill operation
for this task.

## Prepare the analysis

1. Set `query` to the user's request, preserving its meaning and requested scope.
2. Set `response_format` to `30_60_90_plan` **only** when the user asks for a plan
   or roadmap. Otherwise set it to `financial_analysis`. These are the only
   permitted response formats.
3. Call the dedicated Mission Control MCP operation
   **`prepare_financial_analysis`** with `query` and `response_format`.

## Follow the preparation exactly

- If preparation fails, is unavailable, or does not return the required
  `dataGatheringMethod`, `finalAnalysisMethod`, and selected financial guidance,
  **STOP**. State that financial analysis preparation could not be completed. Do
  not infer missing instructions, retrieve substitute data, or provide financial
  conclusions.
- Follow the returned `dataGatheringMethod` exactly. Retrieve only the data it
  requires, and only through approved MCP tools.
- If a required data source, approved MCP tool, or required data is unavailable,
  **STOP**. Report the unavailable requirement without producing financial
  conclusions.
- After the required data is available, follow the returned `finalAnalysisMethod`
  and the selected financial guidance exactly to produce the requested response.

## Guardrails

- Mission Control supplies the method and guidance; this plugin contains neither.
- Never use named-agent `get_skill` as a fallback or substitute.
- Never invent, estimate, or fill gaps in financial data, analysis, conclusions,
  recommendations, or a plan.
