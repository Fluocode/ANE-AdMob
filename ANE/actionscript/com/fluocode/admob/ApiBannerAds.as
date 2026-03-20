package com.fluocode.admob
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;

   public class ApiBannerAds extends EventDispatcher
   {
      public static const BANNER:int = 1;
      public static const FULL_BANNER:int = 2;
      public static const LARGE_BANNER:int = 3;
      public static const LEADERBOARD:int = 4;
      public static const MEDIUM_RECTANGLE:int = 5;
      public static const WIDE_SKYSCRAPER:int = 6;
      public static const SMART_BANNER_PORTRAIT:int = 7;
      public static const SMART_BANNER_LANDSCAPE:int = 8;
      public static const ADAPTIVE_BANNER:int = 9;

      private var _visible:Boolean = true;
      private var _x:int = 0;
      private var _y:int = 0;
      private var _w:int = 0;
      private var _h:int = 0;
      private var _main:AdMob;
      private var _context:ExtensionContext;

      public function ApiBannerAds(main:AdMob, context:ExtensionContext)
      {
         super();
         _main = main;
         _context = context;
      }

      internal function onStatus(event:StatusEvent):void
      {
         if (event.code === "onBannerSizeMeasured")
         {
            var parts:Array = event.level.split("|||");
            _w = Number(parts[0]) / _main.ratioWidth;
            _h = Number(parts[1]) / _main.ratioHeight;
            dispatchEvent(new AdMobEvents("onBannerSizeMeasured", null, -1, _w, _h));
         }
      }

      public function init(unitId:String, adSize:int):void
      {
         _context.call("command", "initBanner", unitId, adSize);
      }

      public function loadAd(request:AdRequest):void
      {
         _context.call("command", "loadBanner", request.read());
      }

      public function dispose():void
      {
         _context.call("command", "disposeBanner");
      }

      public function setPosition(x:int, y:int):void
      {
         _x = x;
         _y = y;
         _context.call("command", "setPosition", _x * _main.ratioWidth, _y * _main.ratioHeight);
      }

      public function get visible():Boolean { return _visible; }
      public function set visible(value:Boolean):void
      {
         _visible = value;
         _context.call("command", "hideBanner", !_visible);
      }

      public function get x():int { return _x; }
      public function set x(value:int):void { _x = value; _context.call("command", "setPosition", _x * _main.ratioWidth, _y * _main.ratioHeight); }
      public function get y():int { return _y; }
      public function set y(value:int):void { _y = value; _context.call("command", "setPosition", _x * _main.ratioWidth, _y * _main.ratioHeight); }
      public function get width():int { return _w; }
      public function get height():int { return _h; }
   }
}
