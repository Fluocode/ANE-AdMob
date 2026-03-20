package com.myflashlab.admob;

import android.app.Activity;
import android.content.Context;
import android.graphics.Point;
import android.location.Location;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.google.ads.mediation.admob.AdMobAdapter;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import com.google.android.gms.ads.admanager.AdManagerAdView;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAd;
import com.google.android.gms.ads.interstitial.InterstitialAd;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;
import com.myflashlab.Conversions;
import com.myflashlab.dependency.overrideAir.MyExtension;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

public class AirCommand implements FREFunction {
  private int _preDrawCount = 0;
  
  private boolean isDialogCalled = false;
  
  private boolean isDialogClicked = false;
  
  private boolean _useDoubleClickApi = false;
  
  private boolean _isMobileAdsSDKInitialized = false;
  
  private Activity _activity;
  
  private FrameLayout _frameLayout;
  
  private RelativeLayout.LayoutParams _relativeLayoutParams;
  
  private FrameLayout.LayoutParams _lp_admob;
  
  private AdView _banner;
  
  //private PublisherAdView _bannerDoubleClick;
  private AdManagerAdView _bannerDoubleClick;

  private InterstitialAd _interstitial;
  
  private AdManagerInterstitialAd _interstitialDoubleClick;
  
  private RewardedAd _rewardedVideoAd;
  
  private int finalWidth;
  
  private int finalHeight;
  
  private enum commands {
    isTestVersion, getNativeDimension, test, initialize, initBanner, disposeBanner, isBannerLoading, loadBanner, hideBanner, setPosition, initInterstitial, disposeInterstitial, isInterstitialLoading, isInterstitialLoaded, loadInterstitial, showInterstitial, loadRewardedVideo, isRewardedVideoReady, showRewardedVideo, rewardedVideoGetUserId, rewardedVideoSetUserId, disposeRewardedVideo, MobileAdsSetAppMuted, MobileAdsSetAppVolume, MobileAdsOpenDebugMenu;
  }
  

/*
// https://developers.google.com/admob/android/migration?hl=es-419
// https://developers.google.com/admob/android/rewarded?hl=es-419
// https://developers.google.com/admob/ios/quick-start?hl=es-419

// Everyone (Families)
// https://support.google.com/admob/answer/6223431?hl=en#code&zippy=%2Ccode-sample-for-implementation-in-apps-for-everyone-including-children-and-families


Use the following code sample to invoke setMax_ad_content_rating() and setTagForChildDirectedTreatment() to send child-directed ad requests in a mixed-audience app:
        RequestConfiguration requestConfiguration = MobileAds.getRequestConfiguration()
        .toBuilder()
        .setTagForChildDirectedTreatment(
        RequestConfiguration.TAG_FOR_CHILD_DIRECTED_TREATMENT_TRUE)
        .setMaxAdContentRating(RequestConfiguration.MAX_AD_CONTENT_RATING_G)
        .build();
        MobileAds.setRequestConfiguration(requestConfiguration);


Aplicación abierta 	ca-app-pub-3940256099942544/9257395921
Banner adaptable 	ca-app-pub-3940256099942544/9214589741
Banner 	ca-app-pub-3940256099942544/6300978111
Intersticial 	ca-app-pub-3940256099942544/1033173712
Video intersticial 	ca-app-pub-3940256099942544/8691691433
Recompensado 	ca-app-pub-3940256099942544/5224354917
Anuncio intersticial recompensado 	ca-app-pub-3940256099942544/5354046379
Nativo avanzado 	ca-app-pub-3940256099942544/2247696110
Video nativo avanzado 	ca-app-pub-3940256099942544/1044960115



iOS
App Open 	ca-app-pub-3940256099942544/5575463023
Adaptive Banner 	ca-app-pub-3940256099942544/2435281174
Banner 	ca-app-pub-3940256099942544/2934735716
Interstitial 	ca-app-pub-3940256099942544/4411468910
Interstitial Video 	ca-app-pub-3940256099942544/5135589807
Rewarded 	ca-app-pub-3940256099942544/1712485313
Rewarded Interstitial 	ca-app-pub-3940256099942544/6978759866
Native Advanced 	ca-app-pub-3940256099942544/3986624511
Native Advanced Video 	ca-app-pub-3940256099942544/2521693316
*/

  
  public FREObject call(FREContext $context, FREObject[] $params) {
    Point size, realSize;
    String command = Conversions.AirToJava_String($params[0]);
    FREObject result = null;
    if (this._activity == null)
      this._activity = $context.getActivity(); 
    toTrace("command: " + command);
    switch (commands.valueOf(command)) {
      case getNativeDimension:
        size = new Point();
        realSize = new Point();
        this._activity.getWindowManager().getDefaultDisplay().getSize(size);
        this._activity.getWindowManager().getDefaultDisplay().getRealSize(realSize);
        toTrace("Native visible Dimension: " + size.x + "x" + size.y + "\nNative Real Dimension: " + realSize.x + "x" + realSize.y);
        result = Conversions.JavaToAir_String(size.x + "|||" + size.y + "|||" + realSize.x + "|||" + realSize.y);
        break;
      case initialize:
        initialize(Conversions.AirToJava_String($params[1]));
        break;
      case initBanner:
        initBanner(Conversions.AirToJava_String($params[1]), 
            Conversions.AirToJava_Integer($params[2]).intValue());

        break;
      case disposeBanner:
        disposeBanner();
        break;
      case isBannerLoading:
        result = Conversions.JavaToAir_Boolean(Boolean.valueOf(isBannerLoading()));
        break;
      case loadBanner:
        if (this._useDoubleClickApi) {
          loadBannerDoubleClick(convertJsonToDoubleClickRequest(Conversions.AirToJava_String($params[1])));
          break;
        } 
        loadBanner(convertJsonToRequest(Conversions.AirToJava_String($params[1])));
        break;
      case hideBanner:
        if (this._useDoubleClickApi) {
          hideView((View)this._bannerDoubleClick, Conversions.AirToJava_Boolean($params[1]).booleanValue());
          break;
        } 
        hideView((View)this._banner, Conversions.AirToJava_Boolean($params[1]).booleanValue());
        break;
      case setPosition:
        setPosition(Conversions.AirToJava_Double($params[1]), Conversions.AirToJava_Double($params[2]));
        break;
      case initInterstitial:
        initInterstitial(Conversions.AirToJava_String($params[1]));
        break;
      case disposeInterstitial:
        disposeInterstitial();
        break;
      case isInterstitialLoading:
        result = Conversions.JavaToAir_Boolean(Boolean.valueOf(isInterstitialLoading()));
        break;
      case isInterstitialLoaded:
        result = Conversions.JavaToAir_Boolean(Boolean.valueOf(isInterstitialLoaded()));
        break;
      case loadInterstitial:
        if (this._useDoubleClickApi) {
          loadInterstitialDoubleClick(convertJsonToDoubleClickRequest(Conversions.AirToJava_String($params[1])));

          break;
        } 
        loadInterstitial(convertJsonToRequest(Conversions.AirToJava_String($params[1])));
        break;
      case showInterstitial:
        if (this._useDoubleClickApi) {
          //this._interstitialDoubleClick.show();
          this._interstitialDoubleClick.show(this._activity);
          break;
        } 
        this._interstitial.show(this._activity);
        break;
      case loadRewardedVideo:
        if (this._useDoubleClickApi) {
          loadDoubleClickRewardedVideo(
              convertJsonToDoubleClickRequest(Conversions.AirToJava_String($params[1])), 
              Conversions.AirToJava_String($params[2]));
          break;
        } 
        loadRewardedVideo(
            convertJsonToRequest(Conversions.AirToJava_String($params[1])), 
            Conversions.AirToJava_String($params[2]));
        break;
      case isRewardedVideoReady:
        toTrace("isRewardedVideoReady... BEGIN");
        if (this._rewardedVideoAd == null)
          initRewardedVideo();
      result = Conversions.JavaToAir_Boolean(Boolean.valueOf(this._rewardedVideoAd.isLoaded()));
        toTrace("isRewardedVideoReady... END");
        break;
      case showRewardedVideo:
        toTrace("showRewardedVideo... BEGIN");
        this._rewardedVideoAd.show(this._activity);  // need a Callback
        toTrace("showRewardedVideo... END");
        break;
      case rewardedVideoGetUserId:
        result = Conversions.JavaToAir_String(rewardedVideoGetUserId());
        break;
      case rewardedVideoSetUserId:
        rewardedVideoSetUserId(Conversions.AirToJava_String($params[1]));
        break;
      case disposeRewardedVideo:
        disposeRewardedVideo();
        break;
      case MobileAdsSetAppMuted:
        MobileAds.setAppMuted(Conversions.AirToJava_Boolean($params[1]).booleanValue());
        break;
      case MobileAdsSetAppVolume:
        MobileAds.setAppVolume((float)Conversions.AirToJava_Double($params[1]));
        break;
      case MobileAdsOpenDebugMenu:
        MobileAds.openDebugMenu(this._activity.getApplicationContext(), Conversions.AirToJava_String($params[1]));
        break;
    } 
    return result;
  }
  
  private void initialize(String $applicationCode) {
    if (!this._isMobileAdsSDKInitialized) {
      toTrace("initialize started...");
      if ($applicationCode.length() > 0) {
        MobileAds.initialize(this._activity.getApplicationContext(), $applicationCode);
      } else {
        this._useDoubleClickApi = true;
      } 
      this._isMobileAdsSDKInitialized = true;
      toTrace("_useDoubleClickApi: " + this._useDoubleClickApi);
      toTrace("initialize finished");
    } 
    toTrace("setting layers started...");
    this._frameLayout = new FrameLayout(this._activity.getApplicationContext());
    this._frameLayout.setClickable(false);
    this._relativeLayoutParams = new RelativeLayout.LayoutParams(-2, -2);
    this._relativeLayoutParams.addRule(12);
    this._lp_admob = new FrameLayout.LayoutParams(-1, -1);
    this._lp_admob.gravity = 8388659;
    this._lp_admob.setMargins(0, 0, 0, 0);
    this._activity.addContentView((View)this._frameLayout, (ViewGroup.LayoutParams)this._lp_admob);
    toTrace("setting layers finished");
  }
  
  private void hideView(View $target, boolean $value) {
    if ($value) {
      $target.setVisibility(4);
    } else {
      $target.setVisibility(0);
    } 
  }

  private void setPosition(double $x, double $y) {
    toTrace("setPosition x = " + $x + " y = " + $y);
    this._lp_admob.gravity = 8388659;
    this._lp_admob.setMargins((int)$x, (int)$y, 0, 0);
    this._frameLayout.setLayoutParams((ViewGroup.LayoutParams)this._lp_admob);
  }
  
  private Location makeLocation(double $lat, double $lng) {
    if ($lat < 0.0D || $lng < 0.0D)
      return null; 
    Location loc = new Location("");
    loc.setLatitude($lat);
    loc.setLongitude($lng);
    return loc;
  }
  
  private void initRewardedVideo() {
    toTrace("initRewardedVideo... BEGIN");
    try {
      //this._rewardedVideoAd = MobileAds.getRewardedVideoAdInstance((Context)this._activity);

      //this._rewardedVideoAd.

      ///////////////////// MY


      AdRequest adRequest = new AdRequest.Builder().build();
      RewardedAd.load(this._activity, "ca-app-pub-3940256099942544/5224354917",
      adRequest, new RewardedAdLoadCallback() {
        @Override
        public void onAdFailedToLoad( LoadAdError loadAdError) {
          // Handle the error.
          //Log.d(TAG, loadAdError.toString());
          _rewardedVideoAd = null;
        }

        @Override
        public void onAdLoaded( RewardedAd ad) {
          _rewardedVideoAd = ad;
          //Log.d(TAG, "Ad was loaded.");
        }
      });



      /////////////////////////






    //  this._rewardedVideoAd.setRewardedVideoAdListener(new MyRewardListener(ExConsts.AD_TYPE_REWARDED_VIDEO));

    } catch (Exception e) {
      toTrace(e.getMessage());
    } 
    toTrace("initRewardedVideo... END");
  }
  
  private void disposeRewardedVideo() {
    toTrace("disposeRewardedVideo... BEGIN");
    if (this._rewardedVideoAd != null) {
      this._rewardedVideoAd.setRewardedVideoAdListener(null);
      this._rewardedVideoAd.setAdMetadataListener(null);
      this._rewardedVideoAd.destroy((Context)this._activity);
      this._rewardedVideoAd = null;
    } 
    toTrace("disposeRewardedVideo... END");
  }
  
  private String rewardedVideoGetUserId() {
    toTrace("rewardedVideoGetUserId... BEGIN");
    if (this._rewardedVideoAd == null)
      initRewardedVideo(); 
    toTrace("rewardedVideoGetUserId: " + this._rewardedVideoAd.getUserId());
    toTrace("rewardedVideoGetUserId... END");
    if (this._rewardedVideoAd.getUserId() == null)
      return ""; 
    return this._rewardedVideoAd.getUserId();
  }
  
  private void rewardedVideoSetUserId(String $id) {
    if ($id.length() < 1)
      return; 
    if (this._rewardedVideoAd == null)
      initRewardedVideo();
    this._rewardedVideoAd.setUserId($id);
  }
  
  private void loadRewardedVideo(AdRequest $request, String $unitId) {
    toTrace("loadRewardedVideo... BEGIN");
    if (this._rewardedVideoAd == null)
      initRewardedVideo(); 
    this._rewardedVideoAd.loadAd($unitId, $request);
    toTrace("loadRewardedVideo... END");
  }
  
  private void loadDoubleClickRewardedVideo(AdManagerAdRequest $request, String $unitId) {
    toTrace("loadDoubleClickRewardedVideo... BEGIN");
    if (this._rewardedVideoAd == null)
      initRewardedVideo();
    this._rewardedVideoAd.loadAd($unitId, $request);
    toTrace("loadDoubleClickRewardedVideo... END");
  }
  
  private void initBanner(String $unitId, int $adSize) {
    if (this._useDoubleClickApi) {
      if (this._bannerDoubleClick != null)
        disposeBanner(); 
    } else if (this._banner != null) {
      disposeBanner();
    } 
    toTrace("initBanner started...");
    if (this._useDoubleClickApi) {
      this._bannerDoubleClick = new PublisherAdView((Context)this._activity);
      this._bannerDoubleClick.setLayoutParams((ViewGroup.LayoutParams)this._relativeLayoutParams);
      switch ($adSize) {
        case 1:
          this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.BANNER });
          break;
        case 2:
          this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.FULL_BANNER });
          break;
        case 3:
          this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.LARGE_BANNER });
          break;
        case 4:
          this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.LEADERBOARD });
          break;
        case 5:
          this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.MEDIUM_RECTANGLE });
          break;
        case 6:
          this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.WIDE_SKYSCRAPER });
          break;
        case 7:
          this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.SMART_BANNER });
          break;
        case 8:
          this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.SMART_BANNER });
          break;
        case 9:
          this._banner.setAdSize(getAdSize());
          break;
      } 
      this._bannerDoubleClick.setAdUnitId($unitId);
      this._bannerDoubleClick.setAdListener(new MyAdListener(ExConsts.AD_TYPE_BANNER));
      this._frameLayout.addView((View)this._bannerDoubleClick);
    } else {
      this._banner = new AdView((Context)this._activity);
      this._banner.setLayoutParams((ViewGroup.LayoutParams)this._relativeLayoutParams);
      switch ($adSize) {
        case 1:
          this._banner.setAdSize(AdSize.BANNER);
          break;
        case 2:
          this._banner.setAdSize(AdSize.FULL_BANNER);
          break;
        case 3:
          this._banner.setAdSize(AdSize.LARGE_BANNER);
          break;
        case 4:
          this._banner.setAdSize(AdSize.LEADERBOARD);
          break;
        case 5:
          this._banner.setAdSize(AdSize.MEDIUM_RECTANGLE);
          break;
        case 6:
          this._banner.setAdSize(AdSize.WIDE_SKYSCRAPER);
          break;
        case 7:
          this._banner.setAdSize(AdSize.SMART_BANNER);
          break;
        case 8:
          this._banner.setAdSize(AdSize.SMART_BANNER);
          break;
        case 9:
          this._banner.setAdSize(getAdSize());
          break;
      } 
      this._banner.setAdUnitId($unitId);
      this._banner.setAdListener(new MyAdListener(ExConsts.AD_TYPE_BANNER, this._banner));
      this._frameLayout.addView((View)this._banner);
    } 
    toTrace("initBanner finished, Now we are waiting for the banner real width/height");
    this._preDrawCount = 0;
    if (this._useDoubleClickApi) {
      ViewTreeObserver vto = this._bannerDoubleClick.getViewTreeObserver();
      vto.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
            public boolean onPreDraw() {
              AirCommand.this._preDrawCount++;
              AirCommand.this.toTrace("onPreDraw: " + AirCommand.this._preDrawCount);
              if (AirCommand.this._bannerDoubleClick.getMeasuredWidth() > 0 && AirCommand.this._bannerDoubleClick.getMeasuredHeight() > 0) {
                AirCommand.this._bannerDoubleClick.getViewTreeObserver().removeOnPreDrawListener(this);
                AirCommand.this.finalWidth = AirCommand.this._bannerDoubleClick.getMeasuredWidth();
                AirCommand.this.finalHeight = AirCommand.this._bannerDoubleClick.getMeasuredHeight();
                AirCommand.this.toTrace(AirCommand.this.finalWidth + "x" + AirCommand.this.finalHeight);
                (AirCommand.this._frameLayout.getLayoutParams()).width = AirCommand.this.finalWidth;
                (AirCommand.this._frameLayout.getLayoutParams()).height = AirCommand.this.finalHeight;
                AirCommand.this._frameLayout.setLayoutParams(AirCommand.this._frameLayout.getLayoutParams());
                MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.BANNER_SIZE_MEASURED, AirCommand.this.finalWidth + "|||" + AirCommand.this.finalHeight);
              } 
              return true;
            }
          });
    } else {
      ViewTreeObserver vto = this._banner.getViewTreeObserver();
      vto.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
            public boolean onPreDraw() {
              AirCommand.this._preDrawCount++;
              AirCommand.this.toTrace("onPreDraw: " + AirCommand.this._preDrawCount);
              if (AirCommand.this._banner.getMeasuredWidth() > 0 && AirCommand.this._banner.getMeasuredHeight() > 0) {
                AirCommand.this._banner.getViewTreeObserver().removeOnPreDrawListener(this);
                AirCommand.this.finalWidth = AirCommand.this._banner.getMeasuredWidth();
                AirCommand.this.finalHeight = AirCommand.this._banner.getMeasuredHeight();
                AirCommand.this.toTrace(AirCommand.this.finalWidth + "x" + AirCommand.this.finalHeight);
                (AirCommand.this._frameLayout.getLayoutParams()).width = AirCommand.this.finalWidth;
                (AirCommand.this._frameLayout.getLayoutParams()).height = AirCommand.this.finalHeight;
                AirCommand.this._frameLayout.setLayoutParams(AirCommand.this._frameLayout.getLayoutParams());
                MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.BANNER_SIZE_MEASURED, AirCommand.this.finalWidth + "|||" + AirCommand.this.finalHeight);
              } 
              return true;
            }
          });
    } 
  }
  
  private AdSize getAdSize() {
    Display display = this._activity.getWindowManager().getDefaultDisplay();
    DisplayMetrics outMetrics = new DisplayMetrics();
    display.getMetrics(outMetrics);
    float widthPixels = outMetrics.widthPixels;
    float density = outMetrics.density;
    int adWidth = (int)(widthPixels / density);
    return AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize((Context)this._activity, adWidth);
  }
  
  private void disposeBanner() {
    if (this._useDoubleClickApi) {
      this._bannerDoubleClick.setAdListener(null);
      this._frameLayout.removeView((View)this._bannerDoubleClick);
      this._bannerDoubleClick = null;
    } else {
      this._banner.setAdListener(null);
      this._frameLayout.removeView((View)this._banner);
      this._banner = null;
    } 
  }
  
  private boolean isBannerLoading() {
    if (this._useDoubleClickApi)
      return this._bannerDoubleClick.isLoading(); 
    return this._banner.isLoading();
  }
  
  private void loadBanner(AdRequest $request) {
    this._banner.loadAd($request);
  }
  
  private void loadBannerDoubleClick(AdManagerAdRequest $request) {
    this._bannerDoubleClick.loadAd($request);
  }
  
  private AdRequest convertJsonToRequest(String str) {
    AdRequest.Builder builder;
    toTrace("convertJsonToRequest begin");
    try {
      JSONObject obj = new JSONObject(str);
      builder = new AdRequest.Builder();
      JSONArray keywords = obj.getJSONArray("keywords");
      for (int i = 0; i < keywords.length(); i++)
        builder.addKeyword(keywords.getString(i)); 
      JSONArray testDevices = obj.getJSONArray("testDevices");
      for (int j = 0; j < testDevices.length(); j++)
        builder.addTestDevice(testDevices.getString(j)); 
      String $contentUrl = obj.getString("contentUrl");
      if ($contentUrl.length() > 0)
        builder.setContentUrl($contentUrl); 
      Location $location = makeLocation(obj
          .getDouble("lat"), obj.getDouble("lng"));
      if ($location != null)
        builder.setLocation($location); 
      String $requestAgent = obj.getString("requestAgent");
      if ($requestAgent.length() > 0)
        builder.setRequestAgent($requestAgent); 
      String $maxAdContentRating = obj.getString("maxAdContentRating");
      if ($maxAdContentRating.length() > 0)
        builder.setMaxAdContentRating($maxAdContentRating); 
      builder.setTagForUnderAgeOfConsent(obj.getInt("tagForUnderAgeOfConsent"));
      builder.tagForChildDirectedTreatment(obj.getBoolean("tagForChildDirectedTreatment"));
      if (obj.has("extras")) {
        toTrace("we have NetworkExtrasBundle");
        JSONObject extrasObject = obj.getJSONObject("extras");
        Bundle extras = new Bundle();
        Iterator<?> keys = extrasObject.keys();
        while (keys.hasNext()) {
          String key = (String)keys.next();
          String value = extrasObject.getString(key);
          extras.putString(key, value);
        } 
        builder.addNetworkExtrasBundle(AdMobAdapter.class, extras);
      } else {
        toTrace("we do NOT have NetworkExtrasBundle");
      } 
    } catch (JSONException e) {
      toTrace("convertJsonToRequest end with error: " + e.getMessage());
      return null;
    } 
    toTrace("convertJsonToRequest end");
    return builder.build();
  }
  
  private AdManagerAdRequest convertJsonToDoubleClickRequest(String str) {
    AdManagerAdRequest.Builder builder;
    toTrace("convertJsonToDoubleClickRequest begin");
    try {
      JSONObject obj = new JSONObject(str);
      builder = new AdManagerAdRequest.Builder();
      JSONArray keywords = obj.getJSONArray("keywords");
      for (int i = 0; i < keywords.length(); i++)
        builder.addKeyword(keywords.getString(i)); 
      JSONArray testDevices = obj.getJSONArray("testDevices");
      for (int j = 0; j < testDevices.length(); j++)
        builder.addTestDevice(testDevices.getString(j)); 
      String $contentUrl = obj.getString("contentUrl");
      if ($contentUrl.length() > 0)
        builder.setContentUrl($contentUrl); 
      Location $location = makeLocation(obj
          .getDouble("lat"), obj.getDouble("lng"));
      if ($location != null)
        builder.setLocation($location); 
      String $requestAgent = obj.getString("requestAgent");
      if ($requestAgent.length() > 0)
        builder.setRequestAgent($requestAgent); 
      String $maxAdContentRating = obj.getString("maxAdContentRating");
      if ($maxAdContentRating.length() > 0)
        builder.setMaxAdContentRating($maxAdContentRating); 
      builder.setTagForUnderAgeOfConsent(obj.getInt("tagForUnderAgeOfConsent"));
      builder.tagForChildDirectedTreatment(obj.getBoolean("tagForChildDirectedTreatment"));
      if (obj.has("extras")) {
        toTrace("we have NetworkExtrasBundle");
        JSONObject extrasObject = obj.getJSONObject("extras");
        Bundle extras = new Bundle();
        Iterator<?> keys = extrasObject.keys();
        while (keys.hasNext()) {
          String key = (String)keys.next();
          String value = extrasObject.getString(key);
          extras.putString(key, value);
        } 
        builder.addNetworkExtrasBundle(AdMobAdapter.class, extras);
      } else {
        toTrace("we do NOT have NetworkExtrasBundle");
      } 
    } catch (JSONException e) {
      toTrace("convertJsonToDoubleClickRequest end with error: " + e.getMessage());
      return null;
    } 
    toTrace("convertJsonToDoubleClickRequest end");
    return builder.build();
  }
  
  private void initInterstitial(String $unitId) {
    toTrace("initInterstitial started...");
    if (this._useDoubleClickApi) {
      if (this._interstitialDoubleClick != null)
        disposeInterstitial(); AdManagerAdRequest
      this._interstitialDoubleClick = new AdManagerInterstitialAd((Context)this._activity);
      this._interstitialDoubleClick.setAdUnitId($unitId);
      this._interstitialDoubleClick.setAdListener(new MyAdListener(ExConsts.AD_TYPE_INTERSTITIAL));
    } else {
      if (this._interstitial != null)
        disposeInterstitial(); 
      this._interstitial = new InterstitialAd((Context)this._activity);
      this._interstitial.setAdUnitId($unitId);
      this._interstitial.setAdListener(new MyAdListener(ExConsts.AD_TYPE_INTERSTITIAL));
    } 
    toTrace("initInterstitial finished");
  }
  
  private void disposeInterstitial() {
    if (this._useDoubleClickApi) {
      this._interstitialDoubleClick.setAdListener(null);
      this._interstitialDoubleClick = null;
    } else {
      this._interstitial.setAdListener(null);
      this._interstitial = null;
    } 
  }
  
  private boolean isInterstitialLoading() {
    if (this._useDoubleClickApi)
      return this._interstitialDoubleClick.isLoading(); 
    return this._interstitial.isLoading();
  }
  
  private boolean isInterstitialLoaded() {
    if (this._useDoubleClickApi)
      return this._interstitialDoubleClick.isLoaded(); 
    return this._interstitial.isLoaded();
  }
  
  private void loadInterstitial(AdRequest $request) {
    this._interstitial.loadAd($request);
  }
  
  private void loadInterstitialDoubleClick(AdManagerAdRequest $request) {
    this._interstitialDoubleClick.loadAd($request);
  }
  
  private void toTrace(String $msg) {
    MyExtension.toTrace(ExConsts.ANE_NAME, 
        
        getClass().getSimpleName(), $msg);
  }
}

