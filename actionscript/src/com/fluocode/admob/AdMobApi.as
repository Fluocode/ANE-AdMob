package com.fluocode.admob
{
   import flash.desktop.NativeApplication;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.system.Capabilities;

   /**
    * Central facade for AdMob features: banner, interstitial, rewarded video, and global settings.
    * <p>Listen for {@link AdMobEvents} on this dispatcher for lifecycle and error callbacks from native code.</p>
    *
    * <p><b>Dispatched events (high level)</b> include types matching {@link AdMobEvents} constants, such as
    * {@link AdMobEvents#AD_LOADED}, {@link AdMobEvents#AD_FAILED}, {@link AdMobEvents#AD_CLOSED}, etc.</p>
    *
    * @see AdMob#init
    * @see AdMobEvents
    *
    * @langversion 3.0
    * @playerversion AIR 3.0
    */
   public class AdMobApi extends EventDispatcher
   {
      private var _main:AdMob;
      private var _context:ExtensionContext;
      private var _banner:ApiBannerAds;
      private var _interstitial:ApiInterstitialAds;
      private var _rewardedVideo:ApiRewardedVideo;
      private var _nativeExpress:ApiNativeAdsExpress;
      private var _settings:Settings;
      private var _iosAdLeftApp:Boolean = false;
      private var _iosAdTypeLeftApp:String;

      /** @private */
      private static function get isAndroid():Boolean
      {
         return Capabilities.os.indexOf("Android") >= 0;
      }

      /**
       * @param admob              Parent {@link AdMob} instance.
       * @param context            Native extension context.
       * @param applicationCode    Passed to native <code>initialize</code> (AdMob app id, etc.).
       */
      public function AdMobApi(admob:AdMob, context:ExtensionContext, applicationCode:String)
      {
         super();
         _main = admob;
         _context = context;
         _banner = new ApiBannerAds(_main, _context);
         _interstitial = new ApiInterstitialAds(_main, _context);
         _rewardedVideo = new ApiRewardedVideo(_main, _context);
         _nativeExpress = new ApiNativeAdsExpress(_main, _context);
         _settings = new Settings(_context);
         _context.addEventListener("status", onStatus);
         _context.call("command", "initialize", applicationCode);
         NativeApplication.nativeApplication.addEventListener("activate", handleActivate);
      }

      /** @private iOS workaround: synthesize close after user returns from external browser. */
      private function handleActivate(event:Event):void
      {
         if (_iosAdLeftApp)
         {
            _iosAdLeftApp = false;
            dispatchEvent(new AdMobEvents("onAdClosed", _iosAdTypeLeftApp));
         }
      }

      /** @private Routes {@link StatusEvent} from the extension to typed {@link AdMobEvents}. */
      private function onStatus(event:StatusEvent):void
      {
         var parts:Array;
         switch (event.code)
         {
            case "onAdClosed":
               dispatchEvent(new AdMobEvents("onAdClosed", event.level));
               break;
            case "onAdFailed":
               parts = event.level.split("|||");
               dispatchEvent(new AdMobEvents("onAdFailed", parts[0], parts[1], 0, 0, parts[2]));
               break;
            case "onAdLeftApp":
               if (!isAndroid && event.level == "banner")
               {
                  dispatchEvent(new AdMobEvents("onAdOpened", event.level));
                  _iosAdLeftApp = true;
                  _iosAdTypeLeftApp = event.level;
               }
               dispatchEvent(new AdMobEvents("onAdLeftApp", event.level));
               break;
            case "onAdLoaded":
               if (event.level == "banner" && isAndroid)
               {
                  _banner.setPosition(1, 1);
                  _banner.setPosition(0, 0);
               }
               dispatchEvent(new AdMobEvents("onAdLoaded", event.level));
               break;
            case "onAdOpened":
               dispatchEvent(new AdMobEvents("onAdOpened", event.level));
               break;
         }
         _banner.onStatus(event);
         _interstitial.onStatus(event);
         _rewardedVideo.onStatus(event);
         _nativeExpress.onStatus(event);
         _settings.onStatus(event);
      }

      /** @internal Called from {@link AdMob#dispose}. */
      internal function dispose():void
      {
         NativeApplication.nativeApplication.removeEventListener("activate", handleActivate);
         _banner.dispose();
         _interstitial.dispose();
         _rewardedVideo.dispose();
         _nativeExpress.dispose();
         _settings.dispose();
         _context.removeEventListener("status", onStatus);
         _context.call("command", "dispose");
         _context.dispose();
         _context = null;
      }

      /**
       * Banner ad API (create, load, position, visibility).
       */
      public function get banner():ApiBannerAds { return _banner; }
      /**
       * Full-screen interstitial ad API.
       */
      public function get interstitial():ApiInterstitialAds { return _interstitial; }
      /**
       * Rewarded video ad API.
       */
      public function get rewardedVideo():ApiRewardedVideo { return _rewardedVideo; }
      /**
       * Global Mobile Ads settings (volume, mute).
       */
      public function get settings():Settings { return _settings; }
   }
}
