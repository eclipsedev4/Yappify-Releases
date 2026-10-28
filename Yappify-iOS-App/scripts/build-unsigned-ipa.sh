#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ "$(uname -s)" != Darwin ]]; then
  echo "An Apple macOS/Xcode build machine is required (GitHub Actions can provide it)." >&2
  exit 1
fi
xcodebuild -version
xcodegen generate --spec project.yml
mkdir -p build dist
xcodebuild -project YappifyMobile.xcodeproj -scheme YappifyMobile \
  -configuration Release -sdk iphoneos -destination 'generic/platform=iOS' \
  -derivedDataPath build/DerivedData \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY='' \
  build 2>&1 | tee build/xcodebuild.log
app='build/DerivedData/Build/Products/Release-iphoneos/Yappify.app'
test -d "$app"
test -s "$app/yappify-ios.js"
test -s "$app/Yappify"
/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$app/Info.plist"
/usr/bin/lipo -verify_arch arm64 "$app/Yappify"
# A unique package directory avoids mixing files from an earlier build.
stage=$(mktemp -d "${TMPDIR:-/tmp}/yappify-ipa.XXXXXX")
mkdir -p "$stage/Payload"
/usr/bin/ditto "$app" "$stage/Payload/Yappify.app"
/usr/bin/ditto -c -k --keepParent "$stage/Payload" dist/Yappify.ipa
(cd dist && shasum -a 256 Yappify.ipa > Yappify.ipa.sha256)
echo 'Created dist/Yappify.ipa — unsigned; sign with your own Apple ID before installing.'
