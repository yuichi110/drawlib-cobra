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

mkdir -p docs/pni501
echo "Building PNI501 Diagnostic Report PDF -> docs/pni501/pni501.pdf ..."
$DRAWLIB_CMD build pdf pni501_src/ -o docs/pni501/pni501.pdf -s pni501_src/styles.py -u pni501_src/utils.py --generate-index
if [ -f "docs/pni501/pni501_en.pdf" ]; then
    mv "docs/pni501/pni501_en.pdf" "docs/pni501/pni501.pdf"
fi
echo "PDF build complete: docs/pni501/pni501.pdf"
