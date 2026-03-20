package com.fluocode.admob
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;

   /**
    * Rewarded video ads (user completes watch flow to earn in-app rewards).
    * <p>Listen on this instance for {@link AdMobEvents#AD_DELIVER_REWARD}, {@link AdMobEvents#AD_BEGIN_PLAYING},
    * etc., when the native layer emits them.</p>
    *
    * @see AdMobApi#rewardedVideo
    *
    * @langversion 3.0
    * @playerversion AIR 3.0
    */
   public class ApiRewardedVideo extends EventDispatcher
   {
      private var _main:AdMob;
      private var _context:ExtensionContext;

      /**
       * @param main      Parent {@link AdMob}.
       * @param context   Extension context (internal).
       */
      public function ApiRewardedVideo(main:AdMob, context:ExtensionContext)
      {
         super();
         _main = main;
         _context = context;
      }

      /** @internal */
      internal function onStatus(event:StatusEvent):void
      {
         var parts:Array;
         switch (event.code)
         {
            case "onAdBeginPlaying":
               dispatchEvent(new AdMobEvents("onAdBeginPlaying", event.level));
               break;
            case "onAdEndPlaying":
               dispatchEvent(new AdMobEvents("onAdEndPlaying", event.level));
               break;
            case "onAdDeliverReward":
               parts = event.level.split("|||");
               dispatchEvent(new AdMobEvents("onAdDeliverReward", parts[0], -1, 0, 0, null, parts[1], Number(parts[2])));
               break;
            case "onMetadataChanged":
               dispatchEvent(new AdMobEvents("onMetadataChanged", null, -1, 0, 0, null, null, 0, event.level));
               break;
         }
      }

      /**
       * Loads a rewarded ad for the given unit.
       *
       * @param request Targeting options.
       * @param unitId  AdMob rewarded ad unit id.
       */
      public function loadAd(request:AdRequest, unitId:String):void
      {
         _context.call("command", "loadRewardedVideo", request.read(), unitId);
      }

      /** Presents the rewarded ad if loaded. */
      public function show():void
      {
         _context.call("command", "showRewardedVideo");
      }

      /** Releases native rewarded ad resources. */
      public function dispose():void
      {
         _context.call("command", "disposeRewardedVideo");
      }

      /**
       * @return <code>true</code> if a rewarded ad is loaded and can be shown.
       */
      public function get isReady():Boolean
      {
         return _context.call("command", "isRewardedVideoReady") as Boolean;
      }

      /**
       * Rewarded user id forwarded to the network when supported.
       * @return Current id, or <code>null</code> if unset/empty.
       */
      public function get userId():String
      {
         var s:String = _context.call("command", "rewardedVideoGetUserId") as String;
         return (s && s.length > 0) ? s : null;
      }

      /**
       * Sets the rewarded user id for server-side verification flows.
       * @param value User id string, or <code>null</code> to clear.
       */
      public function set userId(value:String):void
      {
         _context.call("command", "rewardedVideoSetUserId", value ? value : "");
      }
   }
}
