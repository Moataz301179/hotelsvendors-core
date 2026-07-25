# hotelsvendors-core

Clean, production-ready repository for the Hotels Vendors Core application.

---

## Copying from an existing project

Use the provided script to copy **only the active production codebase** from your
existing project directory into this folder.  The script excludes all heavy or
unnecessary paths (see [Exclusion rules](#exclusion-rules) below).

```bash
# From the root of this repository:
bash scripts/copy-from-source.sh <PATH_TO_YOUR_SOURCE_PROJECT>

# Example:
bash scripts/copy-from-source.sh ~/projects/hotels-app
```

The script uses `rsync`, so re-running it is safe — it only copies changed files.

---

## Fresh setup after copying

```bash
# 1. Initialize a new git history
git init
git add .
git commit -m "chore: initial production snapshot"

# 2. Configure environment variables
cp .env.example .env
# → Edit .env and fill in real values

# 3. Install dependencies
npm install

# 4. Build
npm run build

# 5. Start (production)
npm start
# or with PM2:
# pm2 start ecosystem.config.js
```

---

## Exclusion rules

The following paths are **never** copied or committed:

| Category | Paths excluded |
|---|---|
| Dependencies | `node_modules/`, `.pnp` |
| Build output | `.next/`, `dist/`, `build/`, `out/`, `.output/`, `.vercel/`, `.turbo/` |
| Git history | `.git/` |
| AI / agent artefacts | `.claude/`, `.agents/`, `*.agent.md`, `agent-logs/`, `ai-logs/` |
| Secrets | `.env`, `.env.local`, `.env.*.local` |
| OS / editor noise | `.DS_Store`, `.idea/`, `.vscode/` |
| Logs & temp | `*.log`, `logs/`, `tmp/`, `temp/`, `.cache/` |
| Test artefacts | `coverage/`, `playwright-report/`, `test-results/` |
| Generated code | `prisma/generated/`, `*.tsbuildinfo` |

These same rules are enforced by `.gitignore` so none of these files can be
accidentally committed.