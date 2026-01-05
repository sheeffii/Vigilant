#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[Vigilant.io] Setting up LocalStack lab environment..."

cd "${ROOT_DIR}/terraform"

echo "[Vigilant.io] Running tflocal init..."
tflocal init -input=false

echo "[Vigilant.io] Applying Terraform configuration via tflocal..."
tflocal apply -auto-approve

echo "[Vigilant.io] Creating unmanaged S3 bucket via awslocal to simulate drift..."
awslocal s3 mb s3://vigilant-unmanaged-bucket || echo "Unmanaged bucket may already exist."

echo "[Vigilant.io] Lab setup complete."


