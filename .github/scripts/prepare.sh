#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/wechaty/docusaurus"
BRANCH="main"
REPO_DIR="source-repo"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Clone (skip if already exists) ---
if [ ! -d "$REPO_DIR" ]; then
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$REPO_DIR"
fi

cd "$REPO_DIR"

# --- Node version ---
# CI uses Node 20. Ensure we have it via nvm if needed.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ -f "$NVM_DIR/nvm.sh" ]; then
    # shellcheck disable=SC1091
    source "$NVM_DIR/nvm.sh"
    nvm install 20
    nvm use 20
fi

echo "[INFO] Node: $(node --version), npm: $(npm --version)"

# --- Install root dependencies ---
# Required because docusaurus.config.d/presets/preset-classic.js uses ts-node/register
# (ts-node is a transitive dep of root devDependencies, resolved via Node module lookup)
npm install --no-audit --no-fund

# --- Install dependencies for docusaurus subdirectory ---
cd docusaurus
npm install --no-audit --no-fund

# --- Apply fixes.json if present ---
FIXES_JSON="$SCRIPT_DIR/fixes.json"
if [ -f "$FIXES_JSON" ]; then
    echo "[INFO] Applying content fixes..."
    node -e "
    const fs = require('fs');
    const path = require('path');
    const fixes = JSON.parse(fs.readFileSync('$FIXES_JSON', 'utf8'));
    for (const [file, ops] of Object.entries(fixes.fixes || {})) {
        if (!fs.existsSync(file)) { console.log('  skip (not found):', file); continue; }
        let content = fs.readFileSync(file, 'utf8');
        for (const op of ops) {
            if (op.type === 'replace' && content.includes(op.find)) {
                content = content.split(op.find).join(op.replace || '');
                console.log('  fixed:', file, '-', op.comment || '');
            }
        }
        fs.writeFileSync(file, content);
    }
    for (const [file, cfg] of Object.entries(fixes.newFiles || {})) {
        const c = typeof cfg === 'string' ? cfg : cfg.content;
        fs.mkdirSync(path.dirname(file), {recursive: true});
        fs.writeFileSync(file, c);
        console.log('  created:', file);
    }
    "
fi

echo "[DONE] Repository is ready for docusaurus commands."
