#!/usr/bin/env bash

# Efficient wallpaper management script for pywal
# Caches wallpaper list to avoid repeated directory scanning

WALLPAPER_DIR="$HOME/Wallpapers"
CACHE_FILE="$HOME/.cache/wal/wallpaper_cache"
CACHE_DIR="$HOME/.cache/wal"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Function to generate wallpaper cache
generate_cache() {
    if [ -d "$WALLPAPER_DIR" ]; then
        find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.bmp' \) > "$CACHE_FILE"
        echo "Wallpaper cache updated with $(wc -l < "$CACHE_FILE") wallpapers"
    else
        echo "Warning: Wallpaper directory $WALLPAPER_DIR not found"
        exit 1
    fi
}

# Function to get random wallpaper from cache
get_random_wallpaper() {
    if [ ! -f "$CACHE_FILE" ] || [ ! -s "$CACHE_FILE" ]; then
        generate_cache
    fi
    
    # Check if cache is older than wallpaper directory
    if [ "$WALLPAPER_DIR" -nt "$CACHE_FILE" ]; then
        echo "Wallpaper directory updated, refreshing cache..."
        generate_cache
    fi
    
    # Get random wallpaper from cache
    if [ -s "$CACHE_FILE" ]; then
        shuf -n 1 "$CACHE_FILE"
    else
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi
}

# Function to set wallpaper with pywal
set_wallpaper() {
    local wallpaper="$1"
    if [ -f "$wallpaper" ]; then
        echo "Setting wallpaper: $(basename "$wallpaper")"
        wal -i "$wallpaper" >/dev/null 2>&1
        echo "Pywal theme applied successfully"
    else
        echo "Error: Wallpaper file not found: $wallpaper"
        exit 1
    fi
}

# Main execution
case "${1:-random}" in
    "cache")
        generate_cache
        ;;
    "random")
        wallpaper=$(get_random_wallpaper)
        set_wallpaper "$wallpaper"
        ;;
    "restore")
        echo "Restoring previous pywal theme..."
        wal -R >/dev/null 2>&1
        echo "Previous theme restored"
        ;;
    *)
        if [ -f "$1" ]; then
            set_wallpaper "$1"
        else
            echo "Usage: $0 [random|cache|restore|/path/to/wallpaper]"
            echo "  random  - Set random wallpaper (default)"
            echo "  cache   - Regenerate wallpaper cache"
            echo "  restore - Restore previous pywal theme"
            echo "  <path>  - Set specific wallpaper"
            exit 1
        fi
        ;;
esac
