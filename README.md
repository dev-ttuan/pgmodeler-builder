# pgModeler Builder

A Docker-based solution for building and running pgModeler (PostgreSQL Database Modeler) with a complete development environment.

## Overview

This project provides a containerized environment to build and run pgModeler from source. pgModeler is a powerful PostgreSQL database modeling tool that allows you to create, edit, and manage database schemas visually.

## Features

- **Complete Build Environment**: Builds pgModeler from source using Qt6 on Ubuntu 24.04
- **GUI Support**: Full X11 forwarding support for running the graphical interface
- **User Management**: Proper user/group mapping for file permissions
- **Plugin Support**: Includes pgModeler plugins
- **Configurable**: Supports building from different branches/tags
- **Persistent Configuration**: Volume mounting for pgModeler settings

## Prerequisites

- Docker and Docker Compose
- X11 server (for GUI support on Linux)
- XQuartz (for GUI support on macOS)

## Quick Start

1. **Clone the repository**:

   ```bash
   git clone <repository-url>
   cd pgmodeler-builder
   ```

2. **Setup the environment**:

   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

3. **Build and run pgModeler**:
   ```bash
   docker-compose up --build
   ```

## Configuration

### Environment Variables

The `setup.sh` script automatically generates a `.env` file with:

- `USER_ID`: Your user ID (auto-detected)
- `GROUP_ID`: Your group ID (auto-detected)
- `DISPLAY`: X11 display configuration (auto-detected based on OS)

### Build Arguments

You can customize the build by modifying the `PGMODELER_REF` argument in the Dockerfile:

- `main` (default): Latest development version
- `v1.1.0`: Specific release version
- Any valid git branch or tag

## Usage

### Running pgModeler

After building, pgModeler will start automatically. The GUI should appear on your desktop.

### File Access

- **Workspace**: The current directory is mounted to `/workspace` in the container
- **Configuration**: pgModeler settings are persisted in a Docker volume
- **Data**: Use the `data/` directory for your database models and files

### Command Line Usage

You can also run pgModeler in command-line mode:

```bash
docker-compose run --rm pgmodeler pgmodeler --help
```

## Project Structure

```
pgmodeler-builder/
├── Dockerfile          # Multi-stage build configuration
├── docker-compose.yml  # Service definition and volume mounts
├── setup.sh           # Environment setup script
├── data/              # Directory for your database models
├── .env               # Auto-generated environment variables
└── README.md          # This file
```

## Troubleshooting

### GUI Issues

If pgModeler doesn't start with GUI:

1. **Linux**: Ensure X11 forwarding is enabled:

   ```bash
   xhost +local:docker
   ```

2. **macOS**: Make sure XQuartz is running and configured properly

3. **XCB Plugin Errors**: Uncomment the XCB libraries in the Dockerfile if you encounter X11 plugin errors

### Permission Issues

If you encounter file permission issues, ensure the `USER_ID` and `GROUP_ID` in `.env` match your system user.

### Build Issues

- Ensure you have sufficient disk space for the build
- Check that all required dependencies are available
- Verify internet connectivity for git clone operations

## Development

### Customizing the Build

To modify the build process:

1. Edit the `Dockerfile` to change dependencies or build steps
2. Modify `docker-compose.yml` for runtime configuration
3. Rebuild with: `docker-compose up --build`

### Adding Plugins

Additional plugins can be added by modifying the git clone section in the Dockerfile.

## License

This project follows the same license as pgModeler. Please refer to the [pgModeler repository](https://github.com/pgmodeler/pgmodeler) for license details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Links

- [pgModeler Official Website](https://pgmodeler.io/)
- [pgModeler GitHub Repository](https://github.com/pgmodeler/pgmodeler)
- [pgModeler Documentation](https://docs.pgmodeler.io/)
