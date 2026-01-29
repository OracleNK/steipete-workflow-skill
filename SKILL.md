---
name: steipete-workflow
description: "Peter Steinberger's agentic engineering philosophy for shipping at inference-speed. Use when building software with AI agents, managing multi-agent workflows, structuring AGENTS.md files, making architecture decisions, or optimizing developer-agent collaboration. Triggers on: 'how should I work with agents', 'multi-agent setup', 'agentic workflow', 'shipping faster', 'vibe coding', 'AGENTS.md structure', 'context management', 'when to use plan mode', 'blast radius'."
---

# Steipete Workflow: Shipping at Inference-Speed

Philosophy distilled from Peter Steinberger's writings (Aug-Dec 2025). Core principle: **Less is more. Just talk to it.**

## Mindset

Your output is now limited by inference time and hard thinking, not typing speed. Most software is boring — data moves from form to database to display. The hard parts are:

- Distributed system design
- Picking dependencies and frameworks
- Forward-thinking database schema
- Language/ecosystem choices

**You don't read code anymore. You watch it stream.** Know where components are, how things connect, how the system is designed. That's enough.

## Working Style

### Commit to Main

No branches. No worktrees. No PRs for solo work.

```bash
# Your entire git workflow
git add -A && git commit -m "feat: added payment flow"
```

Why: Cognitive load of tracking different states is unnecessary. If something breaks, ask the agent to fix it or `git checkout .` to undo.

Exception: Truly risky experiments go in a separate folder, not a branch.

### Never Revert

If output isn't right, prompt the agent to change it. The agent can reset files or modify edits. Rarely need to go backward — just travel in a different direction.

Building software is like walking up a mountain. You don't go straight up. You circle, take turns, sometimes walk back. Eventually you arrive.

### Blast Radius Thinking

Before each prompt, estimate:
- How long will this take?
- How many files will it touch?
- What's the risk if it goes wrong?

Small blast radius = queue many tasks. Large blast radius = focus on one, watch closely.

If a task takes longer than expected, hit escape, ask "what's the status", then steer, abort, or continue.

### Prompts Are Short

With capable models, elaborate prompts are unnecessary. Often just 1-2 sentences + an image.

```
# Good prompts
"fix padding" + screenshot
"add stripe checkout"
"make this look less like AI slop"

# Unnecessary
"Please carefully implement a Stripe checkout flow following best practices..."
```

50% of prompts should include a screenshot. Drag image into terminal, add few words. The model finds strings, matches context, arrives at the right place.

### No Plan Mode

Don't use dedicated plan mode. Just talk to it:

```
"let's discuss how to add payments"
"give me options before making changes"
"write plan to docs/payments.md and build this"
```

Plan mode is a hack for older models that couldn't follow prompts. Current models can simply be asked to plan.

## Multi-Agent Patterns

### Parallel Agents

Run 1-2 agents normally. Scale to 3-4 for cleanup/tests/UI work. Scale to ~8 for intensive parallel work.

All agents work in the same folder on main. Pick tasks carefully so agents don't collide:
- Agent 1: Backend API
- Agent 2: Frontend UI
- Agent 3: Tests
- Agent 4: Database migrations

If agents touch different areas, interference is minimal. Commits stay isolated if agents only commit their own changes.

### Context Management

Don't restart sessions obsessively. Performance stays good even with full context. Often faster because files are already loaded.

Only restart when:
- Context is truly exhausted (compaction happening repeatedly)
- You're starting completely unrelated work
- Agent seems confused about project state

### Cross-Reference Projects

```
"look at ../other-project and do the same thing here"
"copy the auth pattern from ../vibetunnel"
```

Agents infer from context where to look. Saves prompts, maintains consistency across projects.

## AGENTS.md Structure

Keep one global AGENTS.md (~/.codex/AGENTS.md or ~/AGENTS.MD). Symlink to CLAUDE.md for compatibility.

### What to Include

```markdown
# Project Name

## Quick Context
One paragraph: what this is, tech stack, key patterns.

## Commands
dev: pnpm dev
test: pnpm test
build: pnpm build
logs: vercel logs or axiom cli

## Conventions
- Commit style: Conventional Commits (feat|fix|refactor|...)
- Files: Keep under ~500 LOC, split when larger
- Tests: Write in same context after building feature

## Patterns
[Project-specific patterns the agent should follow]

## Known Issues
[Things that break, workarounds]
```

### What to Avoid

- Screaming ALL CAPS threats (works for Claude, freaks out GPT)
- Generic advice the model already knows
- Lengthy explanations of obvious things
- "When to use" sections (put in description, not body)

### Let It Grow Organically

Don't write AGENTS.md upfront. Start minimal. When something goes wrong, ask the agent to "make a note in AGENTS.md". File grows from actual issues, not theoretical ones.

## Tool Philosophy

### CLIs Over MCPs

MCPs pollute context with tool definitions. CLIs cost zero context until used.

```markdown
# In AGENTS.md - this is enough
logs: use vercel cli or axiom cli
database: psql, load env with `source .env`
```

Agent tries random commands, CLI prints help, agent learns usage. No MCP overhead.

### Services Should Have CLIs

Pick services with CLI support: Vercel, Supabase, GitHub (gh), Stripe. Agents can use them directly.

### No RAG

Modern models search codebases well. No need for separate vector indexes. Just let the agent read files.

### No Subagents

Use separate terminal windows instead of subagents. Full visibility, full control over context. Subagents hide what's being sent back.

## Testing

Write tests in the same context after building the feature. Model finds issues better with full context of what was just built.

```
"now write tests for this"
```

Don't spin up separate session. Don't hand off to "testing agent". Same context = better tests.

## Refactoring

Spend ~20% of time on refactoring. Done by agents, not manually.

Typical refactor prompts:
- "run jscpd, dedupe what you find"
- "run knip, remove dead code"
- "this file is too big, split it"
- "find slow tests, rewrite them"
- "update to modern react patterns"

Refactor days are good when tired. Less focus needed, still productive.

## Documentation

Maintain docs in `docs/` folder per project. Write "write docs to docs/*.md" and let agent pick filename.

Structure docs so agents can navigate:
```
docs/
├── architecture.md
├── auth-flow.md
├── database-schema.md
└── api-patterns.md
```

Use a docs:list script to force agent to read relevant docs:
```markdown
# In AGENTS.md
Before working on auth, read docs/auth-flow.md
Before database changes, read docs/database-schema.md
```

## Starting New Features

### Small Features

Just prompt. No planning.

```
"add a button to export as PDF"
```

### Medium Features

Discuss first, then build:

```
"let's discuss adding user roles"
[conversation happens]
"ok build it"
```

### Large Features

1. Discuss with agent
2. Ask agent to write plan to docs/feature-name.md
3. Review plan (optionally with a second model)
4. Paste improvements back
5. "build this"

## What You Focus On

The agent writes code. You focus on:

1. **Architecture** — How systems connect, data flows, boundaries
2. **Dependencies** — Is this well-maintained? Popular enough for world knowledge?
3. **Database schema** — Changes here are painful later
4. **User experience** — Does this feel right?
5. **Steering** — Catch drift early, redirect

## Anti-Patterns

### Don't Do

- Branch per feature (for solo work)
- Elaborate prompting rituals
- Manual code review of every line
- Separate "planning sessions"
- Building orchestration systems for agents
- Issue trackers for personal projects
- Reverting and restarting

### Watch For

- Agent reading files for 15+ minutes (might be stuck)
- Same error appearing repeatedly (needs different approach)
- Agent making changes outside the task scope
- Context filling up too fast (might need to split work)

## Quick Reference

| Situation | Action |
|-----------|--------|
| Starting work | Just prompt, no ceremony |
| Unclear task | "let's discuss" or "give me options" |
| Task taking too long | Escape, "what's the status", steer |
| Something broke | Prompt to fix, don't revert |
| Need tests | "write tests" in same context |
| File too big | "split this file" |
| Code looks messy | "refactor this" |
| New feature area | "read docs/X.md first" |
| Multiple tasks | Queue them or run parallel agents |
| Agent confused | Check AGENTS.md, add clarification |

## The Core Loop

```
1. Prompt (short, maybe with image)
2. Watch stream
3. If drifting: escape, steer
4. If done: test manually or "write tests"
5. Commit
6. Next task
```

That's it. No ceremony. Just ship.
