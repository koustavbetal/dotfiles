#!/usr/bin/env bash
# restore-inventory.sh
# Run on a FRESH Ubuntu 24.04 install, from inside your cloned dotfiles repo,
# AFTER `stow .` has symlinked your configs.
set -uo pipefail

echo "=== 1. APT packages ==="
if [ -f installed_apt.list ]; then
  sudo apt update
  xargs -a installed_apt.list sudo apt install -y
fi

echo "=== 2. Flatpak (needs flathub remote added first) ==="
if [ -f installed_flatpaks.list ] && command -v flatpak &>/dev/null; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  xargs -a installed_flatpaks.list -L1 flatpak install -y flathub
fi

echo "=== 3. Snap (reads name,notes CSV so classic confinement is preserved) ==="
if [ -f snaps_raw.csv ] && command -v snap &>/dev/null; then
  while IFS=',' read -r name notes; do
    if [[ "$notes" == *classic* ]]; then
      sudo snap install "$name" --classic
    else
      sudo snap install "$name"
    fi
  done < snaps_raw.csv
fi

echo "=== 4. VS Code extensions ==="
if [ -f code-extensions.list ] && command -v code &>/dev/null; then
  xargs -a code-extensions.list -L1 code --install-extension
fi

echo "=== 5. npm globals ==="
if [ -f npm_global.list ] && command -v npm &>/dev/null; then
  xargs -a npm_global.list npm install -g
fi

echo "=== 6. cargo ==="
if [ -f cargo.list ] && command -v cargo &>/dev/null; then
  xargs -a cargo.list -L1 cargo install
fi

echo "=== 7. pipx / uv tools ==="
if [ -f pipx.list ] && command -v pipx &>/dev/null; then
  xargs -a pipx.list -L1 pipx install
fi
if [ -f uv_tools.list ] && command -v uv &>/dev/null; then
  awk '{print $1}' uv_tools.list | xargs -L1 uv tool install
fi

echo "=== 8. dconf settings ==="
if [ -f dconf-settings.ini ] && command -v dconf &>/dev/null; then
  dconf load / < dconf-settings.ini
fi

echo "=== 9. GNOME extensions (install step is manual -- gnome-extensions can only enable/disable,"
echo "    not install from the store. Cross-check gnome-extensions.list against extensions.gnome.org) ==="

echo "=== 10. udev rules (needs sudo, review before copying -- device paths can differ) ==="
if [ -d system-etc/udev-rules ]; then
  echo "  Files ready in system-etc/udev-rules/. Run manually:"
  echo "  sudo cp system-etc/udev-rules/*.rules /etc/udev/rules.d/ && sudo udevadm control --reload-rules"
fi

echo "=== 11. ROS2 packages ==="
if [ -f ros2_apt_packages.list ]; then
  xargs -a ros2_apt_packages.list sudo apt install -y
fi
echo "  For your actual ROS2 workspaces (servera_orchestrator etc.), clone the workspace repos"
echo "  separately and run: rosdep install --from-paths src --ignore-src -y"

echo "=== 12. crontab ==="
if [ -f crontab.list ]; then
  crontab crontab.list
fi

echo "=== 13. Group memberships (needed for serial device access -- dialout/plugdev) ==="
if [ -f groups.list ]; then
  for g in $(cat groups.list); do
    sudo usermod -aG "$g" "$USER" 2>/dev/null
  done
  echo "  Log out and back in for new group membership to take effect."
fi

echo ""
echo "Done. Things this script CANNOT restore automatically:"
echo "  - Zen/Firefox extensions & bookmarks -> sign into your sync account instead"
echo "  - SSH/GPG keys -> restore from your separate encrypted vault, not this repo"
echo "  - LLM model weights (GGUF files) -> re-download per your model-notes file"
echo "  - PlatformIO board packages -> run 'pio pkg install' inside each project, or"
echo "    'pio pkg install -g -p <platform>' per line in platformio_global.list"