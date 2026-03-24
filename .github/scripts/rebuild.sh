#!/usr/bin/env bash
set -euo pipefail

# Rebuild script for wechaty/docusaurus
# Runs on existing source tree (no clone). Assumes CWD is docusaurus/ subdirectory.
# Installs deps and builds.

# --- Node version ---
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
(cd .. && npm install --no-audit --no-fund)

# --- Install docusaurus dependencies ---
npm install --no-audit --no-fund

# --- Build ---
npm run build

echo "[DONE] Build complete."
