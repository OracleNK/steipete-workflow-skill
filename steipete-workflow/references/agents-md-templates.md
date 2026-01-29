# AGENTS.md Templates

Copy the appropriate template. Keep it minimal. Let it grow from actual issues.

## Universal Starter

```markdown
# Project

[One sentence: what this is]

Stack: [languages, frameworks]

## Commands
dev: [command]
test: [command]
build: [command]

## Rules
- Conventional commits (feat|fix|refactor|docs|chore|test)
- Files < 500 LOC
- Tests in same context as feature

## Notes
[Agent adds here when things go wrong]
```

## TypeScript Web App

```markdown
# Project

Stack: TypeScript, Next.js, Tailwind, [DB]

## Commands
dev: pnpm dev
test: pnpm test
build: pnpm build
lint: pnpm lint
db: psql $DATABASE_URL

## Structure
app/api/     API routes
components/  React components
lib/         Utilities
prisma/      Schema + migrations

## Conventions
- Server components default, 'use client' when needed
- Zustand for global state
- Error boundaries around async

## Docs
Auth: docs/auth.md
Payments: docs/payments.md

## Notes
```

## Go CLI

```markdown
# Project

Stack: Go, Cobra

## Commands
dev: go run .
test: go test ./...
build: go build -o bin/name

## Structure
cmd/       Commands
internal/  Business logic

## Conventions
- Errors: fmt.Errorf("context: %w", err)
- JSON to stdout, messages to stderr

## Notes
```

## Python

```markdown
# Project

Stack: Python 3.11+, [framework]

## Commands
dev: python main.py
test: pytest
lint: ruff check . && ruff format .

## Conventions
- Type hints everywhere
- pyproject.toml for deps

## Notes
```

## Multi-Agent Project

Add this section when multiple agents work simultaneously:

```markdown
## Multi-Agent

Multiple agents work here. Rules:

- Only commit files YOU modified
- Ignore changes you didn't make
- Stay in your assigned area
- If blocked by another agent, stop and report

Areas:
- Agent 1: [area]
- Agent 2: [area]
```

## Growing Notes

When something goes wrong, add a note:

```markdown
## Notes
- React Compiler needs explicit useEffect deps
- Stripe webhook needs raw body, not parsed JSON
- Never change iOS bundle ID
- shadcn: pin versions, don't use @latest
```

These accumulate into project memory.
