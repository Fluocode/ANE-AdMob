package com.fluocode.admob
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;

   public class ApiNativeAdsExpress extends EventDispatcher
   {
      private var _main:AdMob;
      private var _context:ExtensionContext;

      public function ApiNativeAdsExpress(main:AdMob, context:ExtensionContext)
      {
         super();
         _main = main;
         _context = context;
      }

      internal function onStatus(event:StatusEvent):void { }

      public function dispose():void { }
   }
}
