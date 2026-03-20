# AdMob ANE for Adobe AIR

A **native extension (ANE)** that lets **Adobe AIR** mobile apps show **Google AdMob** ads on **Android** and **iOS**. It exposes a small ActionScript 3 API for **banners**, **interstitials**, and **rewarded video**, plus global volume controls.

**Extension ID:** `com.fluocode.admob`  
**Package:** `com.fluocode.admob`

---

## What you need as an app developer

- An **AIR** project targeting **Android** and/or **iOS**.
- The packaged **`.ane`** (or your own build from this repo) added to your project and listed in the app descriptor.
- A **Google AdMob** account and your app’s **identifiers** (see [Credentials & AdMob setup](#credentials--admob-setup)).

This ANE does **not** replace your obligation to follow [Google’s AdMob policies](https://support.google.com/admob/answer/6128543) and applicable privacy laws (consent, children’s apps, etc.).

---

## Quick start

### 1. Add the extension to your app

Include the ANE in your build (IDE or `adt`) and reference it in **`application.xml`** (names may vary by tool):

```xml
<extensions>
  <extensionID>com.fluocode.admob</extensionID>
</extensions>
```

Add the **Android** and **iOS** manifest additions required by AdMob (App ID meta-data on Android, `GADApplicationIdentifier` on iOS, permissions, etc.). Your packaging tool or ANE `platform.xml` / merge rules should supply these—follow the latest [AdMob Android](https://developers.google.com/admob/android/quick-start) and [AdMob iOS](https://developers.google.com/admob/ios/quick-start) guides.

### 2. Import and initialize

```actionscript
import com.fluocode.admob.AdMob;
import com.fluocode.admob.AdMobEvents;
import com.fluocode.admob.AdRequest;

// Call once after you have a Stage (e.g. root added to stage)
var admob:AdMob = AdMob.init(stage, "ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY");
```

The second argument is your **AdMob App ID** (format `ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy`), **not** an ad unit id.

### 3. Listen for events on the API object

```actionscript
AdMob.api.addEventListener(AdMobEvents.AD_LOADED, onAdLoaded);
AdMob.api.addEventListener(AdMobEvents.AD_FAILED, onAdFailed);
AdMob.api.addEventListener(AdMobEvents.AD_CLOSED, onAdClosed);

function onAdLoaded(e:AdMobEvents):void {
  trace("Loaded:", e.adType);
}
function onAdFailed(e:AdMobEvents):void {
  trace("Failed:", e.adType, e.errorCode, e.msg);
}
function onAdClosed(e:AdMobEvents):void {
  trace("Closed:", e.adType);
}
```

### 4. Tear down when leaving the game / app section that uses ads

```actionscript
AdMob.dispose();
```

---

## API snippets (ActionScript 3)

### `AdMob` — singleton entry

| Purpose | Snippet |
|--------|---------|
| Initialize | `AdMob.init(stage, appIdOrEmptyString)` → `AdMob` |
| Access API | `AdMob.api` → `AdMobApi` or `null` if not initialized |
| Release | `AdMob.dispose()` |
| Constants | `AdMob.EXTENSION_ID`, `AdMob.VERSION`, `AdMob.AD_TYPE_BANNER`, `AdMob.AD_TYPE_INTERSTITIAL`, `AdMob.AD_TYPE_REWARDED_VIDEO` |
| Error codes (reference) | `AdMob.ERROR_CODE_INTERNAL_ERROR`, `ERROR_CODE_INVALID_REQUEST`, `ERROR_CODE_NETWORK_ERROR`, `ERROR_CODE_NO_FILL` |

```actionscript
// Example: read version label
trace(AdMob.VERSION);
```

---

### `AdMobApi` — banner, interstitial, rewarded, settings

```actionscript
var api:AdMobApi = AdMob.api;
api.banner;           // ApiBannerAds
api.interstitial;     // ApiInterstitialAds
api.rewardedVideo;    // ApiRewardedVideo
api.settings;         // Settings
```

---

### `ApiBannerAds` — banner

```actionscript
import com.fluocode.admob.ApiBannerAds;

var b:ApiBannerAds = AdMob.api.banner;

// Size presets: BANNER, FULL_BANNER, LARGE_BANNER, LEADERBOARD,
// MEDIUM_RECTANGLE, WIDE_SKYSCRAPER, SMART_BANNER_PORTRAIT / _LANDSCAPE, ADAPTIVE_BANNER
b.init("ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ", ApiBannerAds.ADAPTIVE_BANNER);

var req:AdRequest = new AdRequest();
b.loadAd(req);

b.setPosition(0, 0);
b.visible = true;

// Optional: listen for measured size on the banner object
b.addEventListener(AdMobEvents.SIZE_MEASURED, onBannerSize);

function onBannerSize(e:AdMobEvents):void {
  trace("Banner size:", e.width, e.height);
}

b.dispose();
```

---

### `ApiInterstitialAds` — full-screen interstitial

```actionscript
var i:ApiInterstitialAds = AdMob.api.interstitial;

i.init("ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ");
i.loadAd(new AdRequest());

if (i.isLoaded) {
  i.show();
}

i.dispose();
```

---

### `ApiRewardedVideo` — rewarded ad

```actionscript
var r:ApiRewardedVideo = AdMob.api.rewardedVideo;

r.addEventListener(AdMobEvents.AD_DELIVER_REWARD, onReward);

function onReward(e:AdMobEvents):void {
  trace("Reward:", e.rewardType, e.rewardAmount);
}

r.loadAd(new AdRequest(), "ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ");

if (r.isReady) {
  r.show();
}

// Optional server-side verification user id (if you use that flow)
r.userId = "player-123";

r.dispose();
```

---

### `AdRequest` — targeting (optional)

```actionscript
var req:AdRequest = new AdRequest();
req.keywords = ["games", "casual"];
req.tagForChildDirectedTreatment = true;
req.maxAdContentRating = AdRequest.MAX_AD_CONTENT_RATING_G;
req.tagForUnderAgeOfConsent = AdRequest.TAG_FOR_UNDER_AGE_OF_CONSENT_TRUE;
// req.testDevices = ["YOUR_DEVICE_HASH"]; // see AdMob docs for obtaining test device ids
```

Pass `req` into `banner.loadAd(req)`, `interstitial.loadAd(req)`, or `rewardedVideo.loadAd(req, unitId)`.

---

### `Settings` — app-wide ad audio

```actionscript
AdMob.api.settings.setAppMuted(true);
AdMob.api.settings.setAppVolume(0.5); // typical range 0.0–1.0; see platform SDK docs
```

---

### `AdMobEvents` — event `type` strings (for listeners)

Use these with `addEventListener`:

- `AdMobEvents.AD_LOADED`
- `AdMobEvents.AD_FAILED`
- `AdMobEvents.AD_CLOSED`
- `AdMobEvents.AD_OPENED`
- `AdMobEvents.AD_LEFT_APP`
- `AdMobEvents.SIZE_MEASURED` (banner)
- `AdMobEvents.AD_BEGIN_PLAYING` / `AD_END_PLAYING` / `AD_DELIVER_REWARD` / `METADATA_CHANGED` (rewarded / platform-dependent)

Useful fields on the event object: `adType`, `errorCode`, `msg`, `width`, `height`, `rewardType`, `rewardAmount`, `metadata`.

---

### `ApiNativeAdsExpress`

Placeholder for API compatibility; **no active native implementation** in this ANE. Safe to ignore unless you extend the project.

---

## Credentials & AdMob setup

AdMob does **not** use a single “API key” inside the app the way some REST APIs do. You configure **identifiers** in the [AdMob console](https://apps.admob.google.com/) and in your **app manifest / Info.plist / meta-data**.

### 1. AdMob App ID (required)

1. Open [AdMob](https://apps.admob.google.com/) → **Apps** → add your Android/iOS app (or link stores).
2. Copy the **App ID** — looks like:  
   `ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy`
3. Pass it to **`AdMob.init(stage, thatString)`**.
4. **Also** embed the same value in native config (required by Google):
   - **Android:** `AndroidManifest.xml` inside `<application>`:  
     `com.google.android.gms.ads.APPLICATION_ID` → your App ID string.
   - **iOS:** `Info.plist` / InfoAdditions: **`GADApplicationIdentifier`** → your App ID string.

If these are missing or wrong, ads may not load and the SDK may log errors.

### 2. Ad unit IDs (per placement)

For each **banner**, **interstitial**, or **rewarded** placement:

1. In AdMob → **Ad units** → create the unit type you need.
2. Copy the **Ad unit ID** — looks like:  
   `ca-app-pub-xxxxxxxxxxxxxxxx/zzzzzzzzzz`
3. Use it in **`init(...)`** (banner / interstitial) or **`loadAd(..., unitId)`** (rewarded).

### 3. Testing without policy risk

Google provides **sample ad unit IDs** for development (see [Android](https://developers.google.com/admob/android/test-ads) / [iOS](https://developers.google.com/admob/ios/test-ads) test ads documentation). Use them while developing; switch to your real units for production builds.

### 4. Optional: User Messaging Platform (UMP) / consent

For GDPR, ePrivacy, and similar requirements, you may need a **consent SDK** (e.g. Google’s UMP) **in addition** to this ANE. That is usually integrated at the **native app** or **packaging** level—plan compliance with your legal counsel and [Google’s guidance](https://support.google.com/admob/answer/10113005).

---

## Repository layout (for contributors)

| Path | Role |
|------|------|
| `actionscript/` | AS3 library (`com.fluocode.admob`) |
| `android/` | Gradle Android library → `classes.jar` |
| `ios/` | Xcode / static library → `libAdMob.a` |
| `extension.xml` | ANE descriptor |

---

## License

See project license file if present; copyright notice appears in `extension.xml`.

---

**fluocode.com** — AdMob ANE for AIR

***
If You like what I make please donate:
[![Foo](https://www.paypalobjects.com/en_GB/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=4QBWVDKEVRL46)
***