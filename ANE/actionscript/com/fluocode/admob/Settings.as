package com.fluocode.admob
{
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;

   public class Settings
   {
      private var _context:ExtensionContext;

      public function Settings(context:ExtensionContext)
      {
         _context = context;
      }

      internal function onStatus(event:StatusEvent):void { }

      internal function dispose():void { }

      public function setAppMuted(value:Boolean):void
      {
         _context.call("command", "MobileAdsSetAppMuted", value);
      }

      public function setAppVolume(value:Number):void
      {
         _context.call("command", "MobileAdsSetAppVolume", value);
      }
   }
}
