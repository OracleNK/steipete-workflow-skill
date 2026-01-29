# Multi-Agent Coordination Patterns

How to run multiple agents effectively on the same codebase.

## Core Principle

Multiple agents can work on the same repo, same branch, same folder — if you pick non-overlapping work.

## Agent Scaling

| Situation | Agents | Why |
|-----------|--------|-----|
| Normal development | 1-2 | Focus, easy to track |
| Feature + tests | 2 | Builder + tester |
| UI + backend + tests | 3 | Parallel progress |
| Cleanup day | 3-4 | Many small independent tasks |
| Intensive shipping | 4-8 | Max parallelization |

## Task Assignment

### Good Splits (Low Collision)

```
Agent 1: Backend API routes
Agent 2: Frontend components
Agent 3: Database migrations
Agent 4: Tests
```

```
Agent 1: Feature A (all layers)
Agent 2: Feature B (all layers)
Agent 3: Refactoring old code
```

```
Agent 1: /src/auth/*
Agent 2: /src/payments/*
Agent 3: /src/dashboard/*
```

### Bad Splits (High Collision)

```
Agent 1: Add user model
Agent 2: Add user API
# Both touch user-related files
```

```
Agent 1: Refactor utils
Agent 2: Add feature using utils
# Agent 2 breaks when Agent 1 changes utils
```

## Commit Hygiene

Each agent commits only its own changes:

```markdown
# In AGENTS.md
## Commit Rules
- Stage only files you modified
- Don't commit unrelated changes you notice
- Use conventional commits: feat|fix|refactor
- If unsure about a file, ask before committing
```

Script to enforce (optional):
```bash
#!/bin/bash
# scripts/commit.sh - agent calls this instead of git commit
# Stages only specified files, enforces message format

files="$1"
message="$2"

if [ -z "$files" ] || [ -z "$message" ]; then
  echo "Usage: commit.sh 'file1 file2' 'commit message'" >&2
  exit 1
fi

git add $files
git commit -m "$message"
```

## Handling Conflicts

### Prevention

1. **Clear boundaries** — Assign areas, not overlapping features
2. **Sequential dependencies** — If B needs A, wait for A to commit
3. **Shared files** — Only one agent touches config/shared utilities at a time

### When Conflicts Happen

Agent sees unexpected changes:
```markdown
# In AGENTS.md
If you see changes you didn't make:
1. Assume another agent made them
2. Don't try to revert or "fix" them
3. Work around them if possible
4. If blocked, stop and ask user
```

Agent needs a file another agent is using:
```
User: "Agent 2, hold on auth.ts changes until Agent 1 commits"
Agent 2: [works on other files first]
User: "Agent 1 committed, Agent 2 continue"
```

## Context Isolation

Each agent has its own context. They don't share memory.

### To Share Information

Option 1: User relays
```
User to Agent 2: "Agent 1 added a useAuth hook, use that"
```

Option 2: Docs
```
User to Agent 1: "Document the auth pattern in docs/auth.md"
User to Agent 2: "Read docs/auth.md before implementing"
```

Option 3: Code is the source of truth
```
User to Agent 2: "Check how Agent 1 implemented auth in src/auth/"
```

## Parallel Patterns

### Builder + Reviewer

```
Agent 1: Build feature
Agent 2: Review Agent 1's output when done

# Agent 2 prompt:
"Review the changes in the last 3 commits for bugs and improvements"
```

### Builder + Tester

```
Agent 1: Build feature
Agent 2: Write tests for what Agent 1 builds

# Coordination:
User: "Agent 2, write tests for src/payments/ as Agent 1 builds it"
Agent 2: [watches files, writes tests]
```

### Feature Teams

```
Agent 1: Auth feature (full stack)
Agent 2: Payments feature (full stack)
Agent 3: Dashboard feature (full stack)

# Each owns their vertical slice
```

### Cleanup Swarm

```
Agent 1: "Fix all TypeScript errors"
Agent 2: "Remove dead code (run knip)"
Agent 3: "Deduplicate code (run jscpd)"
Agent 4: "Update outdated deps"

# All independent, safe to parallelize
```

## Queue Pattern

When agents finish tasks, queue next work:

```
Agent 1 context:
- "Add login form" [done]
- "Add logout button" [queued]
- "Add password reset" [queued]

# Agent works through queue without user intervention
```

With Codex, queue messages. Agent ignores extras if done.

With Claude Code, queue in a list:
```
After finishing current task, continue with:
1. Add logout button
2. Add password reset
3. Add email verification
```

## Terminal Setup

### Physical Layout

```
┌─────────────┬─────────────┬─────────────┐
│  Agent 1    │  Agent 2    │  Agent 3    │
│  (backend)  │  (frontend) │  (tests)    │
├─────────────┼─────────────┼─────────────┤
│  Agent 4    │   Browser   │   Logs      │
│  (misc)     │  (preview)  │  (vercel)   │
└─────────────┴─────────────┴─────────────┘
```

### Terminal Multiplexing

With tmux:
```bash
tmux new-session -d -s agents
tmux split-window -h
tmux split-window -v
tmux select-pane -t 0
tmux split-window -v
# Now have 4 panes
```

Or just use multiple terminal windows/tabs.

## When to NOT Parallelize

- **Tightly coupled changes** — One change affects another
- **Learning new codebase** — Focus helps build mental model
- **Complex debugging** — Need to trace through system
- **Architecture decisions** — Need coherent vision

## Monitoring Agents

Watch for:

| Signal | Meaning | Action |
|--------|---------|--------|
| Agent reading files for 10+ min | Might be stuck | "what's the status" |
| Same error repeating | Wrong approach | Steer to different solution |
| Agent touching unexpected files | Scope creep | Refocus on assigned area |
| Long silence | Could be stuck or compacting | Check terminal |
| Rapid file changes | Working well | Let it continue |

## Debugging Multi-Agent Issues

### "Agent overwrote another agent's work"

Check: Were their areas properly separated?
Fix: Reassign areas, add to AGENTS.md

### "Agent is confused by changes it didn't make"

Check: Did another agent modify shared files?
Fix: "Those changes are from another agent, work around them"

### "Merge conflicts everywhere"

Check: Are agents working on overlapping files?
Fix: Reduce parallelism, work sequentially on shared areas

### "Agent committed other agent's changes"

Check: Is commit hygiene documented?
Fix: Add explicit commit rules to AGENTS.md
