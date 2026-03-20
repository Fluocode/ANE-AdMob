package com.fluocode.admob
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.external.ExtensionContext;
   import flash.system.Capabilities;

   public class AdMob
   {
      internal static const DEMO_ANE:Boolean = false;

      public static const ERROR_CODE_INTERNAL_ERROR:int = 0;
      public static const ERROR_CODE_INVALID_REQUEST:int = 1;
      public static const ERROR_CODE_NETWORK_ERROR:int = 2;
      public static const ERROR_CODE_NO_FILL:int = 3;
      public static const AD_TYPE_BANNER:String = "banner";
      public static const AD_TYPE_INTERSTITIAL:String = "interstitial";
      public static const AD_TYPE_REWARDED_VIDEO:String = "rewardedVideo";

      private static var _ex:AdMob;

      public static const EXTENSION_ID:String = "com.fluocode.admob";
      public static const VERSION:String = "1.0.0";
      public static const IOS_SDK_VERSION:String = "11.0.0";
      public static const ANDROID_SDK_VERSION:String = "23.0.0";

      private var _ratioWidth:Number;
      private var _ratioHeight:Number;
      private var _api:AdMobApi;
      private var _context:ExtensionContext;
      private var _stage:Stage;

      private static function get isAndroid():Boolean
      {
         return Capabilities.os.indexOf("Android") >= 0;
      }

      public function AdMob(stage:Stage, applicationCode:String)
      {
         _stage = stage;
         _context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
         getDimensionRatio(_stage);
         _stage.addEventListener("resize", onResize);
         _api = new AdMobApi(this, _context, applicationCode);
      }

      public static function init(stage:Stage, applicationCode:String = null):AdMob
      {
         if (!applicationCode) applicationCode = "";
         if (!_ex)
            _ex = new AdMob(stage, applicationCode);
         return _ex;
      }

      public static function dispose():void
      {
         if (!_ex) return;
         _ex._stage.removeEventListener("resize", _ex.onResize);
         _ex._api.dispose();
         _ex = null;
      }

      public static function get api():AdMobApi
      {
         return _ex ? _ex._api : null;
      }

      private function onResize(event:Event):void
      {
         getDimensionRatio(_stage);
      }

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

      public function get context():ExtensionContext { return _context; }
      internal function get ratioWidth():Number { return _ratioWidth; }
      internal function get ratioHeight():Number { return _ratioHeight; }
   }
}
