package com.fluocode.admob
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.external.ExtensionContext;
   import flash.system.Capabilities;

   /**
    * Entry point for the Google AdMob AIR Native Extension (ANE).
    * <p>Initialize once per application with {@link #init}, access ad APIs via {@link #api}, and call {@link #dispose}
    * when finished.</p>
    *
    * @see AdMobApi
    * @see #EXTENSION_ID
    *
    * @langversion 3.0
    * @playerversion AIR 3.0
    */
   public class AdMob
   {
      /** @private Internal flag reserved for demo or telemetry builds. */
      internal static const DEMO_ANE:Boolean = false;

      /** Error code: internal SDK error. */
      public static const ERROR_CODE_INTERNAL_ERROR:int = 0;
      /** Error code: invalid ad request. */
      public static const ERROR_CODE_INVALID_REQUEST:int = 1;
      /** Error code: network error. */
      public static const ERROR_CODE_NETWORK_ERROR:int = 2;
      /** Error code: no ad inventory (no fill). */
      public static const ERROR_CODE_NO_FILL:int = 3;
      /** String identifier for banner ad type in events. */
      public static const AD_TYPE_BANNER:String = "banner";
      /** String identifier for interstitial ad type in events. */
      public static const AD_TYPE_INTERSTITIAL:String = "interstitial";
      /** String identifier for rewarded video ad type in events. */
      public static const AD_TYPE_REWARDED_VIDEO:String = "rewardedVideo";

      private static var _ex:AdMob;

      /** AIR extension descriptor id; must match <code>&lt;id&gt;</code> in extension.xml. */
      public static const EXTENSION_ID:String = "com.fluocode.admob";
      /** ANE SWF/API version label. */
      public static const VERSION:String = "1.0.0";
      /** Google Mobile Ads SDK version string used on iOS (reference only). */
      public static const IOS_SDK_VERSION:String = "11.0.0";
      /** Google Play services ads SDK version string used on Android (reference only). */
      public static const ANDROID_SDK_VERSION:String = "23.0.0";

      private var _ratioWidth:Number;
      private var _ratioHeight:Number;
      private var _api:AdMobApi;
      private var _context:ExtensionContext;
      private var _stage:Stage;

      /** @private */
      private static function get isAndroid():Boolean
      {
         return Capabilities.os.indexOf("Android") >= 0;
      }

      /**
       * Creates a new AdMob instance and native extension context.
       * <p>Prefer {@link #init} for singleton usage.</p>
       *
       * @param stage       Application stage used for layout ratio and resize handling.
       * @param applicationCode On Android/iOS, the AdMob application id (e.g. <code>ca-app-pub-xxx~yyy</code>),
       *                        or an empty string if your app uses Ad Manager only (native semantics apply).
       */
      public function AdMob(stage:Stage, applicationCode:String)
      {
         _stage = stage;
         _context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
         getDimensionRatio(_stage);
         _stage.addEventListener("resize", onResize);
         _api = new AdMobApi(this, _context, applicationCode);
      }

      /**
       * Initializes the singleton AdMob instance if it does not yet exist.
       *
       * @param stage             Application stage.
       * @param applicationCode   AdMob app id string, or <code>null</code>/empty for default native behavior.
       * @return                  The shared {@link AdMob} instance.
       */
      public static function init(stage:Stage, applicationCode:String = null):AdMob
      {
         if (!applicationCode) applicationCode = "";
         if (!_ex)
            _ex = new AdMob(stage, applicationCode);
         return _ex;
      }

      /**
       * Releases the extension context, removes listeners, and clears the singleton.
       * <p>Safe to call when {@link #init} was never called (no-op).</p>
       */
      public static function dispose():void
      {
         if (!_ex) return;
         _ex._stage.removeEventListener("resize", _ex.onResize);
         _ex._api.dispose();
         _ex = null;
      }

      /**
       * Root API object for banner, interstitial, rewarded ads, and settings.
       *
       * @return {@link AdMobApi} after {@link #init}, or <code>null</code> if not initialized.
       */
      public static function get api():AdMobApi
      {
         return _ex ? _ex._api : null;
      }

      /** @private */
      private function onResize(event:Event):void
      {
         getDimensionRatio(_stage);
      }

      /** @private Computes stage-to-native pixel ratios for banner positioning. */
      private function getDimensionRatio(stage:Stage):void
      {
         var raw:String = _context.call("command", "getNativeDimension") as String;
         if (!raw) return;
         var parts:Array = raw.split("|||");
         var w0:int = parseInt(parts[0], 10);
         var h0:int = parseInt(parts[1], 10);

         if (!isAndroid)
         {
            _ratioWidth = w0 / stage.stageWidth;
            _ratioHeight = h0 / stage.stageHeight;
            return;
         }

         var w1:int = parts.length > 2 ? parseInt(parts[2], 10) : w0;
         var h1:int = parts.length > 3 ? parseInt(parts[3], 10) : h0;
         var maxScreen:Number = Math.max(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
         var minScreen:Number = Math.min(Capabilities.screenResolutionX, Capabilities.screenResolutionY);

         if (stage.stageWidth > stage.stageHeight)
         {
            if (stage.stageWidth == maxScreen && stage.stageHeight == minScreen)
            {
               _ratioWidth = w1 / stage.stageWidth;
               _ratioHeight = h1 / stage.stageHeight;
            }
            else
            {
               _ratioWidth = w0 / stage.stageWidth;
               _ratioHeight = h0 / stage.stageHeight;
            }
         }
         else
         {
            if (stage.stageWidth == minScreen && stage.stageHeight == maxScreen)
            {
               _ratioWidth = w1 / stage.stageWidth;
               _ratioHeight = h1 / stage.stageHeight;
            }
            else
            {
               _ratioWidth = w0 / stage.stageWidth;
               _ratioHeight = h0 / stage.stageHeight;
            }
         }
      }

      /**
       * Underlying AIR {@link flash.external.ExtensionContext} for advanced or debug use.
       */
      public function get context():ExtensionContext { return _context; }
      /** @private Horizontal scale from stage coordinates to native pixels. */
      internal function get ratioWidth():Number { return _ratioWidth; }
      /** @private Vertical scale from stage coordinates to native pixels. */
      internal function get ratioHeight():Number { return _ratioHeight; }
   }
}
