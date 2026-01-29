# steipete-workflow

An agent skill that encapsulates [Peter Steinberger's](https://steipete.me) agentic engineering philosophy for shipping software at inference-speed.

## What This Skill Does

Teaches AI coding agents to work the way Peter does:

- **Short prompts** — 1-2 sentences + screenshots, not elaborate instructions
- **Commit to main** — No branches for solo work, no PRs, no ceremony
- **Never revert** — Prompt to fix instead of resetting
- **Blast radius thinking** — Estimate impact before each task
- **Multi-agent coordination** — Run 1-8 agents in parallel on the same codebase
- **No plan mode** — Just say "let's discuss" instead of special modes

Based on Peter's blog posts:
- [Shipping at Inference-Speed](https://steipete.me/posts/2025/shipping-at-inference-speed) (Dec 2025)
- [Just Talk To It](https://steipete.me/posts/just-talk-to-it) (Oct 2025)
- [My Current AI Dev Workflow](https://steipete.me/posts/2025/optimal-ai-development-workflow) (Aug 2025)

## Installation

### Using npx skills (recommended)

```bash
npx skills add oraklenk/steipete-workflow
```

### Manual Installation

**Claude Code:**
```bash
git clone https://github.com/oraklenk/steipete-workflow.git ~/.claude/skills/steipete-workflow
```

**Codex:**
```bash
git clone https://github.com/oraklenk/steipete-workflow.git ~/.codex/skills/steipete-workflow
```

**Project-local:**
```bash
git clone https://github.com/oraclenk/steipete-workflow.git .claude/skills/steipete-workflow
```

## Contents

```
steipete-workflow/
├── SKILL.md                    # Core philosophy and workflow
├── references/
│   ├── agents-md-templates.md  # Ready-to-use AGENTS.md templates
│   ├── multi-agent-patterns.md # Running parallel agents
│   ├── architecture-decisions.md # Where humans add value
│   └── production-checklist.md # Ship sellable products
└── scripts/
    └── init-agents-md.sh       # Generate AGENTS.md for any project
```

## Usage

The skill activates automatically when you mention:
- "how should I work with agents"
- "multi-agent setup"
- "agentic workflow"
- "shipping faster"
- "AGENTS.md structure"
- "blast radius"

Or explicitly reference it in your prompt.

### Initialize AGENTS.md for a Project

```bash
~/.claude/skills/steipete-workflow/scripts/init-agents-md.sh ./my-project "My Project"
```

Auto-detects tech stack and generates a minimal AGENTS.md.

## Key Concepts

### Blast Radius

Before each prompt, estimate:
- How long will this take?
- How many files will it touch?
- What's the risk if it goes wrong?

Small blast radius = queue many tasks. Large blast radius = focus and watch.

### Multi-Agent Scaling

| Situation | Agents |
|-----------|--------|
| Normal work | 1-2 |
| Feature + tests | 2 |
| UI + backend + tests | 3 |
| Cleanup day | 3-4 |
| Intensive shipping | 4-8 |

### The Core Loop

```
1. Prompt (short, maybe with image)
2. Watch stream
3. If drifting: escape, steer
4. If done: "write tests" in same context
5. Commit
6. Next task
```

## Credits

Philosophy by [Peter Steinberger](https://x.com/steipete). Skill compiled from his public writings.

## License

MIT
