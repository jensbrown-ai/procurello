#!/usr/bin/env bash
# Downloads the three product images referenced by catalog-guided-buying.html
# into this folder. Run from project root: bash images/download-images.sh
#
# Requires: curl (preinstalled on macOS and most Linux distros)
# On Windows, run from Git Bash, WSL, or substitute Invoke-WebRequest in PowerShell.

set -e
cd "$(dirname "$0")"

echo "Downloading product images into $(pwd)..."
echo ""

curl -sSL --fail -o microflex.png \
  "https://www.mimilk.com/wp-content/uploads/2023/02/5038.5043.5044.5045.5046.5049midknight.png" \
  && echo "✓ microflex.png" \
  || echo "✗ microflex.png — failed (check URL or hotlink policy)"

curl -sSL --fail -o vwr.jpg \
  "https://www.cliawaived.com/media/catalog/product/cache/9d02d92ddd22ed701b82526ad1ff3948/v/w/vwr-82026_1_1.jpg" \
  && echo "✓ vwr.jpg" \
  || echo "✗ vwr.jpg — failed (check URL or hotlink policy)"

curl -sSL --fail -o ansell.png \
  "https://industrialsafety.com/media/catalog/product/cache/99dc5e1dc90eb9727970ba1a904a05a5/t/o/touchntuff_92-600_boxonly.ashx.png" \
  && echo "✓ ansell.png" \
  || echo "✗ ansell.png — failed (check URL or hotlink policy)"

echo ""
echo "Done. If any download failed, save the image manually from the URL"
echo "in the README and place it in this folder with the matching filename."
