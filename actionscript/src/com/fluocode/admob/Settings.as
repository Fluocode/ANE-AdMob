package com.fluocode.admob
{
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;

   /**
    * Global audio preferences for the Google Mobile Ads SDK in your application.
    *
    * @see AdMobApi#settings
    *
    * @langversion 3.0
    * @playerversion AIR 3.0
    */
   public class Settings
   {
      private var _context:ExtensionContext;

      /**
       * @param context  Extension context (internal).
       */
      public function Settings(context:ExtensionContext)
      {
         _context = context;
      }

      /** @internal */
      internal function onStatus(event:StatusEvent):void { }

      /** @internal */
      internal function dispose():void { }

      /**
       * Mutes all ads relative to the application (platform-specific behavior).
       *
       * @param value <code>true</code> to mute; <code>false</code> to allow sound.
       */
      public function setAppMuted(value:Boolean):void
      {
         _context.call("command", "MobileAdsSetAppMuted", value);
      }

      /**
       * Sets application volume for ads (0.0–1.0 typical range; see native SDK docs).
       *
       * @param value Volume level.
       */
      public function setAppVolume(value:Number):void
      {
         _context.call("command", "MobileAdsSetAppVolume", value);
      }
   }
}
