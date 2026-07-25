#!/usr/bin/env bash
# ============================================================
# copy-from-source.sh
#
# Copies the active production codebase from a source project
# directory into this clean repository, respecting all exclusion
# rules defined in the problem statement.
#
# Usage:
#   bash scripts/copy-from-source.sh <SOURCE_DIR>
#
# Example:
#   bash scripts/copy-from-source.sh ~/projects/my-hotels-app
# ============================================================

set -euo pipefail

# ── Argument validation ──────────────────────────────────────
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <SOURCE_DIR>" >&2
  exit 1
fi

SOURCE_DIR="${1%/}"   # strip trailing slash

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: source directory '$SOURCE_DIR' does not exist." >&2
  exit 1
fi

# Resolve the target to the directory containing this script's parent
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Source : $SOURCE_DIR"
echo "Target : $TARGET_DIR"
echo ""

# ── rsync exclusion list ─────────────────────────────────────
# Mirrors the .gitignore exclusions plus git history itself.
EXCLUDES=(
  # Version-control & git history
  ".git/"

  # Dependencies (re-installed via npm install)
  "node_modules/"
  ".pnp"
  ".pnp.js"

  # Build / compiled output
  ".next/"
  "dist/"
  "build/"
  "out/"
  ".output/"
  ".vercel/"
  ".turbo/"

  # AI agent / legacy prompt artefacts
  ".claude/"
  ".agents/"
  ".cursorrules"
  "*.agent.md"
  "*_agent.md"
  "agent-logs/"
  "ai-logs/"

  # OS & editor noise
  ".DS_Store"
  "Thumbs.db"
  ".idea/"
  ".vscode/"
  "*.code-workspace"

  # Logs & temp
  "*.log"
  "logs/"
  "tmp/"
  "temp/"
  ".cache/"

  # Test artefacts
  "coverage/"
  ".nyc_output/"
  "test-results/"
  "playwright-report/"

  # Prisma generated client (re-generated on prisma generate)
  "prisma/generated/"

  # TypeScript incremental build info
  "*.tsbuildinfo"

  # Secrets (never copy; use .env.example instead)
  ".env"
  ".env.local"
  ".env.development.local"
  ".env.test.local"
  ".env.production.local"
)

# Build the --exclude flags array for rsync
RSYNC_EXCLUDES=()
for excl in "${EXCLUDES[@]}"; do
  RSYNC_EXCLUDES+=("--exclude=$excl")
done

# ── Run rsync ────────────────────────────────────────────────
echo "Copying files..."
rsync -av --progress \
  "${RSYNC_EXCLUDES[@]}" \
  "$SOURCE_DIR/" \
  "$TARGET_DIR/"

echo ""
echo "✅  Copy complete."
echo ""
echo "Next steps:"
echo "  cd $TARGET_DIR"
echo "  git init"
echo "  cp .env.example .env   # fill in real values"
echo "  npm install"
echo "  npm run build"
