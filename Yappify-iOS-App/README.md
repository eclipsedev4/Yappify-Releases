# Yappify iOS development project

Unofficial. Not affiliated with or endorsed by Yapper. This is source code, not a signed IPA or a tested release.

The installed native SwiftUI app contains a WKWebView displaying Yapper and locally bundled Yappify customizations. It does not open Safari as its main UI. It is not a native rewrite of Yapper's chat service. Login remains on Yapper's HTTPS origin with WebKit session storage. No password collection, native credential bridge, analytics or remote plugin-code updates are added. Cloud badge auto-enrolment and theme submissions are disabled for this preview so Yapper session tokens are not sent to the Yappify service.

## Build on a Mac

1. Install Xcode and XcodeGen. The Windows workspace cannot compile or sign this app.
2. Run `xcodegen generate` in this folder, then open `YappifyMobile.xcodeproj`.
3. Select your own signing team and unique bundle identifier in Xcode.
4. Build in the simulator first, then test on a physical iPhone.
5. For distribution, join the Apple Developer Program and configure App Store Connect/TestFlight. Enable automatic updates in TestFlight on each tester's phone. Do not use desktop GitHub ZIPs as iOS app updates.

Bundled resources are generated from the companion Yappify source using `node build.cjs` followed by `node build-ios.cjs`. The resource build does not publish or install anything.

## Validation still required

Only browser fixtures at 320, 390 and 768px have passed so far. Native compilation, app icon validation, real login/MFA, external OAuth redirects, camera/microphone permissions, calls, media uploads/downloads, keyboard/safe-area behavior, accessibility and device performance are unverified. External login flows may need an approved callback integration. Desktop plugins are not all supported. Background calling and native push notifications are not implemented. App Store acceptance is not guaranteed for a web-based client; permission from the service and Apple's review requirements need checking before distribution.

Do not publish this as a finished iOS release yet. There is no signed IPA in this package.
