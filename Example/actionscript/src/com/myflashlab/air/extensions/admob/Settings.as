package com.myflashlab.air.extensions.admob
{
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   public class Settings
   {
       
      
      private var _context:ExtensionContext;
      
      public function Settings(param1:ExtensionContext)
      {
         super();
         _context = param1;
      }
      
      internal function onStatus(param1:StatusEvent) : void
      {
      }
      
      internal function dispose() : void
      {
      }
      
      public function setAppMuted(param1:Boolean) : void
      {
         _context.call("command","MobileAdsSetAppMuted",param1);
      }
      
      public function setAppVolume(param1:Number) : void
      {
         _context.call("command","MobileAdsSetAppVolume",param1);
      }
   }
}
