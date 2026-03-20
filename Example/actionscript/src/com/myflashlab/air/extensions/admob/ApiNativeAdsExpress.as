package com.myflashlab.air.extensions.admob
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   public class ApiNativeAdsExpress extends EventDispatcher
   {
       
      
      private var _main:AdMob;
      
      private var _context:ExtensionContext;
      
      public function ApiNativeAdsExpress(param1:AdMob, param2:ExtensionContext)
      {
         super();
         _main = param1;
         _context = param2;
      }
      
      internal function onStatus(param1:StatusEvent) : void
      {
      }
      
      public function dispose() : void
      {
      }
   }
}
