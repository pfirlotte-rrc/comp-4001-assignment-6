# Script design template

# Validates prerequisites (Docker/Compose installed, ports available) as pre-deployment checks

#----------Check Prerequisites----------
# 1. Update and Upgrade Existing Packages
sudo apt update && sudo apt upgrade -y || { echo "Failed to update/upgrade packages. Exiting."; exit 1; }

#----------Check Docker----------
if command -v docker &> /dev/null; then
    echo "Docker installation found"
else
    echo "Install Docker."
fi

#----------Check Docker Compose----------
if command -v docker compose &> /dev/null; then
    echo "Docker compose installation found"
else
    echo "Install Docker Compose."
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
wget --no-verbose --tries=1 --spider http://localhost/3000 || exit 1
wget --no-verbose --tries=1 --spider http://localhost/5000 || exit 1

# Show docker ps.
#   - Collect the container ID of the nginx image and save it as a variable.


# Validate the page renders at URL.


# Ensure jq is installed, then inspect nginx:alpine image that was created.


# Put the log of docker inspect nginx:alpine in a text file named nginx#logs


# Extract and echo the values of specified keys from the file.
#   - Extract RepoTags
#   - Extract Created
#   - Extract Os
#   - Extract Config
#   - Extract ExposedPorts