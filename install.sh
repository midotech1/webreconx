#!/bin/bash
# WebReconX Installer Script - by ChatGPT

APP_NAME="webreconx"
SCRIPT_NAME="webreconx.sh"
CMD_NAME="webreconx"                                                                                      BIN_PATH="/usr/local/bin/$CMD_NAME"                                                                       DESKTOP_FILE="$HOME/.local/share/applications/webreconx.desktop"
ICON_NAME="utilities-terminal"  # You can change to a custom icon path if needed

echo "🔧 Starting $APP_NAME installation..."

# 1. Install dependencies
echo "📦 Checking and installing dependencies..."
DEPS=(curl whois dig nmap traceroute jq upnpc gnome-terminal)
for pkg in "${DEPS[@]}"; do                                                                                 if ! command -v "$pkg" &>/dev/null; then                                                                    echo "Installing: $pkg"                                                                                   sudo apt-get install -y "$pkg" >/dev/null 2>&1
    sudo apt-get install miniupnpc -y
  else
    echo "[✔] $pkg already installed"
  fi
done

# 2. Copy script to /usr/local/bin
if [[ ! -f "$SCRIPT_NAME" ]]; then
  echo "❌ Script $SCRIPT_NAME not found in current directory."
  exit 1
fi

echo "📂 Copying script to $BIN_PATH..."
sudo cp "$SCRIPT_NAME" "$BIN_PATH"
sudo chmod +x "$BIN_PATH"

# 3. Create .desktop launcher
echo "🖥️ Creating desktop launcher..."
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=$APP_NAME
Exec=gnome-terminal -- bash -c "sudo $CMD_NAME; exec bash"
Icon=$ICON_NAME
Type=Application
Terminal=false
Categories=Security;Network;
EOF

chmod +x "$DESKTOP_FILE"

# 4. Success message
echo -e "\n✅ $APP_NAME installed successfully!"
echo "👉 Run it anytime using: sudo $CMD_NAME"
echo "🎯 Or launch it from your Applications menu."
