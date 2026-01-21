#!/bin/bash
set -euo pipefail

echo "=== CodeDeploy AfterInstall: START ==="

WEB_ROOT="/usr/share/nginx/html"
SRC="/opt/codedeploy-app"

echo "[1/6] Using web root: ${WEB_ROOT}"
echo "[2/6] Using source directory: ${SRC}"

echo "[3/6] Removing default Nginx content..."
rm -rf "${WEB_ROOT:?}/"*

echo "[4/6] Deploying new site files..."
cp -r "${SRC}/index.html" "${WEB_ROOT}/index.html"

if [ -d "${SRC}/assets" ]; then
  echo "[4.1] Copying assets directory..."
  cp -r "${SRC}/assets" "${WEB_ROOT}/assets"
else
  echo "[4.1] No assets directory found, skipping..."
fi

echo "[5/6] Setting permissions..."
chmod -R 755 "${WEB_ROOT}"

echo "[6/6] Reloading Nginx..."
nginx -t
systemctl reload nginx

echo "=== CodeDeploy AfterInstall: COMPLETE ==="
