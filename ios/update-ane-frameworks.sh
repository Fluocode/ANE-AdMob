#!/bin/bash
# Copy Google Mobile Ads SDK 13.x frameworks from Pods into the ANE.
# iPhone-ARM and iPhone-x86 get the same content: arm64 device only.
#
# Usage:
#   1. cd ios && pod install
#   2. ./update-ane-frameworks.sh
#
# Run from the ios/ directory.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IOS_ROOT="$SCRIPT_DIR"
ANE_ROOT="$SCRIPT_DIR/../ANE"
PODS="$IOS_ROOT/Pods"

if [ ! -d "$PODS" ]; then
  echo "Error: $PODS not found. Run 'pod install' in ios/."
  exit 1
fi

copy_to() {
  local dest="$1"
  shift
  for f in "$@"; do
    if [ -e "$f" ]; then
      echo "  $(basename "$f") -> $dest/"
      rm -rf "$dest/$(basename "$f")"
      cp -R "$f" "$dest/"
    else
      echo "  WARNING: not found $f"
    fi
  done
}

echo "Updating ANE frameworks (arm64 only, same content for iPhone-ARM and iPhone-x86)..."

for DEST in "$ANE_ROOT/iPhone-ARM" "$ANE_ROOT/iPhone-x86"; do
  mkdir -p "$DEST"
  echo "  -> $DEST"

  copy_to "$DEST" \
    "$PODS/Google-Mobile-Ads-SDK/Frameworks/GoogleMobileAdsFramework/GoogleMobileAds.xcframework/ios-arm64/GoogleMobileAds.framework" \
    "$PODS/GoogleUserMessagingPlatform/Frameworks/Release/UserMessagingPlatform.xcframework/ios-arm64/UserMessagingPlatform.framework"
done

echo "Done. iPhone-ARM and iPhone-x86 are identical (arm64)."
