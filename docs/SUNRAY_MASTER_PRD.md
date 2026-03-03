# 🌟 SUNRAY ECOSYSTEM - MASTER PRODUCT REQUIREMENTS DOCUMENT
## Version: 2.0 | Status: Production Ready | Last Updated: January 2025

---

## 📋 TABLE OF CONTENTS

1. [Executive Summary](#1-executive-summary)
2. [System Overview](#2-system-overview)
3. [Role-Based Access Control (RBAC)](#3-role-based-access-control-rbac)
4. [Investment Plan Module](#4-investment-plan-module)
5. [Vendor Plan Module](#5-vendor-plan-module)
6. [Commission & Royalty Engine](#6-commission--royalty-engine)
7. [Autonomous Webhook System](#7-autonomous-webhook-system)
8. [Registration & KYC Module](#8-registration--kyc-module)
9. [Product Listing Strategy](#9-product-listing-strategy)
10. [Security & Compliance](#10-security--compliance)
11. [Technical Architecture](#11-technical-architecture)
12. [Implementation Roadmap](#12-implementation-roadmap)

---

## 1. EXECUTIVE SUMMARY

### 1.1 Project Vision
Build a complete investment and vendor ecosystem with autonomous webhook-driven operations, progressive commission structures, bi-directional rank management, and strategic product listing - all optimized for 98% cost reduction.

### 1.2 Key Metrics
| Metric | Target | Current |
| :--- | :--- | :--- |
| **Investor Return** | 15% monthly | ✅ Configured |
| **Vendor Return** | 25% monthly (active) | ✅ Configured |
| **Operational Cost** | <₹6,000/month | ✅ 98% reduction |
| **API Calls** | <200/day | ✅ Webhook-driven |
| **Success Rate** | >85% | ✅ Strategic timing |
| **Compliance** | KYC/AML 100% | ✅ Integrated |

### 1.3 Stakeholders
| Role | Responsibility | Access Level |
| :--- | :--- | :--- |
| **Investors** | Capital investment | Level 1-3 |
| **Vendors** | Product listing + investment | Level 1-4 |
| **Admins** | System management | Level 5-7 |
| **Super Admin** | Full system control | Level 8-10 |
| **Compliance** | KYC/AML verification | Level 6-7 |
| **Finance** | Payout processing | Level 5-6 |

---

## 2. SYSTEM OVERVIEW

### 2.1 Core Components

```text
┌─────────────────────────────────────────────────────────────────┐
│                    SUNRAY ECOSYSTEM ARCHITECTURE                │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │  Investment  │  │    Vendor    │  │   Product Listing    │  │
│  │    Plan      │  │    Plan      │  │      Strategy        │  │
│  │   (15%)      │  │   (25%)      │  │   (24h Analysis)     │  │
│  └──────────────┘  └──────────────┘  └──────────────────────┘  │
│                            │                                     │
│  ┌─────────────────────────┴─────────────────────────────────┐  │
│  │              COMMISSION & ROYALTY ENGINE                   │  │
│  │         6-Level Progressive (20%-1% + Royalty)            │  │
│  └───────────────────────────────────────────────────────────┘  │
│                            │                                     │
│  ┌─────────────────────────┴─────────────────────────────────┐  │
│  │           AUTONOMOUS WEBHOOK SYSTEM (1-Hour Batch)         │  │
│  │              98% Cost Reduction | Zero API Polling         │  │
│  └───────────────────────────────────────────────────────────┘  │
│                            │                                     │
│  ┌─────────────────────────┴─────────────────────────────────┐  │
│  │              RBAC ACCESS CONTROL (10 Levels)               │  │
│  │         Registration + KYC + Payout Management             │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Financial Distribution (₹1,111 Crore Corpus)

| Category | Percentage | Amount (₹) | Webhook Trigger |
| :--- | :--- | :--- | :--- |
| **Investor Profit (15%)** | 15% | 166.67 Cr | `INVESTOR_PROFIT_DUE` |
| **Vendor Return (25%)** | 25% | 277.78 Cr | `VENDOR_RETURN_DUE` |
| **Referral Commission (45%)** | 45% | 500.00 Cr | `COMMISSION_ACCUMULATED` |
| **Admin Charges (10% of Comm)** | 4.5% | 50.00 Cr | `ADMIN_FEE_CALCULATED` |
| **Affiliate Royalty** | 3% | 33.33 Cr | `ROYALTY_QUALIFIED` |
| **Yearly Gifts** | 3% | 33.33 Cr | `YEARLY_GIFT_DUE` |
| **Office Expense** | 3% | 33.33 Cr | `OFFICE_EXPENSE_ALLOCATED` |
| **Marketing Expense** | 10% | 111.11 Cr | `MARKETING_BUDGET_RELEASED` |
| **Company Expansion** | 10% | 111.11 Cr | `EXPANSION_FUND_ALLOCATED` |
| **Milind Patil** | 10% | 111.11 Cr | `OWNER_DISTRIBUTION` |
| **Roshan Karnekar** | 10% | 111.11 Cr | `OWNER_DISTRIBUTION` |
| **TOTAL** | **100%** | **1,111.11 Cr** | |

---

## 3. ROLE-BASED ACCESS CONTROL (RBAC)

### 3.1 Access Level Matrix

| Level | Role | Registration | Investment | Vendor | Commission | Payout | Admin | System |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **1** | Guest | ✅ Read | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **2** | Registered | ✅ Full | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **3** | Investor | ✅ Full | ✅ Full | ❌ | ✅ View | ✅ View | ❌ | ❌ |
| **4** | Vendor | ✅ Full | ✅ Full | ✅ Full | ✅ View | ✅ View | ❌ | ❌ |
| **5** | Finance | ✅ Full | ✅ Full | ✅ Full | ✅ Full | ✅ Process | ✅ View | ❌ |
| **6** | Compliance | ✅ Full | ✅ Full | ✅ Full | ✅ View | ✅ View | ✅ KYC | ❌ |
| **7** | Admin | ✅ Full | ✅ Full | ✅ Full | ✅ Full | ✅ Full | ✅ Full | ❌ |
| **8** | Super Admin | ✅ Full | ✅ Full | ✅ Full | ✅ Full | ✅ Full | ✅ Full | ✅ Config |
| **9** | System | ✅ Auto | ✅ Auto | ✅ Auto | ✅ Auto | ✅ Auto | ✅ Auto | ✅ Auto |
| **10** | Root | ✅ All | ✅ All | ✅ All | ✅ All | ✅ All | ✅ All | ✅ All |

### 3.2 Permission Codes

```typescript
// src/lib/rbac/permission-codes.ts

export const PERMISSIONS = {
  REGISTRATION_CREATE: 'reg:create',
  REGISTRATION_READ: 'reg:read',
  REGISTRATION_UPDATE: 'reg:update',
  REGISTRATION_DELETE: 'reg:delete',
  KYC_VERIFY: 'kyc:verify',
  KYC_REJECT: 'kyc:reject',

  INVESTMENT_CREATE: 'inv:create',
  INVESTMENT_READ: 'inv:read',
  INVESTMENT_CALCULATE: 'inv:calculate',
  INVESTMENT_WITHDRAW: 'inv:withdraw',

  VENDOR_CREATE: 'ven:create',
  VENDOR_READ: 'ven:read',
  VENDOR_PRODUCT_LIST: 'ven:product:list',
  VENDOR_PRODUCT_APPROVE: 'ven:product:approve',
  VENDOR_REVENUE_VIEW: 'ven:revenue:view',

  COMMISSION_VIEW: 'comm:view',
  COMMISSION_CALCULATE: 'comm:calculate',
  COMMISSION_PROCESS: 'comm:process',
  COMMISSION_OVERRIDE: 'comm:override',

  PAYOUT_VIEW: 'pay:view',
  PAYOUT_PROCESS: 'pay:process',
  PAYOUT_APPROVE: 'pay:approve',
  PAYOUT_REJECT: 'pay:reject',

  ADMIN_USER_MANAGE: 'admin:user:manage',
  ADMIN_SYSTEM_CONFIG: 'admin:system:config',
  ADMIN_AUDIT_VIEW: 'admin:audit:view',
  ADMIN_WEBHOOK_MANAGE: 'admin:webhook:manage',

  SYSTEM_DATABASE_ACCESS: 'sys:db:access',
  SYSTEM_WEBHOOK_EXECUTE: 'sys:webhook:execute',
  SYSTEM_FULL_ACCESS: 'sys:full:access',
} as const;
```

### 3.3 RBAC Middleware Implementation

```typescript
// src/middleware/rbac-middleware.ts

import { NextRequest, NextResponse } from 'next/server';
import { verifyToken } from '@/lib/auth/jwt';
import { ROLE_PERMISSIONS } from '@/lib/rbac/permission-codes';

export interface RBACConfig {
  requiredPermissions: string[];
  minLevel?: number;
  maxLevel?: number;
  excludeRoles?: string[];
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

---

## 4. INVESTMENT PLAN MODULE

### 4.1 Investment Tiers

| Level | Investment | Monthly Profit (15%) | Annual Return | Payout Schedule |
| :--- | :--- | :--- | :--- | :--- |
| A | ₹51,111 | ₹7,667 | ₹92,004 | 45 days first, then 30 days |
| L1 | ₹10,60,000 | ₹1,59,000 | ₹19,08,000 | 45 days first, then 30 days |
| L2 | ₹27,00,000 | ₹4,05,000 | ₹48,60,000 | 45 days first, then 30 days |
| L3 | ₹53,00,000 | ₹7,95,000 | ₹95,40,000 | 45 days first, then 30 days |
| L4 | ₹1,10,00,000 | ₹16,50,000 | ₹1,98,00,000 | 45 days first, then 30 days |
| L5 | ₹2,50,00,000 | ₹37,50,000 | ₹4,50,00,000 | 45 days first, then 30 days |
| L6 | ₹11,00,00,000 | ₹1,65,00,000 | ₹19,80,00,000 | 45 days first, then 30 days |

---

## 5. VENDOR PLAN MODULE

### 5.1 Vendor vs Investor Comparison

| Feature | Investor | Vendor |
| :--- | :--- | :--- |
| **Return Rate** | 15% monthly | 25% monthly (active) |
| **Return Type** | Passive | Active (must sell) |
| **Payout Schedule** | 45 days first, then 30 days | 30 days (monthly) |
| **Min Investment** | ₹51,111 | ₹1,00,000 |
| **Max Investment** | ₹100 Crore | ₹50 Crore |
| **Revenue Share** | N/A | 85% vendor, 15% platform |
| **Product Listing** | N/A | Required (min 5 products) |
| **Rank Weight** | 1x | 2x for rank calculation |

---

## 6. COMMISSION & ROYALTY ENGINE

### 6.1 Base Commission Structure (6 Levels)

| Level | Base % | Calculation Base |
| :--- | :--- | :--- |
| Level 1 | 20% | Direct Referral Investment |
| Level 2 | 10% | Level 2 Downline Investment |
| Level 3 | 7% | Level 3 Downline Investment |
| Level 4 | 5% | Level 4 Downline Investment |
| Level 5 | 2% | Level 5 Downline Investment |
| Level 6 | 1% | Level 6 Downline Investment |
| **TOTAL** | **45%** | **All 6 Levels** |

### 6.2 Progressive Royalty Structure

| Rank | Business Target | Royalty Add-On | L1 | L2 | L3 | L4 | L5 | L6 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **BASE** | ₹0 | 0% | 20% | 10% | 7% | 5% | 2% | 1% |
| **BRONZE** | ₹1 Crore | +1% | 21% | 11% | 8% | 6% | 3% | 2% |
| **SILVER** | ₹5 Crore | +1.75% | 21.75% | 11.75% | 8.75% | 6.75% | 3.75% | 2.75% |
| **GOLD** | ₹10 Crore | +2.25% | 22.25% | 12.25% | 9.25% | 7.25% | 4.25% | 3.25% |
| **PLATINUM** | ₹25 Crore | +2.60% | 22.60% | 12.60% | 9.60% | 7.60% | 4.60% | 3.60% |
| **DIAMOND** | ₹50 Crore | +2.85% | 22.85% | 12.85% | 9.85% | 7.85% | 4.85% | 3.85% |
| **AMBASSADOR** | ₹100 Crore | +3% | 23% | 13% | 10% | 8% | 5% | 4% |

---

## 7. AUTONOMOUS WEBHOOK SYSTEM

### 7.1 Webhook Event Types

```typescript
// src/lib/webhooks/event-types.ts

export const WEBHOOK_EVENT_TYPES = {
  USER_REGISTERED: 'USER_REGISTERED',
  USER_VERIFIED: 'USER_VERIFIED',
  USER_INVESTED: 'USER_INVESTED',
  INVESTMENT_CREATED: 'INVESTMENT_CREATED',
  INVESTMENT_ACTIVATED: 'INVESTMENT_ACTIVATED',
  INVESTMENT_PAYOUT_DUE: 'INVESTMENT_PAYOUT_DUE',
  VENDOR_REGISTERED: 'VENDOR_REGISTERED',
  VENDOR_RETURN_CALCULATED: 'VENDOR_RETURN_CALCULATED',
  COMMISSION_ACCUMULATED: 'COMMISSION_ACCUMULATED',
  COMMISSION_CALCULATED: 'COMMISSION_CALCULATED',
  COMMISSION_PAID: 'COMMISSION_PAID',
  RANK_EVALUATION_DUE: 'RANK_EVALUATION_DUE',
  RANK_UPGRADED: 'RANK_UPGRADED',
  RANK_DOWNGRADED: 'RANK_DOWNGRADED',
  PRODUCT_STRATEGY_ANALYSIS_DUE: 'PRODUCT_STRATEGY_ANALYSIS_DUE',
  PRODUCT_LISTING_APPROVED: 'PRODUCT_LISTING_APPROVED',
  PAYOUT_DUE: 'PAYOUT_DUE',
  PAYOUT_ACCUMULATED: 'PAYOUT_ACCUMULATED',
  PAYOUT_PROCESSED: 'PAYOUT_PROCESSED',
  WEBHOOK_BATCH_PROCESS: 'WEBHOOK_BATCH_PROCESS',
  WEBHOOK_BATCH_COMPLETE: 'WEBHOOK_BATCH_COMPLETE',
} as const;
```

### 7.2 Batch Processing Configuration

```typescript
// src/lib/webhook/batch-config.ts

export const WEBHOOK_BATCH_CONFIG = {
  BATCH_DELAY_HOURS: 1,
  BATCH_LIMIT: 1000,
  BATCH_TIMEOUT_MS: 300000,
  CHECK_INTERVAL_MS: 60000,
  MAX_CONCURRENT_BATCHES: 3,
  USER_ID_ACCUMULATION_WINDOW_HOURS: 1,
  PAYOUT_ACCUMULATION_WINDOW_HOURS: 24,
  COMMISSION_ACCUMULATION_WINDOW_HOURS: 24,
  TREND_DATA_ACCUMULATION_HOURS: 24,
  MAX_RETRY_COUNT: 5,
  RETRY_DELAY_HOURS: 1,
  EXPONENTIAL_BACKOFF: true,
} as const;
```

---

## 8. REGISTRATION & KYC MODULE

### 8.1 Registration Form Fields

#### Section 1: Personal Information
| Field | Type | Validation | Required | RBAC Level |
| :--- | :--- | :--- | :--- | :--- |
| First Name | Text | Alphabetic, Max 50 chars | Yes | 1+ |
| Middle Name | Text | Alphabetic, Max 50 chars | No | 1+ |
| Last Name | Text | Alphabetic, Max 50 chars | Yes | 1+ |
| Contact No | Numeric | 10 Digits, Valid Country Code | Yes | 1+ |
| Email Id | Email | RFC 5322 Standard | Yes | 1+ |

#### Section 2: Identity Verification (KYC)
| Field | Type | Validation | Required | RBAC Level |
| :--- | :--- | :--- | :--- | :--- |
| Aadhaar No | Numeric | 12 Digits, Valid Checksum | Yes | 2+ |
| PAN No | Alphanumeric | 5 Alpha + 4 Numeric + 1 Alpha | Yes | 2+ |
| Address | Text | Auto-fetch via Aadhaar API | Yes | 2+ |

#### Section 3: Bank Details (Applicant)
| Field | Type | Validation | Required | RBAC Level |
| :--- | :--- | :--- | :--- | :--- |
| Bank Name | Dropdown | Select from IFSC Database | Yes | 3+ |
| Acc No | Numeric | Min 9, Max 18 Digits | Yes | 3+ |
| IFSC Code | Alphanumeric | 11 Characters | Yes | 3+ |

---

## 9. PRODUCT LISTING STRATEGY

### 9.1 Strategic Listing Process (24h+ Analysis)

```text
Vendor submission → 24h trend accumulation → scoring → LIST/POSTPONE/REJECT
```

### 9.2 Listing Decision Criteria

| Score Range | Decision | Confidence | Action |
| :--- | :--- | :--- | :--- |
| **80-100** | LIST | 90% | Approve immediately, HIGH priority |
| **60-79** | LIST | 75% | Approve, NORMAL priority |
| **40-59** | POSTPONE | 60% | Re-evaluate in 7 days |
| **0-39** | REJECT | 50% | Reject with reasons |

---

## 10. SECURITY & COMPLIANCE

### 10.1 Security Measures

| Layer | Technology | Implementation |
| :--- | :--- | :--- |
| **Authentication** | JWT + 2FA | Token-based with refresh |
| **Authorization** | RBAC (10 Levels) | Permission-based access |
| **Encryption** | AES-256 + TLS 1.3 | At rest + in transit |
| **KYC/AML** | Aadhaar + PAN API | Mandatory verification |
| **Audit Trail** | Database Logs | 7-year retention |
| **Rate Limiting** | Redis + Middleware | 100 req/min per user |
| **Bot Protection** | reCAPTCHA v3 | Registration forms |
| **Session Management** | Redis Store | 24h expiry |

---

## 11. TECHNICAL ARCHITECTURE

### 11.1 Technology Stack

| Component | Technology | Purpose |
| :--- | :--- | :--- |
| **Frontend** | Next.js 15 + React 19 | UI/UX |
| **Backend** | Next.js API Routes | Serverless functions |
| **Database** | Supabase PostgreSQL | Data storage + RLS |
| **Cache** | Upstash Redis (Free) | Session + Queue |
| **Deployment** | Vercel | Hosting + CDN |
| **Monitoring** | Vercel Analytics + Supabase Logs | Performance tracking |

### 11.2 Database Schema Summary

| Table | Purpose | Key Fields | RBAC Level |
| :--- | :--- | :--- | :--- |
| **users** | User accounts | id, role, kyc_status, referral_code | 6+ |
| **investments** | Investment records | user_id, amount, profit_rate, status | 5+ |
| **vendors** | Vendor accounts | user_id, vendor_status, revenue_share | 5+ |
| **payouts** | Payout records | user_id, amount, status, paid_date | 5+ |
| **webhook_event_queue** | Webhook queue | event_type, payload, status | 8+ |
| **kyc_documents** | KYC verification | user_id, document_type, verification_status | 6+ |
| **audit_logs** | System audit | user_id, action, entity, old_value, new_value | 7+ |

---

## 12. IMPLEMENTATION ROADMAP

### 12.1 Phase-wise Deployment

| Phase | Duration | Deliverables | Priority | RBAC Levels |
| :--- | :--- | :--- | :--- | :--- |
| **Phase 1** | Week 1-2 | Database schema, Auth, Registration, RBAC | 🔴 Critical | 1-3 |
| **Phase 2** | Week 3-4 | Investment module, Payout schedule | 🔴 Critical | 3-5 |
| **Phase 3** | Week 5-6 | Vendor module, Revenue share | 🔴 Critical | 4-5 |
| **Phase 4** | Week 7-8 | Commission engine, Webhook system | 🔴 Critical | 5-7 |
| **Phase 5** | Week 9-10 | Rank management, Product listing | 🟡 High | 4-7 |
| **Phase 6** | Week 11-12 | Security, Compliance, Audit, Testing | 🔴 Critical | 6-8 |
| **Phase 7** | Week 13-14 | Deployment, Monitoring, Training | 🟡 High | 7-10 |

### 12.2 Success Metrics

| Metric | Target | Measurement |
| :--- | :--- | :--- |
| **System Uptime** | 99.9% | Vercel Analytics |
| **API Response Time** | <200ms | Supabase Logs |
| **Webhook Success Rate** | >95% | Queue Processor Logs |
| **KYC Verification Time** | <24 hours | Compliance Dashboard |
| **Payout Processing Time** | <48 hours | Finance Dashboard |

---

**END OF MASTER PRD DOCUMENT**
