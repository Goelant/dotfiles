#!/bin/bash
TITLE_FILE="/tmp/quickshell_window_title"
hyprctl activewindow -j | jq -r '.title // "Desktop"' > "$TITLE_FILE"
