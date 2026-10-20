#!/usr/bin/env bash
# ==============================================================================
#  mydots installer & restore script
# ==============================================================================
set -euo pipefail

DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
header()  { echo -e "\n${BOLD}${CYAN}=== $* ===${NC}\n"; }

usage() {
    cat <<EOF
Usage: ./install.sh [OPTIONS]

Options:
    --link        Create symbolic links from repository to target directories
    --copy        Copy files directly from repository to target directories
    --dry-run     Show what would be copied or linked without changing anything
    -h, --help    Show this help message

Default mode: Interactive prompt
EOF
    exit 0
}

MODE="ask"
DRY_RUN=false

for arg in "$@"; do
    case "$arg" in
        --link) MODE="link" ;;
        --copy) MODE="copy" ;;
        --dry-run) DRY_RUN=true ;;
        -h|--help) usage ;;
        *) echo "Unknown option: $arg"; usage ;;
    esac
done

header "mydots - Hyprland & Desktop Configuration Installer"

if [[ "$MODE" == "ask" && "$DRY_RUN" == false ]]; then
    echo "How would you like to install your dotfiles?"
    echo "  1) Symbolic links (changes in ~ reflect in repository)"
    echo "  2) Copy files (independent standalone copy)"
    read -rp "Select [1/2] (default: 1): " choice
    case "$choice" in
        2) MODE="copy" ;;
        *) MODE="link" ;;
    esac
fi

info "Selected method: ${MODE^^}"
if [[ "$DRY_RUN" == true ]]; then
    warn "Running in DRY-RUN mode. No changes will be written."
fi

# Function to deploy a file or directory
deploy_target() {
    local src="$1"
    local dest="$2"

    if [[ "$DRY_RUN" == true ]]; then
        info "[DRY-RUN] $src -> $dest"
        return 0
    fi

    # Backup if destination exists and is not already the right symlink
    if [[ -e "$dest" || -L "$dest" ]]; then
        if [[ "$MODE" == "link" && -L "$dest" && "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
            info "Already linked: $dest"
            return 0
        fi

        mkdir -p "$BACKUP_DIR"
        info "Backing up existing: $dest -> $BACKUP_DIR/"
        mv "$dest" "$BACKUP_DIR/"
    fi

    mkdir -p "$(dirname "$dest")"

    if [[ "$MODE" == "link" ]]; then
        ln -sf "$src" "$dest"
        success "Linked $dest -> $src"
    else
        cp -rL "$src" "$dest"
        success "Copied $src -> $dest"
    fi
}

header "Deploying .config applications"
for item in "$DOTS_DIR"/.config/*; do
    [ -e "$item" ] || continue
    name="$(basename "$item")"
    deploy_target "$item" "$HOME/.config/$name"
done

header "Deploying Home directory dotfiles"
for item in "$DOTS_DIR"/home/.*; do
    [ -e "$item" ] || continue
    name="$(basename "$item")"
    [[ "$name" == "." || "$name" == ".." ]] && continue
    deploy_target "$item" "$HOME/$name"
done

header "Deploying Caelestia state & sequences"
if [ -d "$DOTS_DIR/caelestia-state" ]; then
    mkdir -p "$HOME/.local/state/caelestia"
    for item in "$DOTS_DIR"/caelestia-state/*; do
        [ -e "$item" ] || continue
        name="$(basename "$item")"
        deploy_target "$item" "$HOME/.local/state/caelestia/$name"
    done
fi

header "Deploying Wallpapers"
if [ -d "$DOTS_DIR/wallpapers" ]; then
    mkdir -p "$HOME/Pictures/Wallpapers"
    for item in "$DOTS_DIR"/wallpapers/*; do
        [ -e "$item" ] || continue
        name="$(basename "$item")"
        deploy_target "$item" "$HOME/Pictures/Wallpapers/$name"
    done
fi

header "Installation Summary"
if [[ -d "$BACKUP_DIR" ]]; then
    warn "Previous configuration files backed up to: $BACKUP_DIR"
fi
success "Configuration deployment complete! Enjoy your rice."
