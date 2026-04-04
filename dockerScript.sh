    # --- Docker Installation ---

    # 2. Install Required Dependencies for Docker (already good)
    echo -e "\n--- Installing required dependencies for Docker ---"
    sudo apt install -y ca-certificates curl gnupg lsb-release || { echo "Failed to install Docker dependencies. Exiting."; exit 1; }


    # 3. Add Docker's Official GPG Key
    # This command directly adds the GPG key to the trusted.gpg.d directory for apt.
    echo -e "\n--- Adding Docker's official GPG key ---"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg || { echo "Failed to download/add Docker GPG key. Exiting."; exit 1; }
    sudo chmod a+r /etc/apt/keyrings/docker.gpg # Set permissions to be readable by all

    # 4. Add the Docker APT Repository
    # This command adds the repository using the new 'signed-by' syntax with the direct GPG key file path.
    echo -e "\n--- Adding the Docker APT repository ---"
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || { echo "Failed to add Docker repository. Exiting."; exit 1; }

    # 5. Update apt Package Index Again
    echo -e "\n--- Updating apt package index again for Docker ---"
    sudo apt update || { echo "Failed to update apt index for Docker. Exiting."; exit 1; }

    # 6. Install Docker Engine, CLI, and Containerd
    echo -e "\n--- Installing Docker Engine, CLI, and Containerd ---"
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || { echo "Failed to install Docker components. Exiting."; exit 1; }

    # 7. Add Your User to the 'docker' Group
    echo -e "\n--- Adding current user ($USER) to the 'docker' group ---"
    sudo usermod -aG docker $USER || { echo "Failed to add user to docker group. Exiting."; exit 1; }

    # 8. (Optional) Configure Docker Service to Start Automatically
    echo -e "\n--- (Optional) Adding Docker service start command to ~/.bashrc ---"
    if ! grep -q "sudo service docker start" ~/.bashrc; then
        echo 'sudo service docker start > /dev/null 2>&1 || true' >> ~/.bashrc
        echo "Added 'sudo service docker start' to ~/.bashrc."
    else
        echo "Line already exists in ~/.bashrc. Skipping."
    fi