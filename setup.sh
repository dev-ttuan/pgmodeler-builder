# Create data directory 
mkdir -p data

rm -rf .env

# Create .env with auto-generated warning
cat > .env << EOF
# AUTO-GENERATED FILE - DO NOT EDIT
# Generated: $(date)

USER_ID=$(id -u)
GROUP_ID=$(id -g)
OS_TYPE=$([[ "$OSTYPE" == "darwin"* ]] && echo "macos" || echo "linux")
DISPLAY=$([[ "$OSTYPE" == "darwin"* ]] && echo "host.docker.internal:0" || echo ":0")
EOF
