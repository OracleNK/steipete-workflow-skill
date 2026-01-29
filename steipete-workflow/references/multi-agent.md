# Multi-Agent Coordination

Rules for when multiple agents work on the same codebase.

## Scaling

| Work Type | Agents |
|-----------|--------|
| Normal | 1-2 |
| Feature + tests | 2 |
| Full stack feature | 3 |
| Cleanup/refactor day | 3-4 |
| Intensive shipping | 4-8 |

## Task Assignment

**Good splits (low collision):**
```
Agent 1: /api routes
Agent 2: /components
Agent 3: /tests
```

```
Agent 1: Feature A (all layers)
Agent 2: Feature B (all layers)
```

**Bad splits (high collision):**
```
Agent 1: Add user model
Agent 2: Add user API
# Both touch user files
```

## Commit Rules

Each agent commits only its own changes:

```bash
# Stage only your files
git add src/api/payments.ts src/api/payments.test.ts
git commit -m "feat: add payments endpoint"
```

**Never:**
- Commit others' changes
- Revert others' work
- "Fix" code you didn't write

## Conflict Handling

**If you see unexpected changes:**
1. Assume another agent made them
2. Work around them
3. Only touch files in your area

**If blocked by another agent:**
```
Blocked: auth.ts is being modified by another agent.
Waiting for: auth changes to be committed.
```

## Communication

Agents don't share context. To share info:

1. **Through code:** Just read the files
2. **Through docs:** Write to docs/, others read it
3. **Through user:** User relays between agents

## Monitoring Signals

| Signal | Meaning |
|--------|---------|
| Reading 10+ min | Possibly stuck |
| Same error 3x | Wrong approach |
| Touching unexpected files | Scope creep |
| Silence | Check if alive |

## Terminal Layout

```
┌─────────┬─────────┬─────────┐
│ Agent 1 │ Agent 2 │ Agent 3 │
│ backend │ frontend│  tests  │
├─────────┴─────────┼─────────┤
│     Browser       │  Logs   │
└───────────────────┴─────────┘
```

Each agent in its own terminal. User watches all.
