#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "Tutor — Setup"
echo ""

# ── VS Code ───────────────────────────────────────────────────────────────────

install_vscode_mac() {
  if command -v brew &> /dev/null; then
    brew install --cask visual-studio-code
  else
    echo "  Downloading VS Code for macOS..."
    TMP=$(mktemp -d)
    curl -sL "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal" -o "$TMP/vscode.zip"
    unzip -q "$TMP/vscode.zip" -d "$TMP"
    cp -r "$TMP/Visual Studio Code.app" /Applications/
    sudo ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code
    rm -rf "$TMP"
  fi
}

install_vscode_linux() {
  if command -v snap &> /dev/null; then
    sudo snap install code --classic
  elif command -v apt-get &> /dev/null; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/ms.gpg
    sudo install -D -o root -g root -m 644 /tmp/ms.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
      | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    sudo apt-get update -q && sudo apt-get install -y code
  elif command -v dnf &> /dev/null; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode
    sudo dnf install -y code
  else
    echo "  ❌  Cannot auto-install VS Code on this system."
    echo "     Download it from https://code.visualstudio.com, install, then re-run this script."
    exit 1
  fi
}

if command -v code &> /dev/null; then
  echo "  VS Code: $(code --version | head -1) ✓"
else
  echo "  VS Code not found. Installing..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    install_vscode_mac
  else
    install_vscode_linux
  fi

  if command -v code &> /dev/null; then
    echo "  VS Code installed ✓"
  else
    echo ""
    echo "  VS Code installed but 'code' command not on PATH."
    echo "  Open VS Code → Command Palette → 'Shell Command: Install code command in PATH'"
    echo "  Then re-run this script."
    exit 1
  fi
fi

# ── Node.js ───────────────────────────────────────────────────────────────────

install_node_mac() {
  if command -v brew &> /dev/null; then
    brew install node
  elif [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew install node
  else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 20 && nvm use 20
  fi
}

install_node_linux() {
  if command -v apt-get &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - > /dev/null 2>&1
    sudo apt-get install -y nodejs > /dev/null 2>&1
  elif command -v dnf &> /dev/null; then
    sudo dnf install -y nodejs > /dev/null 2>&1
  elif command -v snap &> /dev/null; then
    sudo snap install node --classic
  else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash > /dev/null 2>&1
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 20 && nvm use 20
  fi
}

if command -v node &> /dev/null; then
  echo "  Node.js: $(node --version) ✓"
else
  echo "  Node.js not found. Installing..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    install_node_mac
  else
    install_node_linux
  fi

  if command -v node &> /dev/null; then
    echo "  Node.js: $(node --version) ✓"
  else
    echo ""
    echo "  ❌  Could not install Node.js. Install from https://nodejs.org then re-run."
    exit 1
  fi
fi

# ── npm setup ─────────────────────────────────────────────────────────────────
echo ""
npm --prefix "$REPO_DIR" run setup

# ── Open VS Code ──────────────────────────────────────────────────────────────
echo ""
echo "  Opening VS Code..."
code "$REPO_DIR"
echo ""
echo "✅  Done. VS Code is opening the course folder."
echo ""
