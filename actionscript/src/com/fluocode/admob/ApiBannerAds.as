package com.fluocode.admob
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;

   /**
    * Banner and adaptive banner ads anchored in native coordinates mapped from the AIR stage.
    * <p>Listen for {@link AdMobEvents#SIZE_MEASURED} on this instance after layout.</p>
    *
    * @see AdMobApi#banner
    * @see AdMobEvents#SIZE_MEASURED
    *
    * @langversion 3.0
    * @playerversion AIR 3.0
    */
   public class ApiBannerAds extends EventDispatcher
   {
      /** Standard banner size preset id (pass to {@link #init}). */
      public static const BANNER:int = 1;
      /** Full banner preset. */
      public static const FULL_BANNER:int = 2;
      /** Large banner preset. */
      public static const LARGE_BANNER:int = 3;
      /** Leaderboard preset. */
      public static const LEADERBOARD:int = 4;
      /** Medium rectangle (300x250 class) preset. */
      public static const MEDIUM_RECTANGLE:int = 5;
      /** Wide skyscraper preset. */
      public static const WIDE_SKYSCRAPER:int = 6;
      /** Smart banner (portrait orientation). */
      public static const SMART_BANNER_PORTRAIT:int = 7;
      /** Smart banner (landscape orientation). */
      public static const SMART_BANNER_LANDSCAPE:int = 8;
      /** Adaptive banner sized to current width. */
      public static const ADAPTIVE_BANNER:int = 9;

      private var _visible:Boolean = true;
      private var _x:int = 0;
      private var _y:int = 0;
      private var _w:int = 0;
      private var _h:int = 0;
      private var _main:AdMob;
      private var _context:ExtensionContext;

      /**
       * @param main      Parent {@link AdMob} (for pixel ratios).
       * @param context   Extension context (internal).
       */
      public function ApiBannerAds(main:AdMob, context:ExtensionContext)
      {
         super();
         _main = main;
         _context = context;
      }

      /** @internal */
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

      /**
       * Creates the native banner view for the given ad unit and size preset.
       *
       * @param unitId  AdMob ad unit id (e.g. <code>ca-app-pub-xxx/yyy</code>).
       * @param adSize  One of {@link #BANNER}, {@link #ADAPTIVE_BANNER}, etc.
       */
      public function init(unitId:String, adSize:int):void
      {
         _context.call("command", "initBanner", unitId, adSize);
      }

      /**
       * Requests an ad using targeting data from {@link AdRequest}.
       *
       * @param request Targeting options; serialized via {@link AdRequest#read}.
       */
      public function loadAd(request:AdRequest):void
      {
         _context.call("command", "loadBanner", request.read());
      }

      /** Removes the banner from the view hierarchy and releases native resources. */
      public function dispose():void
      {
         _context.call("command", "disposeBanner");
      }

      /**
       * Positions the banner in stage-space (converted to native pixels internally).
       *
       * @param x   Horizontal origin in stage units.
       * @param y   Vertical origin in stage units.
       */
      public function setPosition(x:int, y:int):void
      {
         _x = x;
         _y = y;
         _context.call("command", "setPosition", _x * _main.ratioWidth, _y * _main.ratioHeight);
      }

      /** When <code>false</code>, the banner is hidden at the native layer. */
      public function get visible():Boolean { return _visible; }
      /**
       * @param value <code>true</code> to show; <code>false</code> to hide without disposing.
       */
      public function set visible(value:Boolean):void
      {
         _visible = value;
         _context.call("command", "hideBanner", !_visible);
      }

      /** Current horizontal position in stage units (updated by setters). */
      public function get x():int { return _x; }
      /** @param value Stage X; triggers native reposition. */
      public function set x(value:int):void { _x = value; _context.call("command", "setPosition", _x * _main.ratioWidth, _y * _main.ratioHeight); }
      /** Current vertical position in stage units. */
      public function get y():int { return _y; }
      /** @param value Stage Y; triggers native reposition. */
      public function set y(value:int):void { _y = value; _context.call("command", "setPosition", _x * _main.ratioWidth, _y * _main.ratioHeight); }
      /** Last measured banner width in stage units (after {@link AdMobEvents#SIZE_MEASURED}). */
      public function get width():int { return _w; }
      /** Last measured banner height in stage units. */
      public function get height():int { return _h; }
   }
}
