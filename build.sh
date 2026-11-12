#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

export UV_DEFAULT_INDEX="${UV_DEFAULT_INDEX:-https://pypi.org/simple}"

echo "=== [1/5] Building Cobra User Guide (user_guide_src/ -> docs/user_guide/) ==="
./user_guide_src/build_html.sh

echo "=== [2/5] Building Cobra API Reference Catalog (api_src/ -> docs/api/) ==="
./api_src/build_html.sh

echo "=== [3/5] Building Cobra Internal Architecture Guide (architecture_src/ -> docs/architecture/) ==="
./architecture_src/build_html.sh

echo "=== [4/5] Building PNI501 Diagnostic Report (pni501_src/ -> docs/pni501/) ==="
./pni501_src/build_html.sh
./pni501_src/build_pdf.sh

printf 'cobra.drawlib.com' > docs/CNAME
touch docs/.nojekyll

cat <<'EOF' > docs/sitemap.xml
<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <sitemap>
    <loc>https://cobra.drawlib.com/user_guide/sitemap.xml</loc>
  </sitemap>
  <sitemap>
    <loc>https://cobra.drawlib.com/api/sitemap.xml</loc>
  </sitemap>
  <sitemap>
    <loc>https://cobra.drawlib.com/architecture/sitemap.xml</loc>
  </sitemap>
  <sitemap>
    <loc>https://cobra.drawlib.com/pni501/sitemap.xml</loc>
  </sitemap>
</sitemapindex>
EOF

echo "=== [5/5] Verifying Link & Asset Integrity across Showcase Hub & all 4 Portals (docs/) ==="
uvx --default-index "$UV_DEFAULT_INDEX" drawlib@0.3.9 serve docs/ --check

echo "Showcase Hub and all 4 portals built and verified with zero broken links!"
