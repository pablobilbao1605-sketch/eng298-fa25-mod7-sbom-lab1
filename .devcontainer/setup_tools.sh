#!/bin/bash
set -e

echo "[*] Updating base image..."
sudo apt-get update
sudo apt-get install -y curl wget unzip ca-certificates gnupg lsb-release python3-pip

echo "[*] Installing Syft (SBOM generator)..."
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sudo sh -s -- -b /usr/local/bin
syft version

echo "[*] Installing Grype (vuln scanner for SBOMs)..."
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sudo sh -s -- -b /usr/local/bin
grype version

echo "[*] Installing Trivy (scanner + CycloneDX SBOM gen)..."
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin
trivy --version

echo "[*] Installing cve-bin-tool (binary CVE scanner)..."
pip install --upgrade pip
pip install --no-cache-dir cve-bin-tool
cve-bin-tool --version

echo "[*] Setup complete."
