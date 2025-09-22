#!/usr/bin/env bash
set -Eeuo pipefail

# Interactive if <3 args, CLI-compatible:
# make-webapp.sh "App Name" "https://site" "ICON.png|ICON_URL" [custom-exec] [mime/types]

# Helpers
has() { command -v "$1" >/dev/null 2>&1; }

APP_NAME="${1:-}"
APP_URL="${2:-}"
ICON_REF="${3:-}"
CUSTOM_EXEC="${4:-}"
MIME_TYPES="${5:-}"
INTERACTIVE=true

if [[ $# -ge 3 ]]; then
  INTERACTIVE=false
fi

if $INTERACTIVE; then
  if has gum; then
    echo -e "\e[32mLet's craft a tidy web app launcher.\e[0m"
    APP_NAME="$(gum input --prompt "Name> " --placeholder "ChatGPT")"
    APP_URL="$(gum input --prompt "URL> " --placeholder "https://chatgpt.com")"
    ICON_REF="$(gum input --prompt "Icon URL or file> " --placeholder "PNG path or https://...")"
  else
    read -rp "Name> " APP_NAME
    read -rp "URL> " APP_URL
    read -rp "Icon URL or file (PNG)> " ICON_REF
  fi
fi

if [[ -z "$APP_NAME" || -z "$APP_URL" || -z "$ICON_REF" ]]; then
  echo "You must set app name, app URL, and icon reference!" >&2
  exit 1
fi

# Normalize URL
if ! [[ "$APP_URL" =~ ^https?:// ]]; then
  APP_URL="https://${APP_URL}"
fi

# Slug for filenames / profile
SLUG="$(printf "%s" "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9._-' '-')"
[[ -z "$SLUG" ]] && SLUG="webapp"

# Icon handling
ICON_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/icons"
mkdir -p "$ICON_DIR"
ICON_PATH="$ICON_DIR/${SLUG}.png"

if [[ "$ICON_REF" =~ ^https?:// ]]; then
  if has curl; then
    curl -fsSL -o "$ICON_PATH" "$ICON_REF" || {
      echo "Icon download failed."
      exit 1
    }
  else
    echo "curl not found; provide a local PNG path for icon." >&2
    exit 1
  fi
else
  # local file (copy so uninstall is easy)
  if [[ ! -f "$ICON_REF" ]]; then
    echo "Icon file not found: $ICON_REF" >&2
    exit 1
  fi
  cp -f "$ICON_REF" "$ICON_PATH"
fi

# Desktop file
APPS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
mkdir -p "$APPS_DIR"
DESKTOP_FILE="${APPS_DIR}/${SLUG}.desktop"

# Stable WM_CLASS for grouping/pinning
WM_CLASS="$(printf "%s" "$APP_NAME" | tr -cd 'A-Za-z0-9')"
[[ -z "$WM_CLASS" ]] && WM_CLASS="WebApp"

# Exec line: either custom or Chromium with isolated profile
if [[ -n "$CUSTOM_EXEC" ]]; then
  EXEC_LINE="$CUSTOM_EXEC"
else
  # Use an isolated profile for the web app
  PROFILE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/chromium-${SLUG}"
  mkdir -p "$PROFILE_DIR"
  EXEC_LINE="chromium-browser --user-data-dir=${PROFILE_DIR@Q} --app=${APP_URL@Q} --class=$WM_CLASS"
fi

# Check for browser
if ! has chromium-browser; then
  echo "Chromium not found. Install it or update the EXEC_LINE to use your browser." >&2
  exit 1
fi

cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Comment=$APP_NAME
Exec=$EXEC_LINE
Terminal=false
Icon=$ICON_PATH
StartupNotify=true
Categories=Network;Utility;
StartupWMClass=$WM_CLASS
EOF

if [[ -n "$MIME_TYPES" ]]; then
  echo "MimeType=$MIME_TYPES" >>"$DESKTOP_FILE"
fi

chmod +x "$DESKTOP_FILE"

# Refresh desktop DB quietly if available
if has update-desktop-database; then
  update-desktop-database "${APPS_DIR}" >/dev/null 2>&1 || true
fi

if $INTERACTIVE; then
  echo -e "Created: $DESKTOP_FILE"
  echo -e "Launcher should appear in your app menu. Pin it from the dock as needed.\n"
fi

