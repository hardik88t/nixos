#!/usr/bin/env bash

# NixOS rebuild script with helpful options

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
HOSTNAME=$(hostname)
ACTION="switch"
FLAKE_PATH="."

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -a, --action ACTION Set rebuild action (switch, boot, test, build) [default: switch]"
    echo "  -H, --hostname HOST Set hostname [default: current hostname]"
    echo "  -f, --flake PATH    Set flake path [default: current directory]"
    echo "  -u, --update        Update flake inputs before rebuild"
    echo "  -c, --check         Check configuration without building"
    echo "  --impure            Use --impure flag (for first build)"
    echo ""
    echo "Examples:"
    echo "  $0                  # Basic rebuild"
    echo "  $0 -u               # Update and rebuild"
    echo "  $0 -a test          # Test configuration"
    echo "  $0 -H myhost        # Rebuild for specific hostname"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -a|--action)
            ACTION="$2"
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
        -u|--update)
            UPDATE_FLAKE=true
            shift
            ;;
        -c|--check)
            CHECK_ONLY=true
            shift
            ;;
        --impure)
            IMPURE_FLAG="--impure"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate action
case $ACTION in
    switch|boot|test|build)
        ;;
    *)
        echo -e "${RED}Error: Invalid action '$ACTION'. Must be one of: switch, boot, test, build${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}NixOS Rebuild Script${NC}"
echo -e "${BLUE}===================${NC}"
echo -e "Hostname: ${GREEN}$HOSTNAME${NC}"
echo -e "Action: ${GREEN}$ACTION${NC}"
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
    echo -e "${YELLOW}Checking configuration syntax...${NC}"
    nix flake check "$FLAKE_PATH"
    echo -e "${GREEN}Configuration check passed!${NC}"
    exit 0
fi

# Build the configuration
echo -e "${YELLOW}Building NixOS configuration...${NC}"
FLAKE_REF="$FLAKE_PATH#$HOSTNAME"

# Construct the command
CMD="sudo nixos-rebuild $ACTION --flake $FLAKE_REF"
if [[ -n "$IMPURE_FLAG" ]]; then
    CMD="$CMD $IMPURE_FLAG"
fi

echo -e "${BLUE}Running: $CMD${NC}"
echo ""

# Execute the rebuild
if eval "$CMD"; then
    echo ""
    echo -e "${GREEN}✓ NixOS rebuild completed successfully!${NC}"
    
    if [[ "$ACTION" == "switch" ]]; then
        echo -e "${GREEN}✓ System has been updated and is now active${NC}"
    elif [[ "$ACTION" == "boot" ]]; then
        echo -e "${YELLOW}⚠ System will use new configuration on next boot${NC}"
    elif [[ "$ACTION" == "test" ]]; then
        echo -e "${YELLOW}⚠ Configuration tested successfully (temporary)${NC}"
    fi
else
    echo ""
    echo -e "${RED}✗ NixOS rebuild failed!${NC}"
    exit 1
fi
