#!/usr/bin/env bash

# Home Manager update script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
USERNAME=$(whoami)
HOSTNAME=$(hostname)
FLAKE_PATH="."

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -u, --username USER Set username [default: current user]"
    echo "  -H, --hostname HOST Set hostname [default: current hostname]"
    echo "  -f, --flake PATH    Set flake path [default: current directory]"
    echo "  -U, --update        Update flake inputs before applying"
    echo "  -c, --check         Check configuration without applying"
    echo ""
    echo "Examples:"
    echo "  $0                  # Basic home-manager switch"
    echo "  $0 -U               # Update and apply"
    echo "  $0 -u myuser        # Apply for specific user"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -u|--username)
            USERNAME="$2"
            shift 2
            ;;
        -H|--hostname)
            HOSTNAME="$2"
            shift 2
            ;;
        -f|--flake)
            FLAKE_PATH="$2"
            shift 2
            ;;
        -U|--update)
            UPDATE_FLAKE=true
            shift
            ;;
        -c|--check)
            CHECK_ONLY=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

echo -e "${BLUE}Home Manager Update Script${NC}"
echo -e "${BLUE}=========================${NC}"
echo -e "Username: ${GREEN}$USERNAME${NC}"
echo -e "Hostname: ${GREEN}$HOSTNAME${NC}"
echo -e "Flake: ${GREEN}$FLAKE_PATH${NC}"
echo ""

# Check if we're in the right directory
if [[ ! -f "$FLAKE_PATH/flake.nix" ]]; then
    echo -e "${RED}Error: flake.nix not found in $FLAKE_PATH${NC}"
    exit 1
fi

# Update flake inputs if requested
if [[ "$UPDATE_FLAKE" == "true" ]]; then
    echo -e "${YELLOW}Updating flake inputs...${NC}"
    nix flake update "$FLAKE_PATH"
    echo ""
fi

# Check configuration syntax if requested
if [[ "$CHECK_ONLY" == "true" ]]; then
    echo -e "${YELLOW}Checking Home Manager configuration...${NC}"
    home-manager build --flake "$FLAKE_PATH#$USERNAME@$HOSTNAME"
    echo -e "${GREEN}Configuration check passed!${NC}"
    exit 0
fi

# Apply the Home Manager configuration
echo -e "${YELLOW}Applying Home Manager configuration...${NC}"
FLAKE_REF="$FLAKE_PATH#$USERNAME@$HOSTNAME"

echo -e "${BLUE}Running: home-manager switch --flake $FLAKE_REF${NC}"
echo ""

# Execute the switch
if home-manager switch --flake "$FLAKE_REF"; then
    echo ""
    echo -e "${GREEN}✓ Home Manager configuration applied successfully!${NC}"
    echo -e "${GREEN}✓ User environment has been updated${NC}"
else
    echo ""
    echo -e "${RED}✗ Home Manager configuration failed!${NC}"
    exit 1
fi
