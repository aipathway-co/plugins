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
pointer.** Mission Control is the sole authoritative source for the method,
guidance, data requirements, and user-result contract. Do not call `get_skill`
or any named-agent skill operation for this task.

## Prepare the analysis

1. Set `query` to the user's request, preserving its meaning and requested scope.
2. Set `response_format` to `30_60_90_plan` **only** for an explicit plan or
   roadmap request. Otherwise set it to `financial_analysis`. These are the only
   permitted response formats. For example, “analyze our cash position” uses
   `financial_analysis`; “give me a 90-day cash-improvement roadmap” uses
   `30_60_90_plan`.
3. Infer the relevant focus from the user request and pass only applicable values
   from `profitability`, `cash_liquidity`, `project_labor`, and `cogs`. Omit
   `focus` when none applies. Do not add financial-domain selection rules here.
4. Pass `accounting_basis` only when known, as `Cash` or `Accrual`; otherwise
   omit it and follow the returned basis-discovery instructions.
5. Call the dedicated Mission Control MCP operation
   **`prepare_financial_analysis`** with `query`, `response_format`, and the
   applicable optional inputs.

## Hard circuit breaker

**STOP** if Mission Control preparation fails or is unavailable, or if its result
has no usable `phases.data_gathering`, `phases.final_analysis`, or
`selected_guidance_modules`. State that financial analysis preparation could not
be completed. Do not infer missing instructions, retrieve substitute data, or
provide financial conclusions.

## Follow the preparation exactly

- Treat `phases.data_gathering`, `phases.final_analysis`, and
  `selected_guidance_modules` as the only method and guidance sources.
- Determine the reporting period and comparison period, if any, from the user's
  request. If none is stated, use the most recent complete month. State that
  default in **Scope, basis, and period**, or in **Data gaps and assumptions**
  for a 30/60/90 plan.
- Retrieve each `required_data` item using the available connected tools. Do not
  require a tool name or parameters from another MCP server.
- **STOP** if any required-data item cannot be retrieved because no suitable tool
  is connected or retrieval fails. State which item could not be retrieved and
  provide no financial conclusions.
- Treat `optional_data` entries as optional. If an optional-data retrieval fails
  or is unavailable, continue and include that item in **Data gaps and
  assumptions**; it must not stop the run.
- If `accounting_basis` was omitted and the balance sheet identifies the company's
  default accounting basis, call `prepare_financial_analysis` again with the
  discovered `accounting_basis` before final analysis. Apply the hard circuit
  breaker to the new preparation result and then follow its returned method.
- Follow `phases.final_analysis` and `selected_guidance_modules` exactly after
  preparation and data gathering.
- Structure the response using `response_contract` sections and rules. Do not add
  a parallel analysis, conclusions, recommendations, plan, or formatting outside
  that contract.

## Guardrails

- Mission Control supplies the method, guidance, data requirements, and response
  contract; this plugin contains none of them.
- Read-only: never write to an accounting system.
- Never use named-agent `get_skill` as a fallback or substitute.
- Never invent data. Label any estimates, projections, or assumptions.
