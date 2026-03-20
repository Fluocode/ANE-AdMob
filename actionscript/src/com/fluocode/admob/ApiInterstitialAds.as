package com.fluocode.admob
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;

   /**
    * Full-screen interstitial ads.
    * <p>Typical flow: {@link #init} with unit id, {@link #loadAd}, then {@link #show} when {@link #isLoaded} is true.
    * Listen on {@link AdMobApi} for {@link AdMobEvents#AD_LOADED} / {@link AdMobEvents#AD_CLOSED} with
    * {@link AdMob#AD_TYPE_INTERSTITIAL}.</p>
    *
    * @see AdMobApi#interstitial
    *
    * @langversion 3.0
    * @playerversion AIR 3.0
    */
   public class ApiInterstitialAds extends EventDispatcher
   {
      private var _main:AdMob;
      private var _context:ExtensionContext;

      /**
       * @param main      Parent {@link AdMob}.
       * @param context   Extension context (internal).
       */
      public function ApiInterstitialAds(main:AdMob, context:ExtensionContext)
      {
         super();
         _main = main;
         _context = context;
      }

      /** @internal */
      internal function onStatus(event:StatusEvent):void { }

      /**
       * Associates an interstitial slot with the given ad unit id for subsequent loads.
       *
       * @param unitId  AdMob interstitial ad unit id.
       */
      public function init(unitId:String):void
      {
         _context.call("command", "initInterstitial", unitId);
      }

      /**
       * Loads an interstitial ad for the current unit id.
       *
       * @param request Targeting options.
       */
      public function loadAd(request:AdRequest):void
      {
         _context.call("command", "loadInterstitial", request.read());
      }

      /** Releases the current interstitial object at the native layer. */
      public function dispose():void
      {
         _context.call("command", "disposeInterstitial");
      }

      /** Presents the loaded interstitial if available (no-op or error if not ready — check {@link #isLoaded}). */
      public function show():void
      {
         _context.call("command", "showInterstitial");
      }

      /**
       * @return <code>true</code> if an interstitial is loaded and ready to show.
       */
      public function get isLoaded():Boolean
      {
         return _context.call("command", "isInterstitialLoaded") as Boolean;
      }
   }
}
