# Procurello
## Agentic Procurement & AP Platform — Product Requirements Document

**Version 1.0** — Prepared for prototype implementation on Replit

---

## 0. How to use this document

This document specifies a working prototype of an agentic procurement and accounts payable experience. It is intentionally written to be:

- **Implementable** — clear enough that a developer, or Replit's AI Agent, can scaffold the application directly from this spec
- **Demoable** — scoped to demonstrate the concept end-to-end without requiring real ERP integrations
- **Defensible** — every novel concept has explicit rationale, design intent, and reference to existing market practice

The prototype is intended for client demonstrations, internal pilot programs, and design validation. **It is not a production system.** Specific notes on where production hardening would be required appear at the end of each section.

---

## 1. Executive summary

### 1.1 Vision

Replace the form-driven, wizard-based procurement experience common in higher education, healthcare, and decentralized enterprises with a **conversational, agentic workspace** that:

- Accepts plain-language requests, document drops, and email forwards as input
- Automatically routes work to the correct procurement object (catalog cart, non-catalog requisition, contract bundle, invoice match)
- Surfaces predictions about what's coming next — for requesters, leaders, and AP
- Runs compliance checks silently and records an audit trail
- Personalizes the workspace by role with the right time horizon and concerns

### 1.2 Why this matters

In decentralized environments, casual users (researchers, faculty, lab managers, project leads) do not know the difference between a contract request, a purchase against a contract, a sole-source justification, or a payment request. Today they either guess wrong, get bounced back, or learn the system through trial and error. The current state burns thousands of hours per institution and creates measurable spend leakage through off-catalog buying, late invoice payment, missed discounts, and grant give-back.

### 1.3 Scope of prototype

Seven primary user interfaces, three personas, four end-to-end scenarios. No production ERP integration; all data is fixture-based. LLM-powered conversational agent backed by mock procurement data.

### 1.4 Success criteria

| Goal | Measure |
|---|---|
| Demo flows execute end-to-end | All 4 scenarios complete without manual workarounds |
| Agent feels conversational | Each scenario reaches resolution in ≤5 user turns |
| Visual quality | Indistinguishable from a production v1 |
| Hostable on Replit | Single click deployment, public URL |
| Extensible | New scenarios addable without architectural changes |

---

## 2. Personas

### 2.1 Jamie Mendez — Casual requester
- **Role:** Lab manager, Wellman Lab, Department of Biomedical Sciences
- **Frequency of use:** 2–3 times per week
- **Goals:** Buy things needed by the lab; process invoices that arrive in her inbox; handle reimbursements
- **Pain today:** Doesn't know which procurement form to use; doesn't know catalog from non-catalog; forgets to confirm receipts; loses track of pending items
- **Workspace:** Requester command center (`index.html`)
- **Scenarios:** Catalog buying, non-catalog services, invoice receiving, supplier-led contract

### 2.2 Dr. Sarah Reyes — Associate Dean, Research Operations
- **Role:** Approver for items above $25K, oversight of 12 PIs and 14 active grants
- **Frequency of use:** Daily, 15–30 minutes
- **Goals:** Spot at-risk grants early; approve transactions efficiently; understand market factors affecting spend; demonstrate stewardship to Dean and Board
- **Pain today:** Anomalies surface too late (typically at grant close); market changes invisible until invoiced; approval queue is undifferentiated
- **Workspace:** Leader dashboard (`leader-dashboard.html`)

### 2.3 David Kwan — AP Operations Manager
- **Role:** Manages 5-person AP team; reports to Controller
- **Frequency of use:** Continuous throughout workday
- **Goals:** Pay on time, capture discounts, prevent fraud, plan team capacity, never get surprised by rush requests
- **Pain today:** Invoices arrive without warning; receipts missing; rush payments cause scrambles; team capacity invisible until someone burns out
- **Workspace:** AP operations dashboard (`ap-operations.html`)

### 2.4 Supporting personas (referenced but not built in v1)
- **PI / Department Chair** — approver in chain (Dr. Sarah Wellman)
- **Procurement Category Manager** — manages supplier contracts and benchmarks
- **Internal Auditor** — reviews compliance and audit trails (consumer of audit data, not interactive)

---

## 3. Key concepts & design principles

### 3.1 One entry point, agent picks the path

All work begins with a conversational composer asking *"What do you need to buy?"* — accepting text, attachments, or email forwards. The agent classifies intent and routes to the appropriate procurement object:

| Input | Path | Object produced |
|---|---|---|
| "I need printer paper" | Catalog | Cart |
| "I need someone to recalibrate a centrifuge" | Non-catalog services | Requisition |
| Drop a supplier proposal PDF | Contract bundle | Contract amendment + linked PO |
| Forward an invoice | Invoice match | Three-way match record |

The user never selects a form. The agent infers from the request.

### 3.2 Compliance as background, audit trail as proof

Compliance checks (sanctions/OFAC, duplicate detection, vendor master validation, banking verification, tax classification, grant compliance, etc.) run silently while the user works. Results are summarized as a single calm status ("12 checks passed in 1.4 seconds") with a one-click expansion for auditors. Every agent action is timestamped and attributed in an exportable event log.

### 3.3 Predictive visibility ("telepathy")

The single most differentiated capability. Each persona sees what's coming at their time horizon:

| Persona | Horizon | Predictions surface from |
|---|---|---|
| Requester | 7 days | Deliveries in transit, approvals out, restock patterns, market timing, expected reimbursements |
| Leader | 14 days | Approvals incoming, grant moments, contract events, market windows |
| AP | 30 days | Drafts in workflow, receipts pending invoice, recurring billing, milestone-triggered invoices, behavior patterns |

Every prediction shows: **confidence percentage** (calibrated), **source type** (DRAFT, RECEIPT-PENDING, RECURRING, MILESTONE, PATTERN, MARKET), and **reasoning** (the data that supports the prediction).

### 3.4 Market awareness

The system maintains a market-intelligence layer that surfaces macro and supplier-specific signals (commodity prices, FX moves, tariff changes, supplier price notices, federal funding news, freight/shipping indices) and ties each to the user's actual portfolio with quantified impact.

### 3.5 Pattern intelligence

The agent learns from institutional history to:
- Benchmark new contracts against similar prior contracts (term, price, clause deltas, outcomes)
- Detect behavioral anomalies (threshold avoidance, off-contract spend, unusual velocity)
- Predict invoice arrivals from supplier billing patterns and goods-received status
- Forecast volume spikes (month-end, post-conference, grant close-out)

### 3.6 Behavioral feedback loops

Where the user's action affects downstream operations, the system surfaces the impact ("Your fast receipt confirmation puts you in the top 10% — AP doesn't have to chase, supplier gets paid on time, your lab captures the early-pay discount"). This builds positive reinforcement for behaviors that historically receive no acknowledgment.

---

## 4. Functional requirements by screen

### 4.1 Requester command center (`/` or `/home`)

**Purpose:** Personal workspace for casual requesters, balanced between conversational entry and command-center awareness.

**Layout:** Three-column. Left sidebar (220px), main content (fluid), right activity panel (380px).

**Required components:**

| Component | Description |
|---|---|
| Conversational composer | Multi-line textarea, file attachment, quick-action chips (attach quote, need-by date, reuse past order) |
| KPI strip (4 cards) | YTD spend, contract savings, time saved (hours), compliance health |
| Savings deep-dive | $ realized + breakdown by source (catalog/MSA/early-pay/negotiated) + 6-month trend chart |
| Spend by object code | Top 5–7 object codes with horizontal bar visualization and code numbers |
| Grant utilization | Top 3 grants with progress bar, time remaining, burn-rate signal |
| Recent activity | Tabbed (Mine / Lab / Department) with actor, amount, status |
| **Predictive section** ("What's coming your way") | 4–6 predictions with confidence dots, source pills, est. arrival, action |
| Quick scenarios | 4 compact cards linking to each canonical scenario |
| Right panel | Needs your attention (4 items), Department pulse (5 KPIs), Agent suggestion (proactive tip) |

**Agent behavior:** When user submits composer text, agent classifies intent (catalog / non-catalog / contract / invoice) and navigates to the appropriate scenario screen with context preserved.

**Data dependencies:** User profile, fiscal year transactions, grants, recent activity feed, prediction engine output.

---

### 4.2 Catalog & punchout buying (`/buy/catalog`)

**Scenario reference:** `catalog-guided-buying.html`

**Purpose:** Quick everyday buying of known items with contract-aware pricing.

**Required behavior:**
1. User types item description in composer ("I need a couple boxes of nitrile exam gloves, medium, powder-free for the lab")
2. Agent recognizes catalog-available item
3. Agent surfaces top 3 product matches from connected catalogs with:
   - Contract pricing flagged
   - List price + savings %
   - Best-value recommendation with visible flag
   - **Per-product market intelligence**: price trend over 90 days, supplier shipping ETA, supplier on-time rate
4. Punchout option below cards for browsing supplier's full catalog
5. Restock prediction surfaced when historical pattern detected
6. Internal stock check when applicable (Central Stores, surplus)
7. Cart builds incrementally as user adds items
8. Agent suggests complementary items based on context

**Cart (right panel) shows:** items with line totals, contract savings line item, shipping, estimated tax, total, routing (approval threshold awareness), ship-to.

**Data dependencies:** Catalog product master, contract pricing, supplier reliability data, restock history, internal inventory.

---

### 4.3 Non-catalog services request (`/buy/non-catalog`)

**Scenario reference:** `guided-buying-concept.html`

**Purpose:** One-off services or non-cataloged goods where the agent must identify supplier and structure the requisition.

**Required behavior:**
1. User describes need in plain language
2. Agent classifies as service vs. good, applies correct line-item type and commodity code
3. Agent ranks 3 suppliers by:
   - Contract status (active MSA = top)
   - Lead time
   - Past performance with requester's group
   - Diversity / preferred-supplier status
4. Agent recommends one with explicit reasoning ("under MSA, skips quote step, shortens approval")
5. Once user picks supplier, agent auto-fills full requisition:
   - Description, commodity code, line item type, amount, need-by date
   - Cost object (default from user profile / lab maintenance allocation)
   - Asset record attachment if applicable
6. Agent surfaces inline policy/compliance checks (MSA coverage, budget, COI, sanctions)
7. Agent flags optional optimization (shared cost-split with another PI)

**Requisition panel (right) shows:** draft summary, approval path with named individuals and typical response times, policy & compliance checks, action buttons.

---

### 4.4 Invoice receipt & three-way match (`/buy/invoice`)

**Scenario reference:** `invoice-guided-buying.html`

**Purpose:** Closing the loop on a PO when an invoice arrives at a decentralized requester rather than centralized AP.

**Required behavior:**
1. User forwards email or drops PDF
2. Agent extracts invoice fields (supplier, invoice #, amount, date, PO reference)
3. Agent matches to existing PO with confidence score
4. Agent shows 3-way match status visually (PO ✓, Receipt ?, Invoice ✓)
5. **Receipt prompt** inline with PO line items:
   - All items shown with description, quantity, unit price
   - Default action: "Confirm receipt of all N" (one-click)
   - Secondary action: "Mark partial" for back-orders or damage
6. Once receipt confirmed, agent:
   - Records receipt against PO
   - Runs 12 compliance checks silently
   - Shows summary status ("12 checks passed · 1.4s")
   - Surfaces early-pay discount opportunity if applicable
7. **AP context strip** shows position in queue, est. payment release, supplier billing cadence, user's response-time percentile

**Right panel:** Payment readiness card with status pill, 3-way match visualization, compliance checks panel (collapsed by default, expandable for audit), exportable audit trail.

**Compliance checks required:**
1. OFAC/sanctions screen
2. Duplicate invoice detection (90-day lookback)
3. Vendor master active + TIN verified
4. Banking validated (no recent change)
5. Tax classification (1099 determination)
6. Use-tax determination
7. Budget availability against cost object
8. Grant compliance (Uniform Guidance allowability)
9. Price variance vs PO
10. Quantity variance vs PO
11. Segregation of duties (requester ≠ approver)
12. Document retention tagging

---

### 4.5 Contract + quote bundle (`/buy/contract`)

**Scenario reference:** `contract-quote-guided-buying.html`

**Purpose:** Handle supplier-led proposals (SOW + quote + draft MSA) where the casual user doesn't know the legal/procurement path.

**Required behavior:**
1. User drops a multi-page PDF
2. Agent parses document and identifies:
   - It contains a scope of work, a quote, and an unsigned MSA (named individually)
   - Supplier, amount, term, type
   - Page references for each extracted field
3. Agent looks up supplier in vendor master:
   - Known/unknown status
   - Active contract status
   - Prior MSA history
4. Agent applies policy logic to identify required procurement path:
   - Above written-agreement threshold → contract required
   - Custom services → contract required regardless
   - Existing MSA could be amended → shortest path
5. **Pattern-match benchmark card** shows comparison to N similar past contracts:
   - Median price for peer SOWs
   - Supplier's prior pricing history
   - Typical term
   - MSA clause deltas (3 named differences from prior paper)
   - Outcome history with same supplier
6. Agent presents 3 paths with explicit tradeoffs (timeline, approvers, risk):
   - Renew prior agreement (recommended when applicable)
   - Sign supplier's new MSA (full intake)
   - PO with standard terms (fastest, but risk supplier may reject)
7. After user picks path, agent builds linked contract amendment + PO bundle

**Right panel:** Request bundle showing two linked objects (contract amendment + PO) with release dependency, multi-step approval path (PI → Legal → execution → PO release), estimated timeline.

---

### 4.6 Leader dashboard (`/leader`)

**Scenario reference:** `leader-dashboard.html`

**Purpose:** Executive workspace for a research dean / finance leader managing multiple PIs and grants.

**Required components:**

| Component | Description |
|---|---|
| KPI strip (5 cards) | Total spend, realized savings, at-risk grants, avg cycle time, compliance health |
| **Market intelligence** | Ticker (5 indicators: reagent index, USD/EUR, helium spot, freight, fed funds) + AI-curated news feed with per-story impact quantification |
| **Pipeline preview** ("Heading to you") | 6 predictions with confidence, type, description, est. arrival, value |
| PI/grant leaderboard | Sortable table with 7 grants — rank, PI name, grant ID, budget, utilization, burn rate, savings |
| Department pulse | 3 comparative panels (catalog adoption, on-time pay, cycle time) showing School vs Peer avg vs FY25 prior year |
| Right panel | Approval queue (3 detailed items with flags), Anomalies detected (4 patterns), Agent suggestion |

**News feed requirements:**
- 5 stories minimum, AI-curated by relevance to user's portfolio
- Each story tagged by category (Supply, FX, Funding, Tariff, Vendor)
- Each story shows: source, age, headline, plain-language description, quantified impact ($X exposure or savings), affected entities (number of PIs, suppliers, etc.)

**Anomaly types to detect:**
- Grant underspend approaching close (give-back risk)
- Grant burn velocity acceleration (overrun risk)
- Off-contract supplier use
- Threshold-avoidance patterns (transactions just under approval limits)
- Unusual order velocity vs peers

---

### 4.7 AP operations dashboard (`/ap`)

**Scenario reference:** `ap-operations.html`

**Purpose:** Operational workspace for AP managers with predictive cash flow and upstream visibility.

**Required components:**

| Component | Description |
|---|---|
| KPI strip (5 cards) | Items in queue ($/count), avg DPO vs target, on-time pay rate, team capacity %, discounts captured |
| Cash flow forecast | 4-week stacked bar chart showing committed (in queue) + predicted (upstream) per week, with capacity ceiling line + 30-day summary panel with confidence interval |
| **"What's Coming"** ("Telepathy" — the headline feature) | Tabbed table grouped by week with 6 source types: DRAFT, IN-APPROVAL, RECEIPT-PENDING, RECURRING, MILESTONE, PATTERN — each row shows confidence dots, source pill, description with reasoning, est. arrival, amount, action |
| In-flight queue | Tabbed table (PO invoices / Non-PO / Payment requests / Expense reports) — each row shows vendor, invoice #, amount, age (color-coded), status, blocker/next action |
| Team capacity | Per-analyst workload bars (5 analysts + open req) + 5-day forecast heat map (committed + predicted volume by day) |
| Right panel | Urgent today (3 rush items with action buttons), Discount window calendar (5-day with savings totals), Anomalies & alerts (banking change attempts, duplicates, threshold-avoidance), Agent prediction tip |

**Prediction source taxonomy:**

| Source | Confidence basis | Examples |
|---|---|---|
| DRAFT | Item exists in upstream system | Procurement queue, approval workflow |
| IN-APPROVAL | Visible in approval system | Pending PI sign-off, Legal review |
| RECEIPT-PENDING | Goods received, no invoice yet | Combined with supplier billing pattern |
| RECURRING | N-month consistent pattern | Monthly subscriptions, quarterly utilities |
| MILESTONE | Contract-triggered | SOW Phase X completion |
| PATTERN | Statistical pattern from history | Conference returns, month-end batching, grant close-out rush |

**Anomaly detection types:**
- BEC fraud signal (suspicious banking change request)
- Duplicate invoice candidate (same amount, ship-to, close dates)
- Threshold-avoidance pattern (multiple just-under-limit transactions)
- Volume anomaly (velocity vs baseline)

---

### 4.8 Cross-cutting: Conversational agent

The agent is the protagonist of the experience and appears in every primary user flow. Required capabilities:

**Intent classification:** Given free-text input, classify into one of: catalog buy, non-catalog buy, contract handling, invoice processing, expense reimbursement, general question.

**Entity extraction:** From text or attachments, extract supplier name, amount, dates, line items, scope, payment terms, etc.

**Tool calls (to mock backend):**
- `lookup_supplier(name)` → vendor master record
- `find_active_contracts(supplier_id)` → contract list
- `find_similar_purchases(description, scope)` → benchmark data
- `check_inventory(item, location)` → internal stock
- `match_invoice_to_po(invoice_data)` → PO match with confidence
- `run_compliance_checks(transaction)` → 12-check result set
- `get_predictions(persona, horizon)` → forward-looking items
- `get_market_intelligence(category)` → news + indicators

**Conversation state:** Multi-turn within a scenario. Maintain context across user turns. Hand off cleanly between scenarios (e.g., catalog conversation may produce a draft requisition that appears in the requester command center).

**Reasoning transparency:** Every prediction, recommendation, or compliance result must include the basis for the conclusion in a form the user can read. No black-box outputs.

**Calibration:** Confidence scores must be defended by data. Three-dot scale or percentage; map to reasoning text.

---

## 5. Technical architecture

### 5.1 Recommended stack for Replit

| Layer | Technology | Rationale |
|---|---|---|
| Frontend | Static HTML/CSS/JS (existing mockups) + light JS for interactivity | Mockups already built; minimum framework overhead |
| Server | Node.js + Express | Easy on Replit; well-supported by Replit Agent |
| Templating | EJS or simple string interpolation | Avoid full framework for prototype simplicity |
| State store | JSON files for fixtures + in-memory session state | Sufficient for demo; no DB ops to maintain |
| LLM | Anthropic Claude API (recommended: `claude-sonnet-4-6`) | Strong tool-calling, document parsing, reasoning |
| Hosting | Replit Deployments (Reserved VM or Autoscale) | Single-click public URL, env var support |

**Alternative stack (if a richer SPA is wanted later):** React + Vite frontend, FastAPI Python backend, Postgres via Neon, identical LLM layer. Recommended for production direction but adds complexity for the prototype.

### 5.2 File structure (Replit)

```
/
├── .replit                       # Replit run config
├── replit.nix                    # System packages
├── package.json                  # Node deps
├── server.js                     # Express entry
├── /public/                      # Static assets served as-is
│   ├── index.html                # Requester command center
│   ├── catalog-guided-buying.html
│   ├── guided-buying-concept.html
│   ├── invoice-guided-buying.html
│   ├── contract-quote-guided-buying.html
│   ├── leader-dashboard.html
│   ├── ap-operations.html
│   ├── /css/                     # Shared styles if extracted
│   └── /js/                      # Shared client JS
│
├── /api/                         # Express route handlers
│   ├── chat.js                   # Agent endpoint
│   ├── suppliers.js
│   ├── invoices.js
│   ├── predictions.js
│   └── compliance.js
│
├── /agent/                       # Agent logic
│   ├── client.js                 # LLM client wrapper
│   ├── prompts.js                # System prompts per persona
│   ├── tools.js                  # Tool definitions for the LLM
│   └── handlers.js               # Tool call dispatch
│
├── /data/                        # Fixture data
│   ├── users.json                # Personas
│   ├── suppliers.json            # Vendor master
│   ├── contracts.json
│   ├── pos.json                  # Open POs
│   ├── invoices.json             # In-queue invoices
│   ├── grants.json
│   ├── catalog.json              # Catalog/punchout product data
│   ├── predictions.json          # Pre-computed prediction items
│   ├── market_news.json          # Market intelligence stories
│   └── activity.json             # Recent activity feed
│
└── README.md                     # Setup & deployment notes
```

### 5.3 Environment variables (Replit Secrets)

| Name | Purpose |
|---|---|
| `ANTHROPIC_API_KEY` | LLM access |
| `SESSION_SECRET` | Express session signing (any random string for demo) |
| `DEMO_PERSONA` | Optional default persona (`jamie` / `reyes` / `kwan`) |

### 5.4 API contract

All chat interactions go through a single endpoint:

```
POST /api/chat
{
  "persona": "jamie" | "reyes" | "kwan",
  "scenario": "catalog" | "non_catalog" | "contract" | "invoice" | "home",
  "messages": [ { "role": "user", "content": "..." } ],
  "attachments": [ { "type": "pdf|email", "data": "base64..." } ]
}

Response:
{
  "message": { "role": "assistant", "content": "..." },
  "tool_calls": [...],
  "context_update": { ... },
  "ui_actions": [
    { "type": "navigate", "to": "/buy/catalog" },
    { "type": "show_card", "card_id": "supplier_recs" },
    { "type": "update_cart", "items": [...] }
  ]
}
```

Other endpoints serve fixture data for the dashboard widgets:

| Endpoint | Returns |
|---|---|
| `GET /api/kpi/:persona` | KPI strip data |
| `GET /api/predictions/:persona?horizon=N` | Predicted items |
| `GET /api/activity/:persona?scope=mine|lab|dept` | Activity feed |
| `GET /api/market/news` | Curated news stories |
| `GET /api/grants?owner=:dean` | Grant utilization data |
| `GET /api/queue/ap?type=po_inv|non_po|payment|expense` | In-flight queue |

---

## 6. Data model

All entities below should be JSON fixtures for the prototype. Schemas are illustrative and may extend in implementation.

### 6.1 Core entities

**User / Persona**
```json
{
  "id": "u_jamie",
  "name": "Jamie Mendez",
  "role": "Lab Manager",
  "department": "4421",
  "lab": "Wellman Lab",
  "default_cost_object": "WL-CAL-26",
  "approver_id": "u_wellman",
  "behavioral_metrics": {
    "avg_receipt_response_hrs": 2.1,
    "receipt_response_percentile": 90
  }
}
```

**Supplier**
```json
{
  "id": "v_sigma",
  "name": "Sigma-Aldrich",
  "vendor_number": "V-00284",
  "status": "approved",
  "active_contracts": ["c_msa_sigma_2024"],
  "prior_contracts": ["c_msa_sigma_2022_expired"],
  "tax_classification": "corp",
  "thousand99_required": false,
  "payment_terms_default": "net_30",
  "early_pay_discount": { "rate": 0.02, "days": 10 },
  "ofac_status": "clear",
  "banking_verified_date": "2025-08-14",
  "performance": {
    "on_time_pct": 98,
    "lead_time_days": [2, 3],
    "typical_invoice_lag_days": 5
  },
  "price_trend_90d": "held"
}
```

**Contract**
```json
{
  "id": "c_msa_strand_2023",
  "supplier_id": "v_strand",
  "type": "MSA",
  "status": "expired",
  "term_start": "2023-01-15",
  "term_end": "2024-12-31",
  "value_authorized": 75000,
  "value_used": 68000,
  "schedules": [],
  "legal_template_id": "tmpl_strand_2023"
}
```

**Purchase Order**
```json
{
  "id": "po_2026_0312",
  "supplier_id": "v_sigma",
  "requester_id": "u_jamie",
  "cost_object": "WL-CAL-26",
  "total": 1840.00,
  "currency": "USD",
  "issued_date": "2026-04-18",
  "status": "open",
  "lines": [
    { "id": "l1", "description": "Anti-CD3 Antibody, 100µg", "catalog_no": "A-9384", "qty": 1, "unit_price": 420.00, "received_qty": 0 },
    ...
  ]
}
```

**Invoice**
```json
{
  "id": "inv_sigma_4471",
  "supplier_id": "v_sigma",
  "supplier_invoice_number": "INV-2026-4471",
  "po_id": "po_2026_0312",
  "amount": 1840.00,
  "invoice_date": "2026-05-12",
  "due_date": "2026-06-11",
  "status": "matched_pending_receipt",
  "received_at": "2026-05-15T10:42:18Z",
  "received_via": "email_forward",
  "compliance_checks": { ... },
  "audit_trail": [...]
}
```

**Receipt**
```json
{
  "id": "r_po_2026_0312",
  "po_id": "po_2026_0312",
  "confirmed_by": "u_jamie",
  "confirmed_at": "2026-05-15T10:45:32Z",
  "lines": [
    { "po_line_id": "l1", "qty_received": 1, "condition": "ok" }
  ]
}
```

**Grant**
```json
{
  "id": "g_r01_ca248932",
  "sponsor": "NIH",
  "grant_number": "R01-CA248932",
  "title": "Cancer immunotherapy mechanisms",
  "pi_id": "u_wellman",
  "budget_total": 625000,
  "spent_to_date": 487000,
  "term_start": "2024-09-01",
  "term_end": "2026-11-30",
  "health_status": "watch",
  "projected_overrun": 40000
}
```

**Prediction**
```json
{
  "id": "pred_001",
  "persona": "jamie",
  "horizon": "7d",
  "source": "DELIVERY",
  "confidence": 0.98,
  "confidence_basis": "UPS tracking + supplier history",
  "estimated_arrival": "2026-05-20",
  "title": "Sigma antibody batch · UPS tracking active",
  "detail": "PO-2026-0498 · 3 boxes · I'll prompt you to confirm receipt when it arrives",
  "amount": 1840.00,
  "action_label": "Track",
  "action_url": "/po/po_2026_0498"
}
```

**Market story**
```json
{
  "id": "news_helium_2026_q3",
  "category": "Supply",
  "headline": "Helium supply tightens — Air Liquide announces 8% surcharge for Q3",
  "summary": "Russian export disruptions and new BLM auction policy...",
  "source": "Chemical & Engineering News",
  "published_at": "2026-05-15T06:30:00Z",
  "impact_quantified": {
    "affected_pis": 3,
    "annualized_amount": 14200,
    "direction": "cost_increase"
  }
}
```

### 6.2 Volume of fixture data needed

| Entity | Records |
|---|---|
| Users | 5 (3 personas + 2 supporting) |
| Suppliers | 25–40 |
| Contracts | 10–15 |
| POs | 30–50 (mix of open, closed, partial) |
| Invoices | 20–30 (mix of queued, paid, on hold) |
| Grants | 14 (per leader scenario) |
| Catalog products | 60–100 |
| Predictions | 30+ (across personas/horizons) |
| Market stories | 8–12 |
| Activity records | 50+ |

---

## 7. AI agent specification

### 7.1 System prompt structure (per persona)

Each persona session uses a system prompt with these sections:

1. **Role definition** — "You are a procurement agent assisting [persona name], a [role] at [institution]…"
2. **Persona context** — name, department, default cost object, recent activity summary
3. **Behavioral guidelines** — be concise, transparent about reasoning, never invent data, always cite tool results
4. **Conversation patterns** — examples of good responses (extracted from mockup copy)
5. **Tool catalog** — available tool descriptions

### 7.2 Tool calling

Recommended pattern: Claude's native tool use. Each tool returns structured JSON; agent narrates results to the user.

### 7.3 Confidence calibration

Predictions must report a confidence number tied to a reason:

| Confidence | Basis | Example |
|---|---|---|
| 95–99% | Direct upstream signal | Item already in approval queue, tracked shipment |
| 80–94% | Strong pattern + signal | Receipt confirmed + supplier billing cadence |
| 65–79% | Historical pattern alone | "Conference travel typically returns within 10 days" |
| 50–64% | Weak pattern, broad range | Variable utility bills, weather-dependent |
| <50% | Do not surface unless explicitly asked |

### 7.4 Audit trail requirements

Every agent action (parse, lookup, match, validate, decision, recommendation) must emit an event with:

- ISO 8601 timestamp
- Actor (user ID or "agent")
- Event type
- Entity affected
- Result / confidence
- Reasoning (for predictions and recommendations)

Events stored in `audit_log.json` (or in-memory for the demo session), exportable as CSV.

---

## 8. UI/UX system

### 8.1 Design tokens

Already defined and consistent across all seven mockups. Extract into a shared `tokens.css`:

```css
:root {
  --bg: #FAFAF7;
  --surface: #FFFFFF;
  --surface-2: #F4F3EF;
  --ink: #1A1A1A;
  --ink-2: #4A4A48;
  --ink-3: #8A8A88;
  --line: #E8E6E0;
  --line-2: #D9D6CE;
  --brand: #7C3AED;        /* Procurello signature violet */
  --accent: #1E3A5F;       /* PO / approval */
  --green: #2E7D5B;        /* Savings, success */
  --amber: #B97A0E;        /* Watch, caution */
  --red: #A8351F;          /* Risk, urgent */
  --purple: #6B4C9A;       /* Contracts */
  --teal: #2A6F73;         /* Invoices / AP */
  --indigo: #4A5BB8;       /* Predictions / telepathy */
  --r: 10px;
  --rs: 6px;
}
```

### 8.2 Typography

- Family: **Inter** (Google Fonts)
- Mono: **JetBrains Mono** for codes, IDs, audit timestamps, financial figures in tables
- Heading scale: 26–28px (page), 13px uppercase 11px (section), 12–14px (card title)
- Body: 14px
- Small: 11–12px
- Line height: 1.5 default, 1.3 for tight cells

### 8.3 Layout primitives

- **App shell**: 3-column grid (220px / 1fr / 380px). Right column may be hidden on smaller viewports.
- **Card**: rounded 10px, 1px line border, white surface, optional header with title + meta
- **KPI card**: ~150px wide, large value with unit, label, trend, optional sparkline
- **Conversational composer**: 14px radius, multi-section (label, textarea, action row), prominent submit
- **Inline agent message**: dot + body, breath of whitespace on either side

### 8.4 Common components to extract

| Component | Reuse across |
|---|---|
| Sidebar nav | Every screen |
| Composer | Home, all scenario entries |
| KPI strip | Home, leader, AP |
| Confidence dots (●●●) | Predictions in all dashboards |
| Source pill | Predictions, activity |
| Audit row | Invoice, leader, AP |
| Card with tabbed header | Activity, queue, predictions |
| Approval chain | Invoice, contract |
| **Collapsible section** | Any dense main-area section |

### 8.5 Collapsible section behavior (information-dense pages)

On dense pages (Requester Home, Leader Dashboard, AP Operations), main-area sections must be collapsible to let users manage information density.

**Behavior:**
- Click anywhere on the section header (`.sec-h`) toggles the section
- Chevron next to section title indicates state: ▾ expanded, ▸ collapsed
- Section title, sub-text, and meta info remain visible when collapsed (user can always see what they've hidden)
- Sub-text shifts to italic + reduced opacity when collapsed
- Smooth 0.2s transition on chevron rotation; collapse/expand is instant (no animation needed — content snaps for performance)

**Bulk controls:**
- Top of each dense page provides "Expand all · Collapse all" links

**What is collapsible:**
- All main-area sections that contain tables, charts, or content cards

**What is NOT collapsible:**
- KPI summary strips (always-on)
- The conversational composer (primary entry point)
- Right-side panels (already curated; collapsing defeats their purpose)
- Sidebar navigation

**State persistence:**
- Prototype: session-only (resets on reload)
- Production: per-user preference object, persists across sessions

**Implementation (vanilla JS, ~5 lines):**
```javascript
document.addEventListener('click', e => {
  const h = e.target.closest('.sec-block.collapsible > .sec-h');
  if (h && !e.target.closest('button, a, .tab, .tabs, input, select')) {
    h.parentElement.classList.toggle('collapsed');
  }
});
```

Event delegation excludes interactive children (tabs, buttons, links) so they continue working normally inside section headers.

---

## 9. Non-functional requirements

| Area | Requirement | Notes |
|---|---|---|
| Performance | First content paint <1s on broadband | Single-bundle static delivery |
| Browser support | Latest Chrome, Safari, Firefox, Edge | No IE / legacy |
| Mobile | Functional on tablet; phone is degraded view | Not a v1 priority |
| Accessibility | WCAG AA color contrast on text; keyboard navigation for primary actions | Full AA compliance is V2 |
| Security | API key in env var (Replit secret); no auth in demo | Production would require SSO, RBAC |
| Logging | Console + simple file-based audit log | Production would route to SIEM |
| Privacy | No real PII; all fixtures use synthetic identities | |

---

## 10. Implementation phasing

### 10.1 Phase 1 — Visual MVP (1–2 weeks)

- Serve all 7 HTML mockups as static pages on Replit
- Sidebar nav between them works
- Composer is non-functional (placeholder); clicking "Continue" navigates to a relevant scenario
- All data is hardcoded in the HTML

**Outcome:** Clickable demo. Sufficient for client showings without live agent interaction.

### 10.2 Phase 2 — Conversational MVP (2–3 weeks)

- Wire composer to LLM API
- Implement intent classification routing
- Build 1 scenario end-to-end with live agent (recommend: invoice scenario — highest value, most defined)
- Tool calls return fixture data
- Audit log written for that scenario
- Predictions are still fixture-driven

**Outcome:** Live agent demo for one scenario. Strong for sales conversations.

### 10.3 Phase 3 — Full agent + predictions (3–4 weeks)

- All 4 scenarios live with agent
- Prediction engine works against fixture data with simulated "current time"
- Market news feed pulls from a configurable source (or static JSON updated weekly)
- Confidence calibration honest (predictions reflect actual data patterns in fixtures)

**Outcome:** End-to-end demoable platform.

### 10.4 Phase 4+ — Pilot extension (out of scope for prototype)

- Real ERP integration (read-only)
- Authentication / RBAC
- Multi-tenant data isolation
- Persistent state in database
- Audit log to SIEM / immutable store
- Anomaly detection backed by real ML models

---

## 11. Replit-specific implementation guide

### 11.1 Project setup

1. Create a new Repl, language: **Node.js**
2. In Secrets, add `ANTHROPIC_API_KEY`
3. Initialize `package.json` with dependencies:

```json
{
  "name": "procurement-agent",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "node --watch server.js"
  },
  "dependencies": {
    "@anthropic-ai/sdk": "^0.30.0",
    "express": "^4.19.0",
    "express-session": "^1.18.0",
    "multer": "^1.4.5",
    "pdf-parse": "^1.1.1"
  }
}
```

4. `.replit` configuration:

```
run = "npm start"
modules = ["nodejs-20"]

[deployment]
run = ["npm", "start"]
deploymentTarget = "cloudrun"
```

### 11.2 Using Replit Agent to scaffold

When prompting Replit Agent, provide this requirements document as context and use this scaffolding prompt:

> Build a Node.js + Express prototype according to the attached requirements document. Start by:
>
> 1. Setting up the Express server with static file serving from `/public`
> 2. Creating the file structure described in section 5.2
> 3. Loading the 7 existing HTML files into `/public`
> 4. Creating fixture JSON files in `/data` populated with realistic sample data per section 6
> 5. Building the `/api/chat` endpoint that calls the Anthropic API
> 6. Implementing the tool catalog from section 4.8 (each tool returns data from fixtures)
>
> Stop after the chat endpoint works end-to-end for the invoice scenario. We will iterate from there.

### 11.3 Recommended Anthropic SDK call pattern

```javascript
import Anthropic from '@anthropic-ai/sdk';
const anthropic = new Anthropic();

const response = await anthropic.messages.create({
  model: 'claude-sonnet-4-6',
  max_tokens: 2048,
  system: buildSystemPrompt(persona, scenario),
  tools: TOOL_CATALOG,
  messages: conversationHistory
});

// Handle tool use blocks
for (const block of response.content) {
  if (block.type === 'tool_use') {
    const result = await dispatchTool(block.name, block.input);
    // Append tool result, call again
  }
}
```

### 11.4 Deployment

1. Click "Deploy" in Replit
2. Choose **Autoscale** (recommended) or **Reserved VM**
3. Set deployment env vars (same as secrets)
4. Get a public URL of the form `https://procurement-agent-<username>.replit.app`

For client demos, optionally:
- Pin Reserved VM instance for guaranteed availability during the demo
- Add a simple password gate via Express middleware if the URL will be shared

### 11.5 Cost considerations

| Component | Estimated monthly cost |
|---|---|
| Replit hosting (Autoscale, demo traffic) | ~$10–25 |
| Anthropic API (Claude Sonnet, demo volume) | ~$15–50 depending on usage |
| **Total for prototype** | **~$25–75/month** |

Set a monthly cap in your Anthropic console to avoid surprises.

---

## 12. Open questions for client conversations

These should be confirmed with the actual implementing institution before any production roadmap:

1. **Source of truth for contracts** — Where do active contracts live today (Icertis, Agiloft, JAGGAER Contracts+, file shares)? Real-time vs nightly sync feasibility?
2. **ERP integration approach** — Workday/Oracle/Peoplesoft? Read-only API, ETL, or eventing?
3. **Vendor master ownership** — Who owns it, and how often is it updated?
4. **Compliance check sources** — OFAC list refresh frequency, internal duplicate detection rules, etc.
5. **Pattern model training data** — How much clean transaction history exists?
6. **Peer benchmarking** — Available data partners (NACUBO, E&I, KINETIC, COGR)?
7. **Market intelligence feed** — Existing license to S&P, Beroe, GEP COSTDRIVERS, or build from public sources?
8. **Persona variants** — Department chair, controller, category manager, CFO — which to build next?

---

## 13. Glossary

| Term | Definition |
|---|---|
| 3-way match | Reconciling PO + receipt + invoice before payment release |
| BEC | Business email compromise — fraud attempt using lookalike domains |
| DPO | Days payable outstanding — average time from invoice to payment |
| MSA | Master service agreement — overarching contract with line-item SOWs |
| OFAC | Office of Foreign Assets Control — sanctions screening |
| PI | Principal investigator — research grant owner |
| PO | Purchase order |
| Punchout | Standardized session-based shopping at a supplier's site, returning to the buyer's procurement system |
| SOW | Statement of work |
| Telepathy | (This product) Predictive visibility into work that hasn't formally arrived yet — drafts, recurring patterns, milestone-driven invoices, behavior patterns |
| Three-dot confidence | UI convention for prediction confidence (●●● = 95+%, ●●○ = 80–94%, ●○○ = 65–79%) |
| Uniform Guidance | Federal grant compliance standard (2 CFR 200) |

---

*Document prepared as a companion to the prototype mockups in `/public/`. For demonstration use; not a production specification.*
