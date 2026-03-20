package com.fluocode.admob
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;

   public class ApiInterstitialAds extends EventDispatcher
   {
      private var _main:AdMob;
      private var _context:ExtensionContext;

      public function ApiInterstitialAds(main:AdMob, context:ExtensionContext)
      {
         super();
         _main = main;
         _context = context;
      }

      internal function onStatus(event:StatusEvent):void { }

      public function init(unitId:String):void
      {
         _context.call("command", "initInterstitial", unitId);
      }

      public function loadAd(request:AdRequest):void
      {
         _context.call("command", "loadInterstitial", request.read());
      }

      public function dispose():void
      {
         _context.call("command", "disposeInterstitial");
      }

      public function show():void
      {
         _context.call("command", "showInterstitial");
      }

      public function get isLoaded():Boolean
      {
         return _context.call("command", "isInterstitialLoaded") as Boolean;
      }
   }
}
