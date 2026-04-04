# --- kubectl Installation ---

echo -e "\n--- Installing kubectl ---"
# Download the kubectl binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" || { echo "Failed to download kubectl. Exiting."; exit 1; }
# Validate the kubectl binary (optional but recommended)
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" || { echo "Failed to download kubectl checksum. Exiting."; exit 1; }
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check || { echo "kubectl checksum validation failed. Proceeding with caution or exiting."; } # Note: Added exit after check if you want it strict

# Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl || { echo "Failed to install kubectl. Exiting."; exit 1; }
# Clean up downloaded files
rm kubectl kubectl.sha256

# Verify kubectl installation
kubectl version --client || { echo "kubectl installation verification failed."; }
