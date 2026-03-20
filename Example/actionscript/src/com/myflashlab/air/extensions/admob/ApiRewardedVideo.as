package com.myflashlab.air.extensions.admob
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   
   public class ApiRewardedVideo extends EventDispatcher
   {
       
      
      private var _main:AdMob;
      
      private var _context:ExtensionContext;
      
      public function ApiRewardedVideo(admob:AdMob, context:ExtensionContext)
      {
         super();
         _main = admob;
         _context = context;
      }
      
      internal function onStatus(event:StatusEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         switch(param1.code)
         {
            case "onAdBeginPlaying":
               dispatchEvent(new AdMobEvents("onAdBeginPlaying",event.level));
               break;
            case "onAdEndPlaying":
               dispatchEvent(new AdMobEvents("onAdEndPlaying",event.level));
               break;
            case "onAdDeliverReward":
               _loc2_ = event.level.split("|||");
               dispatchEvent(new AdMobEvents("onAdDeliverReward",_loc2_[0],-1,0,0,null,_loc2_[1],_loc2_[2]));
               break;
            case "onMetadataChanged":
               _loc3_ = event.level;
               dispatchEvent(new AdMobEvents("onMetadataChanged",null,-1,0,0,null,null,0,_loc3_));
         }
      }
      
      public function loadAd(param1:AdRequest, param2:String) : void
      {
         _context.call("command","loadRewardedVideo",param1.read(),param2);
      }
      
      public function show() : void
      {
         _context.call("command","showRewardedVideo");
      }
      
      public function dispose() : void
      {
         _context.call("command","disposeRewardedVideo");
      }
      
      public function get isReady() : Boolean
      {
         return _context.call("command","isRewardedVideoReady") as Boolean;
      }
      
      public function get userId() : String
      {
         var _loc1_:* = _context.call("command","rewardedVideoGetUserId") as String;
         if(_loc1_.length < 1)
         {
            _loc1_ = null;
         }
         return _loc1_;
      }
      
      public function set userId(param1:String) : void
      {
         var _loc2_:* = param1;
         if(!_loc2_)
         {
            _loc2_ = "";
         }
         _context.call("command","rewardedVideoSetUserId",_loc2_);
      }
   }
}
