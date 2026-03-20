package com.fluocode.admob
{
   import flash.desktop.NativeApplication;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.system.Capabilities;

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

      private static function get isAndroid():Boolean
      {
         return Capabilities.os.indexOf("Android") >= 0;
      }

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

      private function handleActivate(event:Event):void
      {
         if (_iosAdLeftApp)
         {
            _iosAdLeftApp = false;
            dispatchEvent(new AdMobEvents("onAdClosed", _iosAdTypeLeftApp));
         }
      }

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

      public function get banner():ApiBannerAds { return _banner; }
      public function get interstitial():ApiInterstitialAds { return _interstitial; }
      public function get rewardedVideo():ApiRewardedVideo { return _rewardedVideo; }
      public function get settings():Settings { return _settings; }
   }
}
