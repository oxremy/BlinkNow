# BlinkNow

## Deployment

1. Create developer ID certificate
2. Configure Xcode signing:
   - Team: Your Apple Developer Team
   - Signing Certificate: Developer ID Application
3. Build archive:
   ```bash
   xcodebuild archive -scheme BlinkNow -archivePath BlinkNow.xcarchive
   ```
4. Notarize:
   ```bash
   xcrun notarytool submit BlinkNow.app.zip --keychain-profile "AC_PASSWORD"
   ```
5. Create DMG:
   ```bash
   hdiutil create -volname "BlinkNow" -srcfolder Build/Products/Release/BlinkNow.app -ov -format UDZO BlinkNow.dmg
   ```