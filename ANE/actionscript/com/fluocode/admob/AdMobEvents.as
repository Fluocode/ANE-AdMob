package com.fluocode.admob
{
   import flash.events.Event;

   public class AdMobEvents extends Event
   {
      public static const AD_CLOSED:String = "onAdClosed";
      public static const AD_FAILED:String = "onAdFailed";
      public static const AD_LEFT_APP:String = "onAdLeftApp";
      public static const AD_OPENED:String = "onAdOpened";
      public static const AD_LOADED:String = "onAdLoaded";
      public static const AD_BEGIN_PLAYING:String = "onAdBeginPlaying";
      public static const AD_END_PLAYING:String = "onAdEndPlaying";
      public static const AD_DELIVER_REWARD:String = "onAdDeliverReward";
      public static const SIZE_MEASURED:String = "onBannerSizeMeasured";
      public static const METADATA_CHANGED:String = "onMetadataChanged";

      private var _adType:String;
      private var _errorCode:int;
      private var _width:int;
      private var _height:int;
      private var _msg:String;
      private var _rewardType:String;
      private var _rewardAmount:Number;
      private var _metadata:String;

      public function AdMobEvents(type:String, adType:String = null, errorCode:int = -1, width:int = 0, height:int = 0, msg:String = null, rewardType:String = null, rewardAmount:Number = 0, metadata:String = null)
      {
         _adType = adType;
         _errorCode = errorCode;
         _width = width;
         _height = height;
         _msg = msg;
         _rewardType = rewardType;
         _rewardAmount = rewardAmount;
         _metadata = metadata;
         super(type, false, false);
      }

      public function get adType():String { return _adType; }
      public function get errorCode():int { return _errorCode; }
      public function get width():int { return _width; }
      public function get height():int { return _height; }
      public function get msg():String { return _msg; }
      public function get rewardType():String { return _rewardType; }
      public function get rewardAmount():Number { return _rewardAmount; }
      public function get metadata():String { return _metadata; }
   }
}
