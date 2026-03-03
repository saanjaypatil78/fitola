# SUNRAY Ecosystem RBAC + Registration/KYC Specification

This quick spec is preserved for rapid onboarding. For complete technical documentation, refer to:

- `docs/SUNRAY_MASTER_PRD.md`
- `docs/SUNRAY_REGISTRATION_MODULE.md`
- `docs/SUNRAY_RBAC_ACCESS_CONTROL.md`

## Quick Controls

- 10 RBAC levels (Guest → Root)
- Permission domains: `reg:*`, `kyc:*`, `inv:*`, `ven:*`, `comm:*`, `pay:*`, `admin:*`, `sys:*`
- JWT + RBAC middleware on protected endpoints
- Zod request validation
- KYC-gated payout processing
- Idempotency keys for payout and commission processing
- Webhook batching with retry/backoff and dead-letter handling

## Minimum Test Coverage Areas

- RBAC allow/deny matrix by role level
- Validation tests for Aadhaar/PAN/IFSC
- Idempotency + concurrency tests for payouts
- Webhook retry/backoff + duplicate event tests
- Audit-log emission tests for sensitive actions
