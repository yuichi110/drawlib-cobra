#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PARENT_DIR"

if [ -z "${DRAWLIB_CMD:-}" ]; then
    if command -v drawlib &> /dev/null; then
        DRAWLIB_CMD="drawlib"
    elif command -v uvx &> /dev/null; then
        DRAWLIB_CMD="uvx --default-index ${UV_DEFAULT_INDEX:-https://pypi.org/simple} drawlib@0.3.9"
    else
        DRAWLIB_CMD="drawlib"
    fi
fi

# Preserve sub-portals (docs/api/, docs/architecture/, docs/reports/) and GitHub Pages docs/CNAME across root docs/ builds
PRESERVE_API=""
if [ -d "docs/api" ]; then
    mkdir -p .drawlib/scratch
    PRESERVE_API=".drawlib/scratch/_preserved_api_$$"
    rm -rf "$PRESERVE_API"
    cp -a "docs/api" "$PRESERVE_API"
fi

PRESERVE_ARCH=""
if [ -d "docs/architecture" ]; then
    mkdir -p .drawlib/scratch
    PRESERVE_ARCH=".drawlib/scratch/_preserved_arch_$$"
    rm -rf "$PRESERVE_ARCH"
    cp -a "docs/architecture" "$PRESERVE_ARCH"
fi

PRESERVE_REPORTS=""
if [ -d "docs/reports" ]; then
    mkdir -p .drawlib/scratch
    PRESERVE_REPORTS=".drawlib/scratch/_preserved_reports_$$"
    rm -rf "$PRESERVE_REPORTS"
    cp -a "docs/reports" "$PRESERVE_REPORTS"
fi

PRESERVE_CNAME=""
if [ -f "docs/CNAME" ]; then
    mkdir -p .drawlib/scratch
    PRESERVE_CNAME=".drawlib/scratch/_preserved_CNAME_$$"
    rm -f "$PRESERVE_CNAME"
    cp -a "docs/CNAME" "$PRESERVE_CNAME"
fi

echo "Building Cobra User Guide HTML site -> docs/ ..."
$DRAWLIB_CMD build html docs_src/ -o docs/ -s docs_src/styles.py -u docs_src/utils.py

if [ -n "$PRESERVE_API" ] && [ -d "$PRESERVE_API" ]; then
    mkdir -p docs
    if [ ! -d "docs/api" ]; then
        mv "$PRESERVE_API" "docs/api"
    else
        rm -rf "$PRESERVE_API"
    fi
fi

if [ -n "$PRESERVE_ARCH" ] && [ -d "$PRESERVE_ARCH" ]; then
    mkdir -p docs
    if [ ! -d "docs/architecture" ]; then
        mv "$PRESERVE_ARCH" "docs/architecture"
    else
        rm -rf "$PRESERVE_ARCH"
    fi
fi

if [ -n "$PRESERVE_REPORTS" ] && [ -d "$PRESERVE_REPORTS" ]; then
    mkdir -p docs
    if [ ! -d "docs/reports" ]; then
        mv "$PRESERVE_REPORTS" "docs/reports"
    else
        rm -rf "$PRESERVE_REPORTS"
    fi
fi

if [ -n "$PRESERVE_CNAME" ] && [ -f "$PRESERVE_CNAME" ]; then
    mkdir -p docs
    if [ ! -f "docs/CNAME" ]; then
        mv "$PRESERVE_CNAME" "docs/CNAME"
    else
        rm -f "$PRESERVE_CNAME"
    fi
elif [ ! -f "docs/CNAME" ]; then
    printf 'cobra.drawlib.com' > docs/CNAME
fi

touch docs/.nojekyll
echo "HTML site build complete: docs/"
