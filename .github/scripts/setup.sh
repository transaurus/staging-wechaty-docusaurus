#!/bin/bash
# Generated setup script for: https://github.com/wechaty/docusaurus
# Docusaurus 3.x, npm, Node 18+, Docusaurus app in docusaurus/ subdirectory

set -e

REPO_URL="https://github.com/wechaty/docusaurus"
BRANCH="main"

log_info() { echo "[INFO] $1"; }
log_error() { echo "[ERROR] $1"; }

main() {
    log_info "Setting up: $REPO_URL"

    if [ -d "source-repo" ]; then
        rm -rf source-repo
    fi

    log_info "Cloning repository..."
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" source-repo
    cd source-repo

    log_info "Node version: $(node -v)"
    log_info "npm version: $(npm -v)"

    # Docusaurus app lives in docusaurus/ subdirectory
    cd docusaurus

    log_info "Installing dependencies..."
    npm install --legacy-peer-deps

    # ts-node is required by docusaurus.config.d/presets/preset-classic.js
    # to load sidebars.ts - it's not listed in package.json dependencies
    log_info "Installing ts-node..."
    npm install --save-dev ts-node --legacy-peer-deps

    log_info "Running write-translations..."
    npm run write-translations

    if [ -d "i18n" ]; then
        FILE_COUNT=$(find i18n -type f -name "*.json" | wc -l)
        log_info "Success! Generated $FILE_COUNT i18n JSON files."
        find i18n -type f -name "*.json" | head -20
    else
        log_error "i18n directory not found"
        exit 1
    fi

    log_info "Running build..."
    npm run build

    if [ -d "build" ] && [ "$(find build -type f | wc -l)" -gt 0 ]; then
        BUILD_COUNT=$(find build -type f | wc -l)
        log_info "Build success! $BUILD_COUNT files in build/"
    else
        log_error "build/ directory not found or empty"
        exit 1
    fi
}

main "$@"
