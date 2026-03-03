# SUNRAY Excel Integration & Optimisation Plan (No Structure/Logic Changes)

> This document is retained as a focused Excel companion. For full platform specifications, see:
>
> - `docs/SUNRAY_MASTER_PRD.md`
> - `docs/SUNRAY_REGISTRATION_MODULE.md`
> - `docs/SUNRAY_RBAC_ACCESS_CONTROL.md`

## Guardrails

- No sheet structure changes.
- No percentage changes.
- No payout or commission logic changes.
- Monitoring and planning additions only.

## Core Additions (Non-invasive)

1. **MASTER_DASHBOARD** with direct linked references from existing sheets.
2. **Sustainability Ratio** = `Total_Inflow / Total_Outflow`.
3. **Break-even Monitor** = `Total_Outflow`.
4. **Projection Block** = `Current_Investment * (1 + Growth_Rate)^Months`.
5. **Risk Alert** with IF condition on sustainability ratio.
6. **Commission Transparency** (Gross, Admin Charge 10%, Net).
7. **Compliance Overlay** (GST/TDS/withdrawal tracker).
8. **Cash Flow Tracker** = `Opening_Balance + New_Investment - Total_Payout`.

## Formula Correction Note

Use assignment-free Excel formulas. For example:

```excel
=Opening_Balance + New_Investment - Total_Payout
```

not:

```excel
=Closing_Balance = Opening_Balance + New_Investment - Total_Payout
```
