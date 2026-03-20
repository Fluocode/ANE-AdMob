/*     */ package com.myflashlab.admob;
/*     */ 
/*     */ import android.app.Activity;
/*     */ import android.app.AlertDialog;
/*     */ import android.content.Context;
/*     */ import android.content.DialogInterface;
/*     */ import android.graphics.Point;
/*     */ import android.location.Location;
/*     */ import android.os.Bundle;
/*     */ import android.util.DisplayMetrics;
/*     */ import android.view.Display;
/*     */ import android.view.View;
/*     */ import android.view.ViewGroup;
/*     */ import android.view.ViewTreeObserver;
/*     */ import android.widget.FrameLayout;
/*     */ import android.widget.RelativeLayout;
/*     */ import com.adobe.fre.FREContext;
/*     */ import com.adobe.fre.FREFunction;
/*     */ import com.adobe.fre.FREObject;
/*     */ import com.google.ads.mediation.admob.AdMobAdapter;
/*     */ import com.google.android.gms.ads.AdRequest;
/*     */ import com.google.android.gms.ads.AdSize;
/*     */ import com.google.android.gms.ads.AdView;
/*     */ import com.google.android.gms.ads.InterstitialAd;
/*     */ import com.google.android.gms.ads.MobileAds;
/*     */ import com.google.android.gms.ads.doubleclick.PublisherAdRequest;
/*     */ import com.google.android.gms.ads.doubleclick.PublisherAdView;
/*     */ import com.google.android.gms.ads.doubleclick.PublisherInterstitialAd;
/*     */ import com.google.android.gms.ads.reward.RewardedVideoAd;
/*     */ import com.myflashlab.Conversions;
/*     */ import com.myflashlab.dependency.overrideAir.MyExtension;
/*     */ import java.util.Iterator;
/*     */ import org.json.JSONArray;
/*     */ import org.json.JSONException;
/*     */ import org.json.JSONObject;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ public class AirCommand
/*     */   implements FREFunction
/*     */ {
/*  49 */   private int _preDrawCount = 0;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private boolean isDialogCalled = false;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private boolean isDialogClicked = false;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private boolean _useDoubleClickApi = false;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private boolean _isMobileAdsSDKInitialized = false;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private Activity _activity;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private FrameLayout _frameLayout;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private RelativeLayout.LayoutParams _relativeLayoutParams;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private FrameLayout.LayoutParams _lp_admob;
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private AdView _banner;
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private PublisherAdView _bannerDoubleClick;
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private InterstitialAd _interstitial;
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private PublisherInterstitialAd _interstitialDoubleClick;
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private RewardedVideoAd _rewardedVideoAd;
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private int finalWidth;
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private int finalHeight;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private enum commands
/*     */   {
/* 140 */     isTestVersion,
/* 141 */     getNativeDimension,
/* 142 */     test,
/* 143 */     initialize,
/*     */     
/* 145 */     initBanner,
/* 146 */     disposeBanner,
/* 147 */     isBannerLoading,
/* 148 */     loadBanner,
/* 149 */     hideBanner,
/*     */     
/* 151 */     setPosition,
/*     */     
/* 153 */     initInterstitial,
/* 154 */     disposeInterstitial,
/* 155 */     isInterstitialLoading,
/* 156 */     isInterstitialLoaded,
/* 157 */     loadInterstitial,
/* 158 */     showInterstitial,
/*     */     
/* 160 */     loadRewardedVideo,
/* 161 */     isRewardedVideoReady,
/* 162 */     showRewardedVideo,
/* 163 */     rewardedVideoGetUserId,
/* 164 */     rewardedVideoSetUserId,
/* 165 */     disposeRewardedVideo,
/*     */     
/* 167 */     MobileAdsSetAppMuted,
/* 168 */     MobileAdsSetAppVolume,
/* 169 */     MobileAdsOpenDebugMenu;
/*     */   }
/*     */ 
/*     */   
/*     */   private void showTestVersionDialog() {
/* 174 */     if (MyExtension.hasAnyDemoAne()) {
/*     */       return;
/*     */     }
/* 177 */     if (MyExtension.isAneRegistered(ExConsts.ANE_NAME)) {
/*     */       return;
/*     */     }
/*     */ 
/*     */     
/* 182 */     AlertDialog.Builder dialogBuilder = new AlertDialog.Builder((Context)this._activity);
/* 183 */     dialogBuilder.setTitle("DEMO ANE!");
/* 184 */     dialogBuilder.setMessage("The library '" + ExConsts.ANE_NAME + "' is not registered!");
/* 185 */     dialogBuilder.setCancelable(false);
/* 186 */     dialogBuilder.setPositiveButton("OK", (dialog, id) -> {
/*     */           dialog.dismiss();
/*     */           
/*     */           this.isDialogClicked = true;
/*     */         });
/* 191 */     AlertDialog myAlert = dialogBuilder.create();
/* 192 */     myAlert.show();
/*     */     
/* 194 */     this.isDialogCalled = true;
/*     */   }
/*     */   public FREObject call(FREContext $context, FREObject[] $params) {
/*     */     Point size, realSize;
/* 198 */     String command = Conversions.AirToJava_String($params[0]);
/* 199 */     FREObject result = null;
/*     */     
/* 201 */     if (this._activity == null) {
/* 202 */       this._activity = $context.getActivity();
/*     */     }
/*     */     
/* 205 */     toTrace("command: " + command);
/*     */     
/* 207 */     switch (commands.valueOf(command)) {
/*     */       
/*     */       case isTestVersion:
/* 210 */         showTestVersionDialog();
/*     */         break;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */       
/*     */       case getNativeDimension:
/* 241 */         size = new Point();
/* 242 */         realSize = new Point();
/* 243 */         this._activity.getWindowManager().getDefaultDisplay().getSize(size);
/* 244 */         this._activity.getWindowManager().getDefaultDisplay().getRealSize(realSize);
/*     */         
/* 246 */         toTrace("Native visible Dimension: " + size.x + "x" + size.y + "\nNative Real Dimension: " + realSize.x + "x" + realSize.y);
/*     */         
/* 248 */         result = Conversions.JavaToAir_String(size.x + "|||" + size.y + "|||" + realSize.x + "|||" + realSize.y);
/*     */         break;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */       
/*     */       case initialize:
/* 257 */         initialize(Conversions.AirToJava_String($params[1]));
/*     */         break;
/*     */ 
/*     */       
/*     */       case initBanner:
/* 262 */         initBanner(Conversions.AirToJava_String($params[1]), 
/* 263 */             Conversions.AirToJava_Integer($params[2]).intValue());
/*     */         break;
/*     */ 
/*     */       
/*     */       case disposeBanner:
/* 268 */         disposeBanner();
/*     */         break;
/*     */ 
/*     */       
/*     */       case isBannerLoading:
/* 273 */         result = Conversions.JavaToAir_Boolean(Boolean.valueOf(isBannerLoading()));
/*     */         break;
/*     */ 
/*     */       
/*     */       case loadBanner:
/* 278 */         if (this._useDoubleClickApi) {
/* 279 */           loadBannerDoubleClick(convertJsonToDoubleClickRequest(Conversions.AirToJava_String($params[1]))); break;
/* 280 */         }  loadBanner(convertJsonToRequest(Conversions.AirToJava_String($params[1])));
/*     */         break;
/*     */ 
/*     */       
/*     */       case hideBanner:
/* 285 */         if (this._useDoubleClickApi) {
/* 286 */           hideView((View)this._bannerDoubleClick, Conversions.AirToJava_Boolean($params[1]).booleanValue()); break;
/* 287 */         }  hideView((View)this._banner, Conversions.AirToJava_Boolean($params[1]).booleanValue());
/*     */         break;
/*     */ 
/*     */ 
/*     */       
/*     */       case setPosition:
/* 293 */         setPosition(Conversions.AirToJava_Double($params[1]), Conversions.AirToJava_Double($params[2]));
/*     */         break;
/*     */ 
/*     */       
/*     */       case initInterstitial:
/* 298 */         initInterstitial(Conversions.AirToJava_String($params[1]));
/*     */         break;
/*     */ 
/*     */       
/*     */       case disposeInterstitial:
/* 303 */         disposeInterstitial();
/*     */         break;
/*     */ 
/*     */       
/*     */       case isInterstitialLoading:
/* 308 */         result = Conversions.JavaToAir_Boolean(Boolean.valueOf(isInterstitialLoading()));
/*     */         break;
/*     */ 
/*     */       
/*     */       case isInterstitialLoaded:
/* 313 */         result = Conversions.JavaToAir_Boolean(Boolean.valueOf(isInterstitialLoaded()));
/*     */         break;
/*     */ 
/*     */       
/*     */       case loadInterstitial:
/* 318 */         if (this._useDoubleClickApi) {
/* 319 */           loadInterstitialDoubleClick(convertJsonToDoubleClickRequest(Conversions.AirToJava_String($params[1]))); break;
/*     */         } 
/* 321 */         loadInterstitial(convertJsonToRequest(Conversions.AirToJava_String($params[1])));
/*     */         break;
/*     */ 
/*     */       
/*     */       case showInterstitial:
/* 326 */         if (this._useDoubleClickApi) { this._interstitialDoubleClick.show(); break; }
/* 327 */          this._interstitial.show();
/*     */         break;
/*     */ 
/*     */       
/*     */       case loadRewardedVideo:
/* 332 */         if (this._useDoubleClickApi) {
/* 333 */           loadDoubleClickRewardedVideo(
/* 334 */               convertJsonToDoubleClickRequest(Conversions.AirToJava_String($params[1])), 
/* 335 */               Conversions.AirToJava_String($params[2]));
/*     */           break;
/*     */         } 
/* 338 */         loadRewardedVideo(
/* 339 */             convertJsonToRequest(Conversions.AirToJava_String($params[1])), 
/* 340 */             Conversions.AirToJava_String($params[2]));
/*     */         break;
/*     */ 
/*     */ 
/*     */ 
/*     */       
/*     */       case isRewardedVideoReady:
/* 347 */         toTrace("isRewardedVideoReady... BEGIN");
/*     */         
/* 349 */         if (this._rewardedVideoAd == null) initRewardedVideo(); 
/* 350 */         result = Conversions.JavaToAir_Boolean(Boolean.valueOf(this._rewardedVideoAd.isLoaded()));
/*     */         
/* 352 */         toTrace("isRewardedVideoReady... END");
/*     */         break;
/*     */ 
/*     */       
/*     */       case showRewardedVideo:
/* 357 */         toTrace("showRewardedVideo... BEGIN");
/*     */         
/* 359 */         this._rewardedVideoAd.show();
/*     */         
/* 361 */         toTrace("showRewardedVideo... END");
/*     */         break;
/*     */ 
/*     */       
/*     */       case rewardedVideoGetUserId:
/* 366 */         result = Conversions.JavaToAir_String(rewardedVideoGetUserId());
/*     */         break;
/*     */ 
/*     */       
/*     */       case rewardedVideoSetUserId:
/* 371 */         rewardedVideoSetUserId(Conversions.AirToJava_String($params[1]));
/*     */         break;
/*     */ 
/*     */       
/*     */       case disposeRewardedVideo:
/* 376 */         disposeRewardedVideo();
/*     */         break;
/*     */ 
/*     */       
/*     */       case MobileAdsSetAppMuted:
/* 381 */         MobileAds.setAppMuted(Conversions.AirToJava_Boolean($params[1]).booleanValue());
/*     */         break;
/*     */ 
/*     */       
/*     */       case MobileAdsSetAppVolume:
/* 386 */         MobileAds.setAppVolume((float)Conversions.AirToJava_Double($params[1]));
/*     */         break;
/*     */ 
/*     */       
/*     */       case MobileAdsOpenDebugMenu:
/* 391 */         MobileAds.openDebugMenu(this._activity.getApplicationContext(), Conversions.AirToJava_String($params[1]));
/*     */         break;
/*     */     } 
/*     */ 
/*     */     
/* 396 */     return result;
/*     */   }
/*     */ 
/*     */ 
/*     */   
/*     */   private void initialize(String $applicationCode) {
/* 402 */     if (!this._isMobileAdsSDKInitialized) {
/* 403 */       toTrace("initialize started...");
/*     */ 
/*     */ 
/*     */       
/* 407 */       if ($applicationCode.length() > 0) {
/* 408 */         MobileAds.initialize(this._activity.getApplicationContext(), $applicationCode);
/*     */       } else {
/*     */         
/* 411 */         this._useDoubleClickApi = true;
/*     */       } 
/*     */       
/* 414 */       this._isMobileAdsSDKInitialized = true;
/*     */       
/* 416 */       toTrace("_useDoubleClickApi: " + this._useDoubleClickApi);
/* 417 */       toTrace("initialize finished");
/*     */     } 
/*     */     
/* 420 */     toTrace("setting layers started...");
/*     */ 
/*     */     
/* 423 */     this._frameLayout = new FrameLayout(this._activity.getApplicationContext());
/* 424 */     this._frameLayout.setClickable(false);
/*     */ 
/*     */     
/* 427 */     this._relativeLayoutParams = new RelativeLayout.LayoutParams(-2, -2);
/* 428 */     this._relativeLayoutParams.addRule(12);
/*     */ 
/*     */     
/* 431 */     this._lp_admob = new FrameLayout.LayoutParams(-1, -1);
/* 432 */     this._lp_admob.gravity = 8388659;
/* 433 */     this._lp_admob.setMargins(0, 0, 0, 0);
/*     */ 
/*     */     
/* 436 */     this._activity.addContentView((View)this._frameLayout, (ViewGroup.LayoutParams)this._lp_admob);
/*     */     
/* 438 */     toTrace("setting layers finished");
/*     */   }
/*     */ 
/*     */ 
/*     */ 
/*     */   
/*     */   private void hideView(View $target, boolean $value) {
/* 445 */     if ($value) { $target.setVisibility(4); }
/* 446 */     else { $target.setVisibility(0); }
/*     */   
/*     */   }
/*     */   private void setPosition(double $x, double $y) {
/* 450 */     toTrace("setPosition x = " + $x + " y = " + $y);
/*     */     
/* 452 */     this._lp_admob.gravity = 8388659;
/* 453 */     this._lp_admob.setMargins((int)$x, (int)$y, 0, 0);
/* 454 */     this._frameLayout.setLayoutParams((ViewGroup.LayoutParams)this._lp_admob);
/*     */   }
/*     */   
/*     */   private Location makeLocation(double $lat, double $lng) {
/* 458 */     if ($lat < 0.0D || $lng < 0.0D) return null;
/*     */     
/* 460 */     Location loc = new Location("");
/* 461 */     loc.setLatitude($lat);
/* 462 */     loc.setLongitude($lng);
/*     */     
/* 464 */     return loc;
/*     */   }
/*     */ 
/*     */ 
/*     */   
/*     */   private void initRewardedVideo() {
/* 470 */     toTrace("initRewardedVideo... BEGIN");
/*     */     
/*     */     try {
/* 473 */       this._rewardedVideoAd = MobileAds.getRewardedVideoAdInstance((Context)this._activity);
/* 474 */       this._rewardedVideoAd.setRewardedVideoAdListener(new MyRewardListener(ExConsts.AD_TYPE_REWARDED_VIDEO));
/* 475 */       this._rewardedVideoAd.setAdMetadataListener(new MyAdMetadataListener(this._rewardedVideoAd));
/* 476 */     } catch (Exception e) {
/* 477 */       toTrace(e.getMessage());
/*     */     } 
/*     */     
/* 480 */     toTrace("initRewardedVideo... END");
/*     */   }
/*     */   
/*     */   private void disposeRewardedVideo() {
/* 484 */     toTrace("disposeRewardedVideo... BEGIN");
/*     */     
/* 486 */     if (this._rewardedVideoAd != null) {
/* 487 */       this._rewardedVideoAd.setRewardedVideoAdListener(null);
/* 488 */       this._rewardedVideoAd.setAdMetadataListener(null);
/* 489 */       this._rewardedVideoAd.destroy((Context)this._activity);
/* 490 */       this._rewardedVideoAd = null;
/*     */     } 
/*     */     
/* 493 */     toTrace("disposeRewardedVideo... END");
/*     */   }
/*     */   
/*     */   private String rewardedVideoGetUserId() {
/* 497 */     toTrace("rewardedVideoGetUserId... BEGIN");
/*     */     
/* 499 */     if (this._rewardedVideoAd == null) initRewardedVideo();
/*     */     
/* 501 */     toTrace("rewardedVideoGetUserId: " + this._rewardedVideoAd.getUserId());
/* 502 */     toTrace("rewardedVideoGetUserId... END");
/*     */     
/* 504 */     if (this._rewardedVideoAd.getUserId() == null) return "";
/*     */     
/* 506 */     return this._rewardedVideoAd.getUserId();
/*     */   }
/*     */   
/*     */   private void rewardedVideoSetUserId(String $id) {
/* 510 */     if ($id.length() < 1)
/*     */       return; 
/* 512 */     if (this._rewardedVideoAd == null) initRewardedVideo();
/*     */     
/* 514 */     this._rewardedVideoAd.setUserId($id);
/*     */   }
/*     */   
/*     */   private void loadRewardedVideo(AdRequest $request, String $unitId) {
/* 518 */     toTrace("loadRewardedVideo... BEGIN");
/*     */     
/* 520 */     if (this._rewardedVideoAd == null) initRewardedVideo(); 
/* 521 */     this._rewardedVideoAd.loadAd($unitId, $request);
/*     */     
/* 523 */     toTrace("loadRewardedVideo... END");
/*     */   }
/*     */   
/*     */   private void loadDoubleClickRewardedVideo(PublisherAdRequest $request, String $unitId) {
/* 527 */     toTrace("loadDoubleClickRewardedVideo... BEGIN");
/*     */     
/* 529 */     if (this._rewardedVideoAd == null) initRewardedVideo(); 
/* 530 */     this._rewardedVideoAd.loadAd($unitId, $request);
/*     */     
/* 532 */     toTrace("loadDoubleClickRewardedVideo... END");
/*     */   }
/*     */ 
/*     */ 
/*     */   
/*     */   private void initBanner(String $unitId, int $adSize) {
/* 538 */     if (this._useDoubleClickApi)
/*     */     
/* 540 */     { if (this._bannerDoubleClick != null) disposeBanner();
/*     */        }
/* 542 */     else if (this._banner != null) { disposeBanner(); }
/*     */ 
/*     */     
/* 545 */     toTrace("initBanner started...");
/*     */ 
/*     */     
/* 548 */     if (this._useDoubleClickApi) {
/* 549 */       this._bannerDoubleClick = new PublisherAdView((Context)this._activity);
/* 550 */       this._bannerDoubleClick.setLayoutParams((ViewGroup.LayoutParams)this._relativeLayoutParams);
/*     */       
/* 552 */       switch ($adSize) {
/*     */         case 1:
/* 554 */           this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.BANNER });
/*     */           break;
/*     */         case 2:
/* 557 */           this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.FULL_BANNER });
/*     */           break;
/*     */         case 3:
/* 560 */           this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.LARGE_BANNER });
/*     */           break;
/*     */         case 4:
/* 563 */           this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.LEADERBOARD });
/*     */           break;
/*     */         case 5:
/* 566 */           this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.MEDIUM_RECTANGLE });
/*     */           break;
/*     */         case 6:
/* 569 */           this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.WIDE_SKYSCRAPER });
/*     */           break;
/*     */         case 7:
/* 572 */           this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.SMART_BANNER });
/*     */           break;
/*     */         
/*     */         case 8:
/* 576 */           this._bannerDoubleClick.setAdSizes(new AdSize[] { AdSize.SMART_BANNER });
/*     */           break;
/*     */         case 9:
/* 579 */           this._banner.setAdSize(getAdSize());
/*     */           break;
/*     */       } 
/*     */       
/* 583 */       this._bannerDoubleClick.setAdUnitId($unitId);
/* 584 */       this._bannerDoubleClick.setAdListener(new MyAdListener(ExConsts.AD_TYPE_BANNER));
/*     */ 
/*     */       
/* 587 */       this._frameLayout.addView((View)this._bannerDoubleClick);
/*     */     } else {
/* 589 */       this._banner = new AdView((Context)this._activity);
/* 590 */       this._banner.setLayoutParams((ViewGroup.LayoutParams)this._relativeLayoutParams);
/*     */       
/* 592 */       switch ($adSize) {
/*     */         case 1:
/* 594 */           this._banner.setAdSize(AdSize.BANNER);
/*     */           break;
/*     */         case 2:
/* 597 */           this._banner.setAdSize(AdSize.FULL_BANNER);
/*     */           break;
/*     */         case 3:
/* 600 */           this._banner.setAdSize(AdSize.LARGE_BANNER);
/*     */           break;
/*     */         case 4:
/* 603 */           this._banner.setAdSize(AdSize.LEADERBOARD);
/*     */           break;
/*     */         case 5:
/* 606 */           this._banner.setAdSize(AdSize.MEDIUM_RECTANGLE);
/*     */           break;
/*     */         case 6:
/* 609 */           this._banner.setAdSize(AdSize.WIDE_SKYSCRAPER);
/*     */           break;
/*     */         case 7:
/* 612 */           this._banner.setAdSize(AdSize.SMART_BANNER);
/*     */           break;
/*     */         
/*     */         case 8:
/* 616 */           this._banner.setAdSize(AdSize.SMART_BANNER);
/*     */           break;
/*     */         case 9:
/* 619 */           this._banner.setAdSize(getAdSize());
/*     */           break;
/*     */       } 
/*     */       
/* 623 */       this._banner.setAdUnitId($unitId);
/* 624 */       this._banner.setAdListener(new MyAdListener(ExConsts.AD_TYPE_BANNER, this._banner));
/*     */ 
/*     */       
/* 627 */       this._frameLayout.addView((View)this._banner);
/*     */     } 
/*     */     
/* 630 */     toTrace("initBanner finished, Now we are waiting for the banner real width/height");
/* 631 */     this._preDrawCount = 0;
/*     */     
/* 633 */     if (this._useDoubleClickApi) {
/*     */       
/* 635 */       ViewTreeObserver vto = this._bannerDoubleClick.getViewTreeObserver();
/* 636 */       vto.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener()
/*     */           {
/*     */             public boolean onPreDraw() {
/* 639 */               AirCommand.this._preDrawCount++;
/* 640 */               AirCommand.this.toTrace("onPreDraw: " + AirCommand.this._preDrawCount);
/*     */               
/* 642 */               if (AirCommand.this._bannerDoubleClick.getMeasuredWidth() > 0 && AirCommand.this._bannerDoubleClick.getMeasuredHeight() > 0) {
/* 643 */                 AirCommand.this._bannerDoubleClick.getViewTreeObserver().removeOnPreDrawListener(this);
/*     */                 
/* 645 */                 AirCommand.this.finalWidth = AirCommand.this._bannerDoubleClick.getMeasuredWidth();
/* 646 */                 AirCommand.this.finalHeight = AirCommand.this._bannerDoubleClick.getMeasuredHeight();
/*     */                 
/* 648 */                 AirCommand.this.toTrace(AirCommand.this.finalWidth + "x" + AirCommand.this.finalHeight);
/*     */ 
/*     */                 
/* 651 */                 (AirCommand.this._frameLayout.getLayoutParams()).width = AirCommand.this.finalWidth;
/* 652 */                 (AirCommand.this._frameLayout.getLayoutParams()).height = AirCommand.this.finalHeight;
/* 653 */                 AirCommand.this._frameLayout.setLayoutParams(AirCommand.this._frameLayout.getLayoutParams());
/*     */                 
/* 655 */                 MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.BANNER_SIZE_MEASURED, AirCommand.this.finalWidth + "|||" + AirCommand.this.finalHeight);
/*     */               } 
/*     */               
/* 658 */               return true;
/*     */             }
/*     */           });
/*     */     } else {
/*     */       
/* 663 */       ViewTreeObserver vto = this._banner.getViewTreeObserver();
/* 664 */       vto.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener()
/*     */           {
/*     */             public boolean onPreDraw() {
/* 667 */               AirCommand.this._preDrawCount++;
/* 668 */               AirCommand.this.toTrace("onPreDraw: " + AirCommand.this._preDrawCount);
/*     */               
/* 670 */               if (AirCommand.this._banner.getMeasuredWidth() > 0 && AirCommand.this._banner.getMeasuredHeight() > 0) {
/* 671 */                 AirCommand.this._banner.getViewTreeObserver().removeOnPreDrawListener(this);
/*     */                 
/* 673 */                 AirCommand.this.finalWidth = AirCommand.this._banner.getMeasuredWidth();
/* 674 */                 AirCommand.this.finalHeight = AirCommand.this._banner.getMeasuredHeight();
/*     */                 
/* 676 */                 AirCommand.this.toTrace(AirCommand.this.finalWidth + "x" + AirCommand.this.finalHeight);
/*     */ 
/*     */                 
/* 679 */                 (AirCommand.this._frameLayout.getLayoutParams()).width = AirCommand.this.finalWidth;
/* 680 */                 (AirCommand.this._frameLayout.getLayoutParams()).height = AirCommand.this.finalHeight;
/* 681 */                 AirCommand.this._frameLayout.setLayoutParams(AirCommand.this._frameLayout.getLayoutParams());
/*     */                 
/* 683 */                 MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.BANNER_SIZE_MEASURED, AirCommand.this.finalWidth + "|||" + AirCommand.this.finalHeight);
/*     */               } 
/*     */               
/* 686 */               return true;
/*     */             }
/*     */           });
/*     */     } 
/*     */   }
/*     */ 
/*     */   
/*     */   private AdSize getAdSize() {
/* 694 */     Display display = this._activity.getWindowManager().getDefaultDisplay();
/* 695 */     DisplayMetrics outMetrics = new DisplayMetrics();
/* 696 */     display.getMetrics(outMetrics);
/*     */     
/* 698 */     float widthPixels = outMetrics.widthPixels;
/* 699 */     float density = outMetrics.density;
/*     */     
/* 701 */     int adWidth = (int)(widthPixels / density);
/*     */ 
/*     */     
/* 704 */     return AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize((Context)this._activity, adWidth);
/*     */   }
/*     */   
/*     */   private void disposeBanner() {
/* 708 */     if (this._useDoubleClickApi) {
/*     */       
/* 710 */       this._bannerDoubleClick.setAdListener(null);
/*     */ 
/*     */       
/* 713 */       this._frameLayout.removeView((View)this._bannerDoubleClick);
/*     */       
/* 715 */       this._bannerDoubleClick = null;
/*     */     } else {
/*     */       
/* 718 */       this._banner.setAdListener(null);
/*     */ 
/*     */       
/* 721 */       this._frameLayout.removeView((View)this._banner);
/*     */       
/* 723 */       this._banner = null;
/*     */     } 
/*     */   }
/*     */   
/*     */   private boolean isBannerLoading() {
/* 728 */     if (this._useDoubleClickApi) {
/* 729 */       return this._bannerDoubleClick.isLoading();
/*     */     }
/*     */     
/* 732 */     return this._banner.isLoading();
/*     */   }
/*     */   
/*     */   private void loadBanner(AdRequest $request) {
/* 736 */     this._banner.loadAd($request);
/*     */   }
/*     */   
/*     */   private void loadBannerDoubleClick(PublisherAdRequest $request) {
/* 740 */     this._bannerDoubleClick.loadAd($request);
/*     */   }
/*     */   private AdRequest convertJsonToRequest(String str) {
/*     */     AdRequest.Builder builder;
/* 744 */     toTrace("convertJsonToRequest begin");
/*     */ 
/*     */ 
/*     */     
/*     */     try {
/* 749 */       JSONObject obj = new JSONObject(str);
/*     */       
/* 751 */       builder = new AdRequest.Builder();
/*     */       
/* 753 */       JSONArray keywords = obj.getJSONArray("keywords");
/* 754 */       for (int i = 0; i < keywords.length(); i++) {
/* 755 */         builder.addKeyword(keywords.getString(i));
/*     */       }
/* 757 */       JSONArray testDevices = obj.getJSONArray("testDevices");
/* 758 */       for (int j = 0; j < testDevices.length(); j++) {
/* 759 */         builder.addTestDevice(testDevices.getString(j));
/*     */       }
/* 761 */       String $contentUrl = obj.getString("contentUrl");
/* 762 */       if ($contentUrl.length() > 0) builder.setContentUrl($contentUrl);
/*     */       
/* 764 */       Location $location = makeLocation(obj
/* 765 */           .getDouble("lat"), obj.getDouble("lng"));
/*     */ 
/*     */       
/* 768 */       if ($location != null) builder.setLocation($location);
/*     */       
/* 770 */       String $requestAgent = obj.getString("requestAgent");
/* 771 */       if ($requestAgent.length() > 0) builder.setRequestAgent($requestAgent);
/*     */       
/* 773 */       String $maxAdContentRating = obj.getString("maxAdContentRating");
/* 774 */       if ($maxAdContentRating.length() > 0) {
/* 775 */         builder.setMaxAdContentRating($maxAdContentRating);
/*     */       }
/* 777 */       builder.setTagForUnderAgeOfConsent(obj.getInt("tagForUnderAgeOfConsent"));
/*     */       
/* 779 */       builder.tagForChildDirectedTreatment(obj.getBoolean("tagForChildDirectedTreatment"));
/*     */ 
/*     */       
/* 782 */       if (obj.has("extras")) {
/* 783 */         toTrace("we have NetworkExtrasBundle");
/*     */         
/* 785 */         JSONObject extrasObject = obj.getJSONObject("extras");
/*     */         
/* 787 */         Bundle extras = new Bundle();
/*     */         
/* 789 */         Iterator<?> keys = extrasObject.keys();
/* 790 */         while (keys.hasNext()) {
/* 791 */           String key = (String)keys.next();
/* 792 */           String value = extrasObject.getString(key);
/*     */           
/* 794 */           extras.putString(key, value);
/*     */         } 
/*     */         
/* 797 */         builder.addNetworkExtrasBundle(AdMobAdapter.class, extras);
/*     */       } else {
/* 799 */         toTrace("we do NOT have NetworkExtrasBundle");
/*     */       } 
/* 801 */     } catch (JSONException e) {
/* 802 */       toTrace("convertJsonToRequest end with error: " + e.getMessage());
/* 803 */       return null;
/*     */     } 
/*     */     
/* 806 */     toTrace("convertJsonToRequest end");
/*     */ 
/*     */     
/* 809 */     return builder.build();
/*     */   }
/*     */   private PublisherAdRequest convertJsonToDoubleClickRequest(String str) {
/*     */     PublisherAdRequest.Builder builder;
/* 813 */     toTrace("convertJsonToDoubleClickRequest begin");
/*     */ 
/*     */ 
/*     */     
/*     */     try {
/* 818 */       JSONObject obj = new JSONObject(str);
/* 819 */       builder = new PublisherAdRequest.Builder();
/*     */       
/* 821 */       JSONArray keywords = obj.getJSONArray("keywords");
/* 822 */       for (int i = 0; i < keywords.length(); i++) {
/* 823 */         builder.addKeyword(keywords.getString(i));
/*     */       }
/*     */       
/* 826 */       JSONArray testDevices = obj.getJSONArray("testDevices");
/* 827 */       for (int j = 0; j < testDevices.length(); j++) {
/* 828 */         builder.addTestDevice(testDevices.getString(j));
/*     */       }
/*     */       
/* 831 */       String $contentUrl = obj.getString("contentUrl");
/* 832 */       if ($contentUrl.length() > 0) builder.setContentUrl($contentUrl);
/*     */       
/* 834 */       Location $location = makeLocation(obj
/* 835 */           .getDouble("lat"), obj.getDouble("lng"));
/*     */ 
/*     */       
/* 838 */       if ($location != null) builder.setLocation($location);
/*     */       
/* 840 */       String $requestAgent = obj.getString("requestAgent");
/* 841 */       if ($requestAgent.length() > 0) builder.setRequestAgent($requestAgent);
/*     */       
/* 843 */       String $maxAdContentRating = obj.getString("maxAdContentRating");
/* 844 */       if ($maxAdContentRating.length() > 0) {
/* 845 */         builder.setMaxAdContentRating($maxAdContentRating);
/*     */       }
/* 847 */       builder.setTagForUnderAgeOfConsent(obj.getInt("tagForUnderAgeOfConsent"));
/*     */       
/* 849 */       builder.tagForChildDirectedTreatment(obj.getBoolean("tagForChildDirectedTreatment"));
/*     */ 
/*     */       
/* 852 */       if (obj.has("extras")) {
/* 853 */         toTrace("we have NetworkExtrasBundle");
/*     */         
/* 855 */         JSONObject extrasObject = obj.getJSONObject("extras");
/*     */         
/* 857 */         Bundle extras = new Bundle();
/*     */         
/* 859 */         Iterator<?> keys = extrasObject.keys();
/* 860 */         while (keys.hasNext()) {
/* 861 */           String key = (String)keys.next();
/* 862 */           String value = extrasObject.getString(key);
/*     */           
/* 864 */           extras.putString(key, value);
/*     */         } 
/*     */         
/* 867 */         builder.addNetworkExtrasBundle(AdMobAdapter.class, extras);
/*     */       } else {
/* 869 */         toTrace("we do NOT have NetworkExtrasBundle");
/*     */       } 
/* 871 */     } catch (JSONException e) {
/* 872 */       toTrace("convertJsonToDoubleClickRequest end with error: " + e.getMessage());
/* 873 */       return null;
/*     */     } 
/*     */     
/* 876 */     toTrace("convertJsonToDoubleClickRequest end");
/*     */ 
/*     */     
/* 879 */     return builder.build();
/*     */   }
/*     */ 
/*     */ 
/*     */   
/*     */   private void initInterstitial(String $unitId) {
/* 885 */     toTrace("initInterstitial started...");
/*     */ 
/*     */     
/* 888 */     if (this._useDoubleClickApi) {
/* 889 */       if (this._interstitialDoubleClick != null)
/*     */       {
/* 891 */         disposeInterstitial();
/*     */       }
/*     */       
/* 894 */       this._interstitialDoubleClick = new PublisherInterstitialAd((Context)this._activity);
/* 895 */       this._interstitialDoubleClick.setAdUnitId($unitId);
/* 896 */       this._interstitialDoubleClick.setAdListener(new MyAdListener(ExConsts.AD_TYPE_INTERSTITIAL));
/*     */     } else {
/* 898 */       if (this._interstitial != null)
/*     */       {
/* 900 */         disposeInterstitial();
/*     */       }
/*     */       
/* 903 */       this._interstitial = new InterstitialAd((Context)this._activity);
/* 904 */       this._interstitial.setAdUnitId($unitId);
/* 905 */       this._interstitial.setAdListener(new MyAdListener(ExConsts.AD_TYPE_INTERSTITIAL));
/*     */     } 
/*     */     
/* 908 */     toTrace("initInterstitial finished");
/*     */   }
/*     */   
/*     */   private void disposeInterstitial() {
/* 912 */     if (this._useDoubleClickApi) {
/*     */       
/* 914 */       this._interstitialDoubleClick.setAdListener(null);
/* 915 */       this._interstitialDoubleClick = null;
/*     */     } else {
/*     */       
/* 918 */       this._interstitial.setAdListener(null);
/* 919 */       this._interstitial = null;
/*     */     } 
/*     */   }
/*     */   
/*     */   private boolean isInterstitialLoading() {
/* 924 */     if (this._useDoubleClickApi) {
/* 925 */       return this._interstitialDoubleClick.isLoading();
/*     */     }
/*     */     
/* 928 */     return this._interstitial.isLoading();
/*     */   }
/*     */   
/*     */   private boolean isInterstitialLoaded() {
/* 932 */     if (this._useDoubleClickApi) {
/* 933 */       return this._interstitialDoubleClick.isLoaded();
/*     */     }
/*     */     
/* 936 */     return this._interstitial.isLoaded();
/*     */   }
/*     */   
/*     */   private void loadInterstitial(AdRequest $request) {
/* 940 */     this._interstitial.loadAd($request);
/*     */   }
/*     */   
/*     */   private void loadInterstitialDoubleClick(PublisherAdRequest $request) {
/* 944 */     this._interstitialDoubleClick.loadAd($request);
/*     */   }
/*     */   
/*     */   private void toTrace(String $msg) {
/* 948 */     MyExtension.toTrace(ExConsts.ANE_NAME, 
/*     */         
/* 950 */         getClass().getSimpleName(), $msg);
/*     */   }
/*     */ }


/* Location:              C:\Users\esdeb\Desktop\classes.jar!\com\myflashlab\admob\AirCommand.class
 * Java compiler version: 8 (52.0)
 * JD-Core Version:       1.1.3
 */