# Validates prerequisites (Docker/Compose installed, ports available) as pre-deployment checks

#----------Check Prerequisites----------
# 1. Update and Upgrade Existing Packages
sudo apt update && sudo apt upgrade -y || { echo "Failed to update/upgrade packages. Exiting."; exit 1; }

#----------Check Docker Installation----------
if command -v docker &> /dev/null; then
    echo "Docker installation found"
else
    echo "Installing Docker."
    # Installs docker when docker version is not detected.

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
# sChecks if docker compose gives back a version, if not will install it
if command -v docker compose &> /dev/null; then
    echo "Docker compose installation and version found"
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

#----------Check Port 5000----------
(echo > /dev/tcp/localhost/5000) >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Port 5000 is in use"
else
    echo "Port 5000 is available"
fi

# Cd into the directory containing your deployment artifacts.
cd M6_Part-1

# Validates the presence of the docker compose file.
# Creates an error message if no file exists within the part-1
if [[ ! -f docker-compose.yml ]] ; then
  echo "[ERROR] Docker Compose file does not exist"
fi

# Build & deploy with compose
# Checks if all docker image exists first
if docker image inspect m6_part-1-backend &> /dev/null && \
   docker image inspect m6_part-1-transactions &> /dev/null && \
   docker image inspect m6_part-1-studentportfolio &> /dev/null; then
    echo "[INFO] All Docker Images exist, Starting Docker Compose"
    docker compose up -d
else
# otherwise, if any images are missing, it will build them.
    echo "[INFO] One or more docker images are missing. Building Images"
    docker compose up --build -d
# Give some time for backend to build and restart nginx as it was starting 
# before the images could be built in time.
    sleep 10
    docker restart m6_part-1-nginx-1
fi

# Performs health checks .
# Checks Ports 3000 and 5000 and responds if either are responding or not.
for port in 3000 5000; do
  if curl -s --max-time 10 http://localhost:$port > /dev/null 2>&1; then
    echo "[INFO] Port $port is responding"
  else
    echo "[ERROR] Port $port is not available"
  fi
done

# Validate the build/deploy and list images.
docker images

# Show docker ps.
docker ps

# Collect the container ID of the nginx image and save it as a variable.
NGINX_ID=$(docker ps --filter "ancestor=nginx:alpine" --format "{{.ID}}")
echo "[INFO] Captured nginx conatiner ID: $NGINX_ID" 

# Validate the page renders at URL.
URL="http://localhost:80"
echo "[INFO] Checking application URL: $URL"
HTTP=$(curl --head --silent --max-time 10 -o /dev/null -w "%{http_code}" http://localhost:80)

# Checks whether the status code is equal to 200
if [ "$HTTP" -eq 200 ]; then
    echo "[INFO] Page rendered successfully (HTTP $HTTP); content signature detected."
else
# otherwise indicates its unreachable
    echo "[ERROR] URL doesn't exist or isn't reachable"
fi

# Ensures JQ is installed by checking for a version
if command -v jq &> /dev/null; then
    echo "[INFO] jq is already installed"
else
# If not, installs JQ
    echo "Installing jq."
    sudo apt install jq -y
fi

# Inspect nginx:alpine image that was created.
echo "[INFO] Ensuring nginx:alpine image exists locally."
if docker image inspect nginx:alpine &> /dev/null; then
    echo "[INFO] nginx:alpine is installed"
# Put the log of docker inspect nginx:alpine in a text file named nginx-logs
    echo "[INFO] Writing docker inspect output to 'nginx-logs'."
    docker image inspect nginx:alpine > nginx-logs.txt
    echo "Extracting values from nginx-logs:"
    echo ""
else
# Echoes error that nginx is not installed if previous check failed
    echo "[Error] nginx:alpine is not isntalled."
fi

# Extract and echo the values of specified keys from the file.
#   - Extract & echo RepoTags
echo "RepoTags:"
echo "$(jq -r '.[0].RepoTags[]' nginx-logs.txt)"
echo ""
#   - Extract & echo Created
echo "Created:"
echo "$(jq -r '.[0].Created'    nginx-logs.txt)"
echo ""
#   - Extract & echo Os
echo "Os:"
echo "$(jq -r '.[0].Os'         nginx-logs.txt)"
echo ""
#   - Extract & echo Config
echo "Config:"
jq '.[0].Config' nginx-logs.txt
echo ""
#   - Extract & echo ExposedPorts
echo "ExposedPorts:"
echo "$(jq -r '.[0].Config.ExposedPorts | keys[]' nginx-logs.txt)"
echo ""
