#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting pgModeler Builder...${NC}"

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}File .env not found. Running setup...${NC}"
    ./setup.sh
    if [ $? -ne 0 ]; then
        echo -e "${RED}Setup failed. Exiting.${NC}"
        exit 1
    fi
fi

# Source .env file to get OS_TYPE
if [ -f .env ]; then
    source .env
else
    echo -e "${RED}Failed to create .env file. Exiting.${NC}"
    exit 1
fi

# Validate OS_TYPE
if [ -z "$OS_TYPE" ]; then
    echo -e "${RED}OS_TYPE not found in .env file. Please run setup again.${NC}"
    exit 1
fi

case "$OS_TYPE" in
    "linux")
        echo -e "${GREEN}Detected Linux OS. Setting up X11 forwarding...${NC}"
        xhost +local:docker
        if [ $? -ne 0 ]; then
            echo -e "${YELLOW}Warning: xhost command failed. GUI may not work properly.${NC}"
        fi
        ;;
    "macos")
        echo -e "${GREEN}Detected macOS. Setting up X11 forwarding...${NC}"
        echo -e "${YELLOW}Make sure XQuartz is running...${NC}"
        xhost +localhost:docker
        if [ $? -ne 0 ]; then
            echo -e "${YELLOW}Warning: xhost command failed. GUI may not work properly.${NC}"
            echo -e "${YELLOW}Please make sure XQuartz is installed and running.${NC}"
        fi
        ;;
    *)
        echo -e "${RED}Invalid OS_TYPE: $OS_TYPE. Expected 'linux' or 'macos'.${NC}"
        echo -e "${YELLOW}Please run setup again to regenerate .env file.${NC}"
        exit 1
        ;;
esac

# Start docker-compose
echo -e "${GREEN}Starting Docker containers...${NC}"
docker-compose up -d

if [ $? -eq 0 ]; then
    echo -e "${GREEN}pgModeler Builder started successfully!${NC}"
    echo -e "${YELLOW}You can check the logs with: docker-compose logs -f${NC}"
else
    echo -e "${RED}Failed to start Docker containers.${NC}"
    exit 1
fi
