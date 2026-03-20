ANE AdMob iOS – SDK 13.x (Google-Mobile-Ads-SDK + UserMessagingPlatform only)

1. Xcode: AdMobANE target links Pods_AdMobANE.framework (CocoaPods).
2. platform.xml: packagedDependencies list GoogleMobileAds.framework and UserMessagingPlatform.framework.
3. When packaging the .ane, both iPhone-ARM and iPhone-x86 must contain the same files:
   - libAdMob.a, library.swf, platform.xml
   - GoogleMobileAds.framework, UserMessagingPlatform.framework

iPhone-ARM and iPhone-x86 are identical: arm64 device only.

Source of frameworks:
  - In ios/: run pod install.
  - In ios/: run ./update-ane-frameworks.sh
  - Copies from Pods (GoogleMobileAds.xcframework/ios-arm64, UserMessagingPlatform.xcframework/ios-arm64) into both ANE folders.

Frameworks do not go in the AIR SDK stub; they stay inside the ANE.
