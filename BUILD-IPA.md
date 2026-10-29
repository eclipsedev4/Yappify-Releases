# Build Yappify.ipa without owning a Mac

This project builds an unsigned iPhone/iPad app using GitHub Actions. It does not require an Apple ID, certificate, password or signing secret in GitHub. Users sign the IPA on their own devices/computers after downloading it.

1. Create a GitHub repository for the iOS app, such as Yappify-iOS.
2. Extract this ZIP and upload the CONTENTS of Yappify-iOS-App to the repository root. Include the hidden `.github` folder. Do not upload only the ZIP to Releases: GitHub needs the source files and workflow in the repository.
3. Open Actions → Build unsigned iOS IPA → Run workflow.
4. Once the build succeeds, open that run and download the Yappify-iOS-unsigned artifact.
5. Extract the artifact ZIP. It contains Yappify.ipa and its SHA-256 file.
6. Sign and install the IPA using your own Apple ID with a trusted sideloading tool. Do not send signing credentials to us or put them in GitHub.

This setup has NOT yet been run on a Mac. If the build fails, inspect the iOS-build-log artifact and fix the error before distributing an IPA. An IPA only exists after the build succeeds; the source ZIP is not installable.

This is an early unofficial Yappify app, not Chatter. Login uses the Yapper page inside the app. Screen-sharing extensions and push notifications are not implemented. No claim is made that it has feature parity with Chatter. Native login, voice, file upload and real-device behavior still need testing.

Unsigned distribution does not automatically update installed apps. New versions need to be built and re-signed/reinstalled. A future TestFlight/App Store distribution can use Apple's update mechanism.

Use GitHub's standard macOS runner. Repository visibility and your account's Actions plan determine quota/billing; do not enable paid usage solely for this setup without checking your account.
