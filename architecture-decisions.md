# Architecture Decisions

The hard parts that require human thinking, not agent execution.

## Why This Matters

Agents write code fast. Bad architecture makes that speed worthless. Spend your thinking time here:

1. **System design** — How components connect
2. **Dependencies** — What libraries to use
3. **Database schema** — Structure that's painful to change
4. **Data flow** — Where data lives, how it moves

## Before Starting Any Project

### Questions to Answer

```
1. What data does this handle?
2. Where does data come from?
3. Where does data go?
4. Who accesses it?
5. What's the simplest stack that works?
```

### Tech Stack Selection

**Default stacks that agents know well:**

Web app:
- TypeScript + Next.js + Tailwind
- Postgres (via Supabase, Neon, or Vercel Postgres)
- Vercel for hosting

CLI tool:
- Go (simple, fast, agents write it well)
- Or TypeScript if you need npm ecosystem

API service:
- TypeScript + Hono/Express
- Or Go for performance

Mobile:
- React Native + Expo
- TypeScript

**Selection criteria:**

| Factor | Question |
|--------|----------|
| World knowledge | Is this popular enough that agents know it? |
| Maintenance | Last commit? Active issues? |
| Dependencies | How many peer deps? Are they maintained? |
| Complexity | Simplest option that solves the problem? |

## Database Schema

**The most important decision.** Schema changes are painful. Think carefully.

### Process

1. List all entities (users, posts, orders, etc.)
2. List relationships (user has many posts, order belongs to user)
3. Think about queries you'll need
4. Design for those queries
5. Add indexes for query patterns

### Common Patterns

**User + content:**
```sql
users (id, email, created_at)
content (id, user_id, type, data, created_at)
```

**Multi-tenant:**
```sql
organizations (id, name)
users (id, org_id, email)
[everything else] (id, org_id, ...)
```

**Event sourcing (for audit trails):**
```sql
events (id, type, entity_id, data, created_at)
-- Derive current state from events
```

### Red Flags

- No `created_at` on tables (you'll want it later)
- Storing computed values (store source, compute on read)
- No soft delete strategy (deleted_at vs. hard delete)
- Missing indexes on foreign keys
- JSON blobs instead of proper relations (sometimes ok, often regret)

## API Design

### REST Defaults

```
GET    /resources      - List
GET    /resources/:id  - Get one
POST   /resources      - Create
PUT    /resources/:id  - Replace
PATCH  /resources/:id  - Update
DELETE /resources/:id  - Delete
```

### When to Break REST

- **Batch operations** — POST /resources/batch
- **Actions** — POST /resources/:id/publish
- **Complex queries** — POST /resources/search with body

### Response Patterns

```typescript
// Success
{ data: T }
{ data: T[], pagination: { page, total } }

// Error
{ error: { code: string, message: string } }
```

## Data Flow Patterns

### Frontend State

**Local state:** useState for component-specific
**Global state:** Zustand/Jotai for app-wide
**Server state:** React Query/SWR for API data

Don't mix them. Server state should be cached/synced, not manually managed.

### Server Patterns

**Request → Validate → Process → Respond**

```typescript
async function handler(req) {
  // 1. Validate input
  const data = schema.parse(req.body)
  
  // 2. Check permissions
  if (!canAccess(req.user, data)) throw new ForbiddenError()
  
  // 3. Do the thing
  const result = await doThing(data)
  
  // 4. Return
  return { data: result }
}
```

### Background Jobs

For anything that:
- Takes > 1 second
- Can fail and retry
- Doesn't need immediate response

Options: Inngest, Trigger.dev, BullMQ, or simple cron.

## Dependency Decisions

### Evaluation Checklist

```
□ Last release < 6 months ago
□ Issues being responded to
□ TypeScript types (if JS project)
□ Bundle size acceptable
□ No heavy peer dependencies
□ Popular enough for agent knowledge
□ Escape hatch if it dies
```

### Red Flags

- Last commit > 1 year ago
- Hundreds of open issues, no responses
- Requires specific old versions of peers
- Single maintainer, no activity
- Does too much (kitchen sink libraries)

### When to Build vs. Use Library

**Use library:**
- Crypto, auth, payments (security-critical)
- Complex algorithms (ML, compression)
- Platform integrations (AWS, Stripe)

**Build yourself:**
- Simple utilities
- Business logic specific to you
- When library is 90% overhead for your use case

## Making Decisions

### Decision Process

1. **State the problem** — What are we solving?
2. **List options** — What could we do?
3. **Evaluate tradeoffs** — Pros/cons of each
4. **Pick one** — Decide and commit
5. **Document** — Write it down (docs/decisions/ or ADRs)

### When Stuck

Ask agent:
```
"What are the tradeoffs between X and Y for [use case]?"
"What do most projects like this use?"
"What would you recommend and why?"
```

Then make the call yourself. Agent advises, you decide.

### Decision Records

Keep in docs/decisions/:
```markdown
# 001: Use Postgres over MongoDB

## Context
Need a database for user data and content.

## Decision
Postgres via Supabase.

## Reasons
- Relational data (users, content, relationships)
- Supabase has good DX and agent knowledge
- Can add pgvector later if needed

## Consequences
- Need migrations for schema changes
- RLS for row-level security
```

## Scaling Thinking

### Don't Optimize Early

Start simple. Most apps never need:
- Microservices
- Message queues
- Distributed caching
- Kubernetes

### When to Complicate

Only when you have evidence:
- Actual performance problems (measured, not guessed)
- Team size requires separation
- Compliance requires isolation

### Simple Architecture That Scales

```
User → CDN → Server → Database
         ↓
      Cache (if needed)
         ↓
      Queue (if needed)
```

Add layers only when the previous one proves insufficient.

## Questions Agents Can't Answer

These require your judgment:

1. **Is this the right product?** — Market fit, user need
2. **Is this the right scope?** — MVP vs. feature creep
3. **Is this secure enough?** — Threat model for your context
4. **Is this maintainable?** — Team capabilities, future you
5. **Is this worth the cost?** — Time, money, complexity

Agents can provide information. You make the call.
