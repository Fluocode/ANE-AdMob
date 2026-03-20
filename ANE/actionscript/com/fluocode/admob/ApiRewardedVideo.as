package com.fluocode.admob
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;

   public class ApiRewardedVideo extends EventDispatcher
   {
      private var _main:AdMob;
      private var _context:ExtensionContext;

      public function ApiRewardedVideo(main:AdMob, context:ExtensionContext)
      {
         super();
         _main = main;
         _context = context;
      }

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

      public function loadAd(request:AdRequest, unitId:String):void
      {
         _context.call("command", "loadRewardedVideo", request.read(), unitId);
      }

      public function show():void
      {
         _context.call("command", "showRewardedVideo");
      }

      public function dispose():void
      {
         _context.call("command", "disposeRewardedVideo");
      }

      public function get isReady():Boolean
      {
         return _context.call("command", "isRewardedVideoReady") as Boolean;
      }

      public function get userId():String
      {
         var s:String = _context.call("command", "rewardedVideoGetUserId") as String;
         return (s && s.length > 0) ? s : null;
      }

      public function set userId(value:String):void
      {
         _context.call("command", "rewardedVideoSetUserId", value ? value : "");
      }
   }
}
