package com.fluocode.admob
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;

   /**
    * Placeholder for legacy "native express" ad API compatibility.
    * <p>Not implemented in this ANE; kept so existing references compile. No-op {@link #dispose}.</p>
    *
    * @see AdMobApi
    *
    * @langversion 3.0
    * @playerversion AIR 3.0
    */
   public class ApiNativeAdsExpress extends EventDispatcher
   {
      private var _main:AdMob;
      private var _context:ExtensionContext;

      /**
       * @param main      Parent {@link AdMob}.
       * @param context   Extension context (internal).
       */
      public function ApiNativeAdsExpress(main:AdMob, context:ExtensionContext)
      {
         super();
         _main = main;
         _context = context;
      }

      /** @internal */
      internal function onStatus(event:StatusEvent):void { }

      /** No-op; reserved for future native express support. */
      public function dispose():void { }
   }
}
