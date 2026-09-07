#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME:?HOME must be set}"
BIN_DIR="$HOME_DIR/bin"
CONFIG_DIR="$HOME_DIR/.config/xm-server"
TARGET="$BIN_DIR/welcome.sh"
CONFIG_FILE="$CONFIG_DIR/node.conf"
BASHRC="$HOME_DIR/.bashrc"

mkdir -p "$BIN_DIR" "$CONFIG_DIR"

if [ -L "$TARGET" ] && [ "$(readlink "$TARGET" 2>/dev/null || true)" = "$SCRIPT_DIR/bin/welcome.sh" ]; then
    printf 'welcome.sh link already points to this repository.\n'
elif [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    printf 'warning: %s already exists; leaving it unchanged.\n' "$TARGET" >&2
else
    ln -s "$SCRIPT_DIR/bin/welcome.sh" "$TARGET"
    printf 'linked %s -> %s\n' "$TARGET" "$SCRIPT_DIR/bin/welcome.sh"
fi

if [ -e "$CONFIG_FILE" ]; then
    printf 'config already exists: %s\n' "$CONFIG_FILE"
else
    cp "$SCRIPT_DIR/config/node.conf.example" "$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE"
    printf 'created config: %s\n' "$CONFIG_FILE"
fi

WELCOME_MARKER="# xm-server welcome"
if [ -f "$BASHRC" ] && grep -Fq 'welcome.sh' "$BASHRC"; then
    printf 'welcome call already present in %s\n' "$BASHRC"
else
    {
        printf '\n%s\n' "$WELCOME_MARKER"
        printf '"$HOME/bin/welcome.sh"\n'
    } >> "$BASHRC"
    printf 'added welcome call to %s\n' "$BASHRC"
fi

printf '\nInstallation complete.\n'
printf 'Edit: %s\n' "$CONFIG_FILE"
printf 'Then reconnect over SSH to test the welcome page.\n'
