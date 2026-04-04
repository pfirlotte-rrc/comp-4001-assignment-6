# Script design template

# Validates prerequisites (Docker/Compose installed, ports available) as pre-deployment checks

#----------Check Prerequisites----------
# 1. Update and Upgrade Existing Packages
sudo apt update && sudo apt upgrade -y || { echo "Failed to update/upgrade packages. Exiting."; exit 1; }

#----------Check Docker----------
if command -v docker &> /dev/null; then
    echo "Docker installation found"
else
    echo "Installing Docker."
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
fi

#----------Check Docker Compose----------
if command -v docker compose &> /dev/null; then
    echo "Docker compose installation found"
else
    echo "Installing Docker Compose."
    # ===== INSTALL DOCKER COMPOSE v2 =====
    echo "=== Installing Docker Compose v2 ==="
    DOCKER_COMPOSE_VERSION="2.23.0"
    sudo curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

#----------Check Port 3000----------
(echo > /dev/tcp/localhost/3000) >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Port 3000 is in use"
else
    echo "Port 3000 is available"
fi

##----------Check Port 5000----------
(echo > /dev/tcp/localhost/5000) >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Port 5000 is in use"
else
    echo "Port 5000 is available"
fi

# Cd into the directory containing your deployment artifacts.
#   - Validate the presence of your docker compose file.
cd M6_Part-1
if [[ ! -f docker-compose.yml ]] ; then
  echo "Docker Compose file does not exist"
fi

# Build & deploy with compose
docker compose up --build -d

# Performs health checks (e.g., curl/wget against http://localhost:3000 and http://localhost:5000 if available).
#   - Validate the build/deploy and list images.
wget --no-verbose --tries=1 --spider http://localhost:3000 || exit 1
wget --no-verbose --tries=1 --spider http://localhost:5000 || exit 1

# Show docker ps.
#   - Collect the container ID of the nginx image and save it as a variable.
docker ps
NGINX_ID=$(docker ps --filter "ancestor=nginx:alpine" --format "{{.ID}}")

# Validate the page renders at URL.
if curl --head --silent --max-time 10 http://localhost:3000 > /dev/null 2>&1; then
    echo "URL exists"
else
    echo "URL doesn't exist or isn't reachable"
fi

# Ensure jq is installed
if command -v jq &> /dev/null; then
    echo "jq installation found"
else
    echo "Installing jq."
    sudo apt install jq -y
fi

# Inspect nginx:alpine image that was created.
docker image inspect nginx:alpine

# Put the log of docker inspect nginx:alpine in a text file named nginx-logs
docker image inspect nginx:alpine > nginx-logs.txt


# Extract and echo the values of specified keys from the file.
#   - Extract & echo RepoTags
echo "RepoTags:     $(jq -r '.[0].RepoTags[]' nginx-logs.txt)"
#   - Extract & echo Created
echo "Created:      $(jq -r '.[0].Created'    nginx-logs.txt)"
#   - Extract & echo Os
echo "Os:           $(jq -r '.[0].Os'         nginx-logs.txt)"
#   - Extract & echo Config
echo "Config:"
jq '.[0].Config' nginx-logs.txt
#   - Extract & echo ExposedPorts
echo "ExposedPorts: $(jq -r '.[0].Config.ExposedPorts | keys[]' nginx-logs.txt)"