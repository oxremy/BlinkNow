#!/bin/bash

# Xcode Cloud notarization script
xcrun notarytool submit "$1" \
  --keychain-profile "AC_PASSWORD" \
  --wait

xcrun stapler staple "$1" 