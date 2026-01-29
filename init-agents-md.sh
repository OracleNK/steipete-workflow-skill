#!/bin/bash
# init-agents-md.sh - Initialize AGENTS.md for a project
# Usage: ./init-agents-md.sh [project-path] [project-name]

set -e

PROJECT_PATH="${1:-.}"
PROJECT_NAME="${2:-$(basename "$(cd "$PROJECT_PATH" && pwd)")}"

AGENTS_FILE="$PROJECT_PATH/AGENTS.md"

if [ -f "$AGENTS_FILE" ]; then
  echo "AGENTS.md already exists at $AGENTS_FILE" >&2
  exit 1
fi

# Detect tech stack
detect_stack() {
  local path="$1"
  local stack=""
  
  if [ -f "$path/package.json" ]; then
    if grep -q '"next"' "$path/package.json" 2>/dev/null; then
      stack="TypeScript, Next.js"
    elif grep -q '"react"' "$path/package.json" 2>/dev/null; then
      stack="TypeScript, React"
    elif grep -q '"expo"' "$path/package.json" 2>/dev/null; then
      stack="TypeScript, Expo, React Native"
    else
      stack="TypeScript/JavaScript"
    fi
    
    if grep -q '"tailwind"' "$path/package.json" 2>/dev/null; then
      stack="$stack, Tailwind"
    fi
  elif [ -f "$path/go.mod" ]; then
    stack="Go"
  elif [ -f "$path/pyproject.toml" ] || [ -f "$path/requirements.txt" ]; then
    stack="Python"
  elif [ -f "$path/Cargo.toml" ]; then
    stack="Rust"
  else
    stack="[TODO: Add tech stack]"
  fi
  
  echo "$stack"
}

# Detect package manager
detect_pm() {
  local path="$1"
  
  if [ -f "$path/pnpm-lock.yaml" ]; then
    echo "pnpm"
  elif [ -f "$path/yarn.lock" ]; then
    echo "yarn"
  elif [ -f "$path/bun.lockb" ]; then
    echo "bun"
  elif [ -f "$path/package-lock.json" ]; then
    echo "npm"
  else
    echo ""
  fi
}

STACK=$(detect_stack "$PROJECT_PATH")
PM=$(detect_pm "$PROJECT_PATH")

# Generate commands based on detection
if [ -n "$PM" ]; then
  DEV_CMD="$PM run dev"
  TEST_CMD="$PM test"
  BUILD_CMD="$PM run build"
  LINT_CMD="$PM run lint"
elif [ -f "$PROJECT_PATH/go.mod" ]; then
  DEV_CMD="go run ."
  TEST_CMD="go test ./..."
  BUILD_CMD="go build"
  LINT_CMD="golangci-lint run"
elif [ -f "$PROJECT_PATH/pyproject.toml" ]; then
  DEV_CMD="python main.py"
  TEST_CMD="pytest"
  BUILD_CMD="python -m build"
  LINT_CMD="ruff check . && ruff format ."
else
  DEV_CMD="[TODO]"
  TEST_CMD="[TODO]"
  BUILD_CMD="[TODO]"
  LINT_CMD="[TODO]"
fi

cat > "$AGENTS_FILE" << EOF
# $PROJECT_NAME

Brief: [TODO: One sentence about what this project does]

Stack: $STACK

## Commands
dev: $DEV_CMD
test: $TEST_CMD
build: $BUILD_CMD
lint: $LINT_CMD

## Rules
- Commits: Conventional Commits (feat|fix|refactor|docs|chore|test)
- Files: Keep under 500 LOC, split when larger
- Tests: Write in same context after building features

## Patterns
[TODO: Add project-specific patterns]

## Notes
[Agent adds notes here when things go wrong]
EOF

echo "Created $AGENTS_FILE" >&2
echo "Stack detected: $STACK" >&2
echo "" >&2
echo "Next steps:" >&2
echo "1. Fill in the Brief" >&2
echo "2. Verify/fix the Commands" >&2
echo "3. Add project-specific Patterns" >&2
