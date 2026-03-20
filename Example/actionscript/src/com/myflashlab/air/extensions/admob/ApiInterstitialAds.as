package com.myflashlab.air.extensions.admob
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   public class ApiInterstitialAds extends EventDispatcher
   {
       
      
      private var _main:AdMob;
      
      private var _context:ExtensionContext;
      
      public function ApiInterstitialAds(param1:AdMob, param2:ExtensionContext)
      {
         super();
         _main = param1;
         _context = param2;
      }
      
      internal function onStatus(param1:StatusEvent) : void
      {
      }
      
      public function init(param1:String) : void
      {
         _context.call("command","initInterstitial",param1);
      }
      
      public function loadAd(param1:AdRequest) : void
      {
         _context.call("command","loadInterstitial",param1.read());
      }
      
      public function dispose() : void
      {
         _context.call("command","disposeInterstitial");
      }
      
      public function show() : void
      {
         _context.call("command","showInterstitial");
      }
      
      public function get isLoaded() : Boolean
      {
         return _context.call("command","isInterstitialLoaded") as Boolean;
      }
   }
}
