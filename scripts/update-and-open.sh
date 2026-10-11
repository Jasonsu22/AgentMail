#!/bin/bash
# 把 AgentMail 的当前 bundle 发布到本地 OctoSense 商店，装进已有数据目录，并打开桌面。
# 用法：在任意目录执行本脚本。源码 bundle/ 保持未签名；签名只写在 build/ 里。
set -euo pipefail

APP="$(cd "$(dirname "$0")/.." && pwd -P)"
HACKATHON="$(cd "$APP/.." && pwd -P)"
ROOT="$HACKATHON/OctoSense"
HUB="$HACKATHON/OctoSense-App-Hub/target/release/hub"
OCTOSENSE_BIN="$ROOT/target/release/octosense"
# 状态目录放在 AgentMail 外面。OctosCode 的工作区如果包含桌面数据目录，内核会拒绝打开。
STORE="/Users/jason/Projects/Work/hackathon/.octosense-run"
WORKSPACE="$APP"
KEYS="$STORE/keys"
MIRROR="$STORE/mirror"
STAGED="$STORE/package/bundle"
APP_DATA="$STORE/desktop-apps"
HOME_DIR="$STORE/desktop-home"
PIDFILE="$STORE/octosense.pid"
LOG="$STORE/octosense.log"
PUBLISHER_ID="agentmail-local-test"

if [[ ! -x "$HUB" ]]; then
  echo "找不到 hub：$HUB" >&2
  exit 1
fi
if [[ ! -x "$OCTOSENSE_BIN" ]]; then
  echo "找不到 OctoSense：$OCTOSENSE_BIN" >&2
  exit 1
fi
if [[ ! -f "$KEYS/anchor.key" || ! -f "$KEYS/working.key" ]]; then
  echo "缺少本地演练密钥：$KEYS" >&2
  exit 1
fi

ANCHOR="$("$HUB" pubkey "$KEYS/anchor.key")"
PUB="$("$HUB" pubkey "$KEYS/working.key")"
COMMIT="$(git -C "$APP" rev-parse HEAD)"
REPO="https://github.com/Jasonsu22/AgentMail"

echo "准备应用包…"
rm -rf "$STAGED"
mkdir -p "$STAGED"
rsync -a --exclude '.DS_Store' "$APP/bundle/" "$STAGED/"

VERSION="$(python3 - "$STAGED/manifest.json" "$MIRROR/catalog.json" <<'PY'
import json, pathlib, sys
manifest_path = pathlib.Path(sys.argv[1])
catalog_path = pathlib.Path(sys.argv[2])
manifest = json.loads(manifest_path.read_text())
integrity = manifest.setdefault("integrity", {})
integrity.pop("signature", None)
catalog = json.loads(catalog_path.read_text()) if catalog_path.exists() else {"entries": []}
taken = []
for entry in catalog.get("entries", []):
    item = entry.get("manifest", {})
    if item.get("id") == manifest.get("id"):
        taken.append(item.get("version", "0.0.0"))

def parse(version):
    parts = version.split(".")
    while len(parts) < 3:
        parts.append("0")
    return tuple(int(part) for part in parts[:3])

current = manifest["version"]
if current in taken:
    base = max([parse(current), *[parse(version) for version in taken]])
    manifest["version"] = f"{base[0]}.{base[1]}.{base[2] + 1}"
manifest_path.write_text(json.dumps(manifest, indent=2) + "\n")
print(manifest["version"])
PY
)"
echo "发布版本 $VERSION"

"$HUB" stamp "$STAGED"
"$HUB" sign-manifest "$STAGED" --key "$KEYS/working.key" --key-id "$PUBLISHER_ID"
"$HUB" check "$STAGED" --publisher-key "$PUBLISHER_ID=$PUB" --catalog "$MIRROR/catalog.json" --anchor "$ANCHOR"

CERT="$("$HUB" certify --anchor "$KEYS/anchor.key" --working "$KEYS/working.key")"
"$HUB" publish "$STAGED" \
  --catalog "$MIRROR/catalog.json" \
  --anchor "$ANCHOR" \
  --key "$KEYS/working.key" \
  --anchor-cert "$CERT" \
  --publisher "$PUBLISHER_ID" \
  --publisher-key "$PUBLISHER_ID=$PUB" \
  --repo "$REPO" \
  --commit "$COMMIT" \
  --out "$MIRROR"
"$HUB" verify "$MIRROR/catalog.json" --anchor "$ANCHOR"

# The shell admits installed bundles against its verified local catalog cache,
# not directly against the publishing mirror. Refresh that cache atomically
# before restarting; otherwise the launcher can see the new bundle but reject
# it as "not in the verified catalog" until App Hub refreshes separately.
mkdir -p "$APP_DATA"
CATALOG_CACHE="$APP_DATA/catalog.json"
CATALOG_TMP="$APP_DATA/.catalog.json.$$.tmp"
cp "$MIRROR/catalog.json" "$CATALOG_TMP"
mv -f "$CATALOG_TMP" "$CATALOG_CACHE"
echo "已刷新本地验证目录到序列 $(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["sequence"])' "$CATALOG_CACHE")"

ART="$MIRROR/artifacts/agent-mail-$VERSION.bundle"
if [[ ! -f "$ART/manifest.json" ]]; then
  echo "发布产物不存在：$ART" >&2
  exit 1
fi
INSTALL="$APP_DATA/.bundles/agent-mail/bundle"
rm -rf "$INSTALL"
mkdir -p "$INSTALL"
rsync -a --exclude '.DS_Store' "$ART/" "$INSTALL/"
echo "已安装到 $INSTALL"

if [[ -f "$PIDFILE" ]]; then
  OLD="$(cat "$PIDFILE" || true)"
  if [[ -n "${OLD}" ]] && kill -0 "$OLD" 2>/dev/null; then
    echo "关闭正在运行的 OctoSense ($OLD)…"
    kill "$OLD" || true
    for _ in 1 2 3 4 5 6 7 8 9 10; do
      kill -0 "$OLD" 2>/dev/null || break
      sleep 0.3
    done
    if kill -0 "$OLD" 2>/dev/null; then
      kill -9 "$OLD" || true
    fi
  fi
fi

# 直接执行二进制时，macOS 会把日历请求算到父进程（Cursor）头上。
# Cursor 开了加固运行时但没有日历权限，系统会立刻拒绝、不弹窗。
# 所以放进 .app，签上日历权限，再用 Launch Services 打开。
APP_BUNDLE="$STORE/OctoSense.app"
MACOS_DIR="$APP_BUNDLE/Contents/MacOS"
ENTITLEMENTS="$STORE/octosense.entitlements"
mkdir -p "$MACOS_DIR"
if [[ ! -f "$MACOS_DIR/octosense" || "$OCTOSENSE_BIN" -nt "$MACOS_DIR/octosense" ]]; then
  cp -f "$OCTOSENSE_BIN" "$MACOS_DIR/octosense"
  chmod +x "$MACOS_DIR/octosense"
fi
cat > "$APP_BUNDLE/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>octosense</string>
    <key>CFBundleIdentifier</key>
    <string>com.octosense.desktop.local</string>
    <key>CFBundleName</key>
    <string>OctoSense</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>NSCalendarsUsageDescription</key>
    <string>OctoSense reads calendars you select and saves only the event changes you approve.</string>
    <key>NSCalendarsFullAccessUsageDescription</key>
    <string>Installed apps can read calendars you select. Each event change requires your review and approval.</string>
    <key>LSEnvironment</key>
    <dict>
        <key>OCTOSENSE_HUB_CATALOG</key>
        <string>legacy</string>
        <key>OCTOSENSE_HUB</key>
        <string>${MIRROR}</string>
        <key>OCTOSENSE_HUB_ANCHOR</key>
        <string>${ANCHOR}</string>
        <key>OCTOSENSE_HOME</key>
        <string>${HOME_DIR}</string>
        <key>OCTOSENSE_APP_DATA</key>
        <string>${APP_DATA}</string>
        <key>OCTOS_WORKSPACE_CWD</key>
        <string>${WORKSPACE}</string>
        <key>OCTOSENSE_MAIL_VAULT</key>
        <string>file</string>
    </dict>
</dict>
</plist>
PLIST
cat > "$ENTITLEMENTS" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.personal-information.calendars</key>
    <true/>
</dict>
</plist>
EOF
codesign --force --sign - --entitlements "$ENTITLEMENTS" "$APP_BUNDLE"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP_BUNDLE"

echo "打开 OctoSense…"
python3 - "$APP_BUNDLE" "$MACOS_DIR/octosense" "$PIDFILE" <<'PY'
import subprocess, sys, time
app, binary, pidfile = sys.argv[1:]
subprocess.run(["/usr/bin/open", "-n", app], check=True)
found = ""
for _ in range(40):
    listed = subprocess.run(["pgrep", "-x", "octosense"], capture_output=True, text=True)
    pids = [line for line in listed.stdout.split() if line]
    if pids:
        found = pids[-1]
        break
    time.sleep(0.25)
if not found:
    raise SystemExit("OctoSense 没有通过 Launch Services 启动")
open(pidfile, "w").write(found)
print(found)
PY
echo "OctoSense 已启动，pid $(cat "$PIDFILE")，日志 ${LOG}"
echo "在启动器里打开 AgentMail，版本 ${VERSION}。邮件账号仍在原来的本地数据目录里。"
echo "OctosCode 的工作区是 ${WORKSPACE}。请重新打开 OctosCode，不要点 Connect。"
