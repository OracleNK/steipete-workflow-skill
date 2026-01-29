# AGENTS.md Templates

Templates for different project types following Peter Steinberger's philosophy.

## Minimal Starter (Copy This First)

```markdown
# Project Name

Brief: [One sentence about what this is]

Stack: [Languages, frameworks, database]

## Commands
dev: [command]
test: [command]
build: [command]

## Rules
- Commits: Conventional Commits (feat|fix|refactor|docs|chore)
- Keep files under 500 LOC
- Write tests in same context after features

## Notes
[Agent adds notes here when things go wrong]
```

## Web App (TypeScript/React)

```markdown
# Project Name

Brief: [What it does, who it's for]

Stack: TypeScript, React, Next.js, [database], deployed on [platform]

## Commands
dev: pnpm dev
test: pnpm test
build: pnpm build
lint: pnpm lint
db: psql $DATABASE_URL

## Conventions
- Commits: Conventional Commits
- Components: functional, hooks only
- State: [zustand/jotai/context] for global, useState for local
- Styling: Tailwind, no CSS files
- Files: max 500 LOC, split components when larger

## Patterns
- API routes in app/api/
- Server components by default, 'use client' only when needed
- Error boundaries around async components
- Loading states via Suspense

## Database
Schema in prisma/schema.prisma (or docs/schema.md)
Migrations: npx prisma migrate dev

## Docs
Read before working on:
- Auth: docs/auth.md
- Payments: docs/payments.md
- API: docs/api-patterns.md

## Known Issues
[Agent adds here]
```

## CLI Tool (Go)

```markdown
# CLI Name

Brief: [What it does]

Stack: Go, Cobra CLI

## Commands
dev: go run .
test: go test ./...
build: go build -o bin/toolname
install: go install

## Conventions
- Commits: Conventional Commits
- Errors: wrap with fmt.Errorf("context: %w", err)
- Flags: use Cobra, document in --help
- Output: JSON to stdout, messages to stderr

## Structure
cmd/: command definitions
internal/: business logic
pkg/: reusable packages (if any)

## Notes
[Agent adds here]
```

## Python Project

```markdown
# Project Name

Brief: [What it does]

Stack: Python 3.11+, [framework], [database]

## Commands
dev: python main.py (or uvicorn app:app --reload)
test: pytest
lint: ruff check . && ruff format .

## Conventions
- Commits: Conventional Commits
- Types: use type hints everywhere
- Deps: add to pyproject.toml, install with pip install -e .
- Files: max 500 LOC

## Structure
src/: main code
tests/: pytest tests
scripts/: utility scripts

## Notes
[Agent adds here]
```

## Mobile App (React Native/Expo)

```markdown
# App Name

Brief: [What it does]

Stack: React Native, Expo, TypeScript

## Commands
dev: npx expo start
test: npm test
build: eas build
lint: npm run lint

## Conventions
- Commits: Conventional Commits
- Navigation: expo-router
- State: [zustand/jotai]
- Styling: StyleSheet.create or NativeWind

## Structure
app/: routes (expo-router)
components/: reusable components
hooks/: custom hooks
lib/: utilities

## Platform Notes
- iOS: [specifics]
- Android: [specifics]

## Notes
[Agent adds here]
```

## Multi-Agent Project

For projects where multiple agents work simultaneously:

```markdown
# Project Name

Brief: [What it does]

Stack: [tech stack]

## Commands
[standard commands]

## Multi-Agent Rules

CRITICAL: Multiple agents work in this repo simultaneously.

### Commits
- Only commit files YOU changed
- Use atomic commits for your changes only
- Don't commit unrelated changes you see
- If you see unexpected changes, assume another agent made them

### Conflicts
- If a file you need is changing, wait or ask user
- Don't try to merge other agents' work
- Focus on your assigned area only

### Areas
Assign agents to non-overlapping areas:
- Backend API: app/api/
- Frontend UI: components/, app/(pages)/
- Database: prisma/, migrations/
- Tests: tests/, __tests__/

### Communication
- Leave breadcrumb notes in conversation
- If blocked by another agent's work, say so
- Don't assume you can fix another agent's issues

## Notes
[Agent adds here]
```

## Growing Your AGENTS.md

Start minimal. Add notes when:

1. **Agent makes same mistake twice** → Add rule
2. **Agent doesn't know project convention** → Document it
3. **Agent needs context for a subsystem** → Point to docs
4. **Deployment failed** → Add deployment notes
5. **Dependency has gotcha** → Note it

Example growth:

```markdown
## Notes
- 2024-01-15: React Compiler needs explicit deps in useEffect
- 2024-01-16: Stripe webhook needs raw body, not JSON parsed
- 2024-01-18: Don't use @latest for shadcn, pin versions
- 2024-01-20: iOS build fails if bundle ID changes, never modify
```

These notes become your project's institutional memory.
