package com.myflashlab.air.extensions.admob
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
      
      public function AdMobEvents(param1:String, param2:String = null, param3:int = -1, param4:int = 0, param5:int = 0, param6:String = null, param7:String = null, param8:Number = 0, param9:String = null)
      {
         _adType = param2;
         _errorCode = param3;
         _width = param4;
         _height = param5;
         _msg = param6;
         _rewardType = param7;
         _rewardAmount = param8;
         _metadata = param9;
         super(param1,false,false);
      }
      
      public function get metadata() : String
      {
         return _metadata;
      }
      
      public function get rewardAmount() : Number
      {
         return _rewardAmount;
      }
      
      public function get rewardType() : String
      {
         return _rewardType;
      }
      
      public function get msg() : String
      {
         return _msg;
      }
      
      public function get adType() : String
      {
         return _adType;
      }
      
      public function get errorCode() : int
      {
         return _errorCode;
      }
      
      public function get width() : int
      {
         return _width;
      }
      
      public function get height() : int
      {
         return _height;
      }
   }
}
