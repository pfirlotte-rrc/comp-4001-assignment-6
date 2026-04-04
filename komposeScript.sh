# --- Kompose Installation ---

echo -e "\n--- Installing Kompose ---"
# Find the latest Kompose release (this is a more robust way to get the latest)
KOMPOSE_VERSION=$(curl -s https://api.github.com/repos/kubernetes/kompose/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Detected Kompose version: $KOMPOSE_VERSION"

# Download the Kompose binary
curl -L https://github.com/kubernetes/kompose/releases/download/${KOMPOSE_VERSION}/kompose-linux-amd64 -o kompose || { echo "Failed to download Kompose. Exiting."; exit 1; }
# Make it executable
chmod +x kompose || { echo "Failed to make Kompose executable. Exiting."; exit 1; }
# Move it to a directory in your PATH
sudo mv ./kompose /usr/local/bin/kompose || { echo "Failed to move Kompose to /usr/local/bin. Exiting."; exit 1; }

# Verify Kompose installation
kompose version || { echo "Kompose installation verification failed."; }
