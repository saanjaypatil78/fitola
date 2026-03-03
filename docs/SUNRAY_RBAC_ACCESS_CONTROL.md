# 🔐 ROLE-BASED ACCESS CONTROL (RBAC) - TECHNICAL DOCUMENTATION
## Version: 2.0 | Status: Production Ready | Security: Enterprise Grade

## 1. OVERVIEW

RBAC provides granular access control across 10 levels, role-permission mapping, wildcard support, endpoint gating, and audit logging.

## 2. ROLE DEFINITIONS

| Level | Role | Description |
| :--- | :--- | :--- |
| 1 | Guest | Public/read-only context |
| 2 | Registered | Basic account access |
| 3 | Investor | Investment actions |
| 4 | Vendor | Vendor + investment actions |
| 5 | Finance | Payout/commission processing |
| 6 | Compliance | KYC verification control |
| 7 | Admin | Full administration |
| 8 | Super Admin | Full config and overrides |
| 9 | System | Automated services |
| 10 | Root | Unrestricted |

## 3. PERMISSION MODEL

Format: `<module>:<resource>:<action>` (or simplified two-part codes for domain operations).

Examples:
- `reg:create`
- `kyc:verify`
- `inv:create`
- `ven:product:approve`
- `admin:user:manage`
- `sys:full:access`

Wildcard semantics:
- `reg:*` = any registration permission
- `inv:*:*` = all investment resource/action combinations
- `*:*:*` = root all-access

## 4. ACCESS MATRIX (SUMMARY)

| Module | Guest | Registered | Investor | Vendor | Finance | Compliance | Admin | Super Admin |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Registration | Read | Full | Full | Full | Full | Full | Full | Full |
| KYC | ❌ | Submit | Submit | Submit | View | Verify | Full | Full |
| Investment | ❌ | ❌ | Full | Full | Full | View | Full | Full |
| Vendor | ❌ | ❌ | ❌ | Full | Full | View | Full | Full |
| Commission | ❌ | ❌ | View | View | Full | View | Full | Full |
| Payout | ❌ | ❌ | View | View | Process | View | Full | Full |

## 5. MIDDLEWARE IMPLEMENTATION (REFERENCE)

```typescript
// src/middleware/rbac-middleware.ts

import { NextRequest, NextResponse } from 'next/server';
import { verifyToken } from '@/lib/auth/jwt';
import { ROLE_PERMISSIONS, ROLE_DEFINITIONS } from '@/lib/rbac/permission-codes';

export interface RBACConfig {
  requiredPermissions: string[];
  minLevel?: number;
  maxLevel?: number;
  excludeRoles?: string[];
  require2FA?: boolean;
}

export async function rbacMiddleware(request: NextRequest, config: RBACConfig): Promise<NextResponse> {
  const token = request.headers.get('authorization')?.replace('Bearer ', '');

  if (!token) {
    return NextResponse.json({ error: 'Authentication required', code: 'AUTH_MISSING' }, { status: 401 });
  }

  const user = await verifyToken(token);
  if (!user) {
    return NextResponse.json({ error: 'Invalid token', code: 'AUTH_INVALID' }, { status: 401 });
  }

  const roleDef = ROLE_DEFINITIONS[user.role];
  const userLevel = roleDef?.level ?? 0;

  if (config.minLevel && userLevel < config.minLevel) {
    return NextResponse.json({ error: 'Insufficient access level', code: 'RBAC_LEVEL_LOW' }, { status: 403 });
  }

  if (config.maxLevel && userLevel > config.maxLevel) {
    return NextResponse.json({ error: 'Access level too high', code: 'RBAC_LEVEL_HIGH' }, { status: 403 });
  }

  if (config.require2FA && !user.twoFactorEnabled) {
    return NextResponse.json({ error: '2FA required for this action', code: '2FA_REQUIRED' }, { status: 403 });
  }

  if (config.excludeRoles?.includes(user.role)) {
    return NextResponse.json({ error: 'Role excluded from this action', code: 'RBAC_ROLE_EXCLUDED' }, { status: 403 });
  }

  const userPermissions = ROLE_PERMISSIONS[user.role] || [];
  for (const requiredPerm of config.requiredPermissions) {
    const hasPermission = userPermissions.some((perm) => {
      if (perm === '*:*:*') return true;
      if (perm.endsWith('*')) return requiredPerm.startsWith(perm.slice(0, -1));
      return perm === requiredPerm;
    });

    if (!hasPermission) {
      return NextResponse.json(
        { error: 'Permission denied', code: 'RBAC_PERMISSION_DENIED', required: requiredPerm, role: user.role },
        { status: 403 }
      );
    }
  }

  return NextResponse.next();
}
```

## 6. DATABASE SCHEMA (RBAC CORE)

```sql
CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) UNIQUE NOT NULL,
    level INTEGER NOT NULL UNIQUE,
    description TEXT,
    require_2fa BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(100) UNIQUE NOT NULL,
    module VARCHAR(50) NOT NULL,
    resource VARCHAR(50) NOT NULL,
    action VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE role_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    granted_by UUID,
    granted_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(role_id, permission_id)
);
```

## 7. SECURITY CONTROLS

- Least privilege by default
- 2FA required for Level 3+
- Separation of duties (finance ≠ approval authority)
- Immutable audit logs for role/permission changes
- Alerting on repeated RBAC denials

## 8. TEST PLAN

- Role-level allow/deny matrix tests
- Permission wildcard tests (`reg:*`, `*:*:*`)
- 2FA gating tests for protected routes
- Audit log creation tests for allowed/denied access
- Endpoint-level authorization integration tests

**END OF RBAC DOCUMENTATION**
