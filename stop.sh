#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Stopping pgModeler Builder...${NC}"

# Stop docker-compose services
docker-compose down

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Docker containers stopped successfully!${NC}"
    
    # Clear xhost permissions for security
    if [ -f .env ]; then
        source .env
        if [ "$OS_TYPE" = "linux" ]; then
            echo -e "${YELLOW}Clearing X11 permissions for Linux...${NC}"
            xhost -local:docker
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}X11 permissions cleared successfully!${NC}"
            else
                echo -e "${YELLOW}Warning: Failed to clear X11 permissions.${NC}"
            fi
        elif [ "$OS_TYPE" = "macos" ]; then
            echo -e "${YELLOW}Clearing X11 permissions for macOS...${NC}"
            xhost -localhost:docker
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}X11 permissions cleared successfully!${NC}"
            else
                echo -e "${YELLOW}Warning: Failed to clear X11 permissions.${NC}"
            fi
        fi
    fi
    
    echo -e "${GREEN}pgModeler Builder stopped completely!${NC}"
else
    echo -e "${RED}Failed to stop Docker containers.${NC}"
    exit 1
fi
