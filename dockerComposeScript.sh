# ===== INSTALL DOCKER COMPOSE v2 =====
    echo "=== Installing Docker Compose v2 ==="
    DOCKER_COMPOSE_VERSION="2.23.0"
    sudo curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose