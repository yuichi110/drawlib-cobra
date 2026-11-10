#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

export UV_DEFAULT_INDEX="${UV_DEFAULT_INDEX:-https://pypi.org/simple}"

echo "=== [1/5] Building Cobra User Guide (docs_src/ -> docs/) ==="
./docs_src/build_html.sh

echo "=== [2/5] Building Cobra API Reference Catalog (api_src/ -> docs/api/) ==="
./api_src/build_html.sh

echo "=== [3/5] Building Cobra Internal Architecture Guide (architecture_src/ -> docs/architecture/) ==="
./architecture_src/build_html.sh

echo "=== [4/5] Building PNI501 Diagnostic Report (reports_src/pni501_src/ -> docs/reports/pni501/) ==="
uvx --default-index "$UV_DEFAULT_INDEX" --from pni501@0.1.3 pni report build pni501 \
  --src-dir reports_src \
  --output-dir docs/reports/pni501 \
  --html-output-dir docs/reports/pni501 \
  -f pdf -f html

printf 'cobra.drawlib.com' > docs/CNAME
touch docs/.nojekyll

echo "=== [5/5] Verifying Link & Asset Integrity across all 4 Portals (docs/) ==="
uvx --default-index "$UV_DEFAULT_INDEX" drawlib@0.3.9 serve docs/ --check

echo "All 4 portals built and verified with zero broken links!"
