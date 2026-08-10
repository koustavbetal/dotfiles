#!/usr/bin/env bash
# capture-inventory.sh
# Run from inside your dotfiles repo dir. Regenerates manifests of ONLY
# what you actually chose to install (filters out OS-install baseline
# and dependency/base packages).
set -uo pipefail

OUT="${1:-.}"
cd "$OUT" || exit 1
echo "Writing inventory files to: $(pwd)"

# --- APT: diff manual-installed against the installer's day-1 baseline,
# so ubuntu-desktop/language-pack metapackages don't pollute the list.
apt-mark showmanual | sort > /tmp/apt_manual_now.list
if [ -f /var/log/installer/initial-status.gz ]; then
  zcat /var/log/installer/initial-status.gz | awk '/^Package: /{print $2}' | sort > /tmp/apt_baseline.list
  comm -23 /tmp/apt_manual_now.list /tmp/apt_baseline.list > installed_apt.list
else
  # baseline log missing (e.g. not a fresh-installed system) -- fall back to raw list
  cp /tmp/apt_manual_now.list installed_apt.list
  echo "  [!] no installer baseline found, installed_apt.list may include OS defaults - review manually"
fi

# --- Flatpak (--app already excludes runtimes/deps, this list is clean as-is)
if command -v flatpak &>/dev/null; then
  flatpak list --app --columns=application | sort > installed_flatpaks.list
fi

# --- Snap: keep full rows (name + notes) so confinement (classic)
# survives, and filter out base/runtime/preinstalled snaps.
if command -v snap &>/dev/null; then
  BASE_SNAP_PATTERN='^(core|core1[0-9]|core2[0-9]|bare|snapd|gtk-common-themes|gnome-[0-9]+-|snap-store)'
  snap list | tail -n +2 | awk '{print $1","$3}' | grep -vE "$BASE_SNAP_PATTERN" > snaps_raw.csv
  # snaps_raw.csv format: name,notes   (notes contains "classic" when relevant)
fi

# --- VS Code extensions
if command -v code &>/dev/null; then
  code --list-extensions | sort > code-extensions.list
fi

# --- npm globals
if command -v npm &>/dev/null; then
  npm list -g --depth=0 --json 2>/dev/null | \
    python3 -c "import json,sys; d=json.load(sys.stdin); print('\n'.join(sorted(d.get('dependencies',{}).keys())))" \
    > npm_global.list
fi

# --- cargo (rust)
if command -v cargo &>/dev/null; then
  cargo install --list | grep -E '^\S' | sed 's/ .*//' > cargo.list
fi

# --- pipx / uv global tools
if command -v pipx &>/dev/null; then
  pipx list --short | awk '{print $1}' > pipx.list
fi
if command -v uv &>/dev/null; then
  uv tool list 2>/dev/null | grep -v '^$' > uv_tools.list
fi

# --- PlatformIO
if command -v pio &>/dev/null; then
  pio pkg list -g > platformio_global.list 2>/dev/null
fi

# --- GNOME/dconf + shell extensions
if command -v dconf &>/dev/null; then
  dconf dump / > dconf-settings.ini
fi
if command -v gnome-extensions &>/dev/null; then
  gnome-extensions list --enabled > gnome-extensions.list 2>/dev/null
fi

# --- systemd enabled units
systemctl list-unit-files --state=enabled --no-legend | awk '{print $1}' | sort > systemd_enabled_system.list
systemctl --user list-unit-files --state=enabled --no-legend 2>/dev/null | awk '{print $1}' | sort > systemd_enabled_user.list

# --- crontab
crontab -l 2>/dev/null > crontab.list || echo "# no user crontab" > crontab.list

# --- ROS2 apt packages actually installed
if command -v ros2 &>/dev/null; then
  apt list --installed 2>/dev/null | grep -i '^ros-' | sed 's/\/.*//' | sort > ros2_apt_packages.list
fi

# --- udev rules (outside $HOME, stow can't reach these)
if [ -d /etc/udev/rules.d ]; then
  mkdir -p system-etc/udev-rules
  find /etc/udev/rules.d -maxdepth 1 -name '*.rules' -exec grep -l -E 'ttyUSB|ttyACM|idVendor' {} \; 2>/dev/null | \
    xargs -I{} cp {} system-etc/udev-rules/ 2>/dev/null
fi

# --- Group memberships (dialout/plugdev matter for ESP32/Roboteq serial access,
# docker group if you use containers). This is a manifest line, not a stowed file.
groups "$USER" | sed "s/^${USER} : //" | tr ' ' '\n' | sort > groups.list

echo "Done. Review with: git status / git diff"
echo "NOTE: installed_apt.list and snaps_raw.csv are auto-filtered but not perfect -- skim them once."
echo ""
echo "REMINDER (not automated -- these are real files, stow them manually into matching paths):"
echo "  ~/.config/gtk-3.0/settings.ini"
echo "  ~/.config/gtk-4.0/settings.ini"
echo "  ~/.config/autostart/*.desktop"
echo "  ~/.local/share/applications/*.desktop"
echo "  ~/.config/user-dirs.dirs"