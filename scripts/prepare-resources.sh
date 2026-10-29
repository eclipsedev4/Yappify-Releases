#!/bin/bash
set -euo pipefail
mkdir -p build/source
curl --fail --location --retry 2 'https://github.com/eclipsedev4/Yappify-Releases/releases/download/v2.14.1/Yappify-Share.zip' -o build/base.zip
echo '58b8052443495027e36be360077215a059106c5dec03faaed7868ff94f4e6522  build/base.zip' | shasum -a 256 -c -
unzip -q build/base.zip -d build/source
mkdir -p build/source/Yappify-iOS-App/Resources
cp Resources/mobile.css build/source/Yappify-iOS-App/Resources/
cp scripts/build-mobile-resources.cjs build/source/Yappify/build-ios.cjs
node build/source/Yappify/build-ios.cjs
cp build/source/Yappify-iOS-App/Resources/yappify-ios.js Resources/
cp build/source/Yappify/assets/yappify-icon-square.png Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png
