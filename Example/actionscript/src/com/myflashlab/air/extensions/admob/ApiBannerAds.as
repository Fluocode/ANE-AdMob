package com.myflashlab.air.extensions.admob
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
      
      public function ApiBannerAds(param1:AdMob, param2:ExtensionContext)
      {
         super();
         _main = param1;
         _context = param2;
      }
      
      internal function onStatus(param1:StatusEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = param1.code;
         if("onBannerSizeMeasured" === _loc3_)
         {
            _loc2_ = param1.level.split("|||");
            _w = _loc2_[0] / _main.ratioWidth;
            _h = _loc2_[1] / _main.ratioHeight;
            dispatchEvent(new AdMobEvents("onBannerSizeMeasured",null,-1,_w,_h));
         }
      }
      
      public function init(param1:String, param2:int) : void
      {
         _context.call("command","initBanner",param1,param2);
      }
      
      public function loadAd(param1:AdRequest) : void
      {
         _context.call("command","loadBanner",param1.read());
      }
      
      public function dispose() : void
      {
         _context.call("command","disposeBanner");
      }
      
      public function setPosition(param1:int, param2:int) : void
      {
         _x = param1;
         _y = param2;
         _context.call("command","setPosition",_x * _main.ratioWidth,_y * _main.ratioHeight);
      }
      
      public function get visible() : Boolean
      {
         return _visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         _visible = param1;
         _context.call("command","hideBanner",!_visible);
      }
      
      public function get x() : int
      {
         return _x;
      }
      
      public function set x(param1:int) : void
      {
         _x = param1;
         _context.call("command","setPosition",_x * _main.ratioWidth,_y * _main.ratioHeight);
      }
      
      public function get y() : int
      {
         return _y;
      }
      
      public function set y(param1:int) : void
      {
         _y = param1;
         _context.call("command","setPosition",_x * _main.ratioWidth,_y * _main.ratioHeight);
      }
      
      public function get width() : int
      {
         return _w;
      }
      
      public function get height() : int
      {
         return _h;
      }
   }
}
