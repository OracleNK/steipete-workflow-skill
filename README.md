# steipete-workflow

Agent skill that makes AI coding agents work autonomously and ship fast, based on [Peter Steinberger's](https://steipete.me) agentic engineering philosophy.

## What This Does

When an agent loads this skill, it:

- **Works autonomously** — Doesn't ask permission, just acts
- **Responds concisely** — No preamble, no pleasantries, just results
- **Commits atomically** — Only its own changes, conventional commits
- **Handles errors** — Tries to fix forward, reports blockers clearly
- **Coordinates with other agents** — Stays in its lane, doesn't touch others' work

Based on:
- [Shipping at Inference-Speed](https://steipete.me/posts/2025/shipping-at-inference-speed) (Dec 2025)
- [Just Talk To It](https://steipete.me/posts/just-talk-to-it) (Oct 2025)

## Installation

```bash
# Using npx skills
npx skills add oraclenk/steipete-workflow

# Or manual - Claude Code
git clone https://github.com/oraclenk/steipete-workflow ~/.claude/skills/steipete-workflow

# Or manual - Codex
git clone https://github.com/oraclenk/steipete-workflow ~/.codex/skills/steipete-workflow
```

## Contents

```
steipete-workflow/
├── SKILL.md              # Agent operating instructions
└── references/
    ├── agents-md-templates.md  # AGENTS.md templates
    ├── multi-agent.md          # Parallel agent coordination
    └── production.md           # Ship checklist
```

## Key Behaviors

| Before | After |
|--------|-------|
| "I'll help you with that! First, let me..." | *[just does the task]* |
| Asks permission before acting | Acts, reports result |
| Long explanations | Brief status |
| Creates branches per feature | Commits to main |
| Reverts on error | Fixes forward |

## Example

**Prompt:** "add stripe checkout"

**Without skill:**
> I'd be happy to help you add Stripe checkout! Let me walk you through the process. First, we'll need to install the Stripe SDK. Then we'll create an API endpoint. Would you like me to proceed with this approach?

**With skill:**
> Created:
> - api/checkout/route.ts - Stripe session endpoint
> - components/CheckoutButton.tsx - Client component
> 
> Test: `curl -X POST localhost:3000/api/checkout`
> 
> Committed: feat: add stripe checkout

## Credits

Philosophy by [Peter Steinberger](https://x.com/steipete).

## License

MIT
