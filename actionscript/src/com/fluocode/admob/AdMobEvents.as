package com.fluocode.admob
{
   import flash.events.Event;

   /**
    * Typed event dispatched by {@link AdMobApi} and subclasses for ad lifecycle, errors, and rewards.
    * <p>Use the static string constants for {@link flash.events.Event#type} when adding listeners.</p>
    *
    * @see AdMobApi#addEventListener
    *
    * @langversion 3.0
    * @playerversion AIR 3.0
    */
   public class AdMobEvents extends Event
   {
      /** Event type: ad was closed (full-screen dismissed or equivalent). {@link #adType} holds placement. */
      public static const AD_CLOSED:String = "onAdClosed";
      /** Event type: load or show failed. See {@link #msg}, {@link #errorCode}, {@link #adType}. */
      public static const AD_FAILED:String = "onAdFailed";
      /** Event type: user left the app (e.g. click-through). {@link #adType} may indicate placement. */
      public static const AD_LEFT_APP:String = "onAdLeftApp";
      /** Event type: ad opened / presented. */
      public static const AD_OPENED:String = "onAdOpened";
      /** Event type: ad loaded successfully. {@link #adType} identifies banner, interstitial, or rewarded. */
      public static const AD_LOADED:String = "onAdLoaded";
      /** Event type: rewarded content started playback (platform-dependent). */
      public static const AD_BEGIN_PLAYING:String = "onAdBeginPlaying";
      /** Event type: rewarded content finished playback (platform-dependent). */
      public static const AD_END_PLAYING:String = "onAdEndPlaying";
      /** Event type: user earned reward. See {@link #rewardType} and {@link #rewardAmount}. */
      public static const AD_DELIVER_REWARD:String = "onAdDeliverReward";
      /** Event type: native measured banner size. See {@link #width} and {@link #height} in stage units. */
      public static const SIZE_MEASURED:String = "onBannerSizeMeasured";
      /** Event type: ad metadata changed (platform-dependent). See {@link #metadata}. */
      public static const METADATA_CHANGED:String = "onMetadataChanged";

      private var _adType:String;
      private var _errorCode:int;
      private var _width:int;
      private var _height:int;
      private var _msg:String;
      private var _rewardType:String;
      private var _rewardAmount:Number;
      private var _metadata:String;

      /**
       * @param type           Event type string ({@link #AD_LOADED}, etc.).
       * @param adType         Logical ad slot type (e.g. {@link AdMob#AD_TYPE_BANNER}).
       * @param errorCode      Native error code when type is {@link #AD_FAILED}; otherwise often <code>-1</code>.
       * @param width          Measured width for {@link #SIZE_MEASURED} (stage-related units).
       * @param height         Measured height for {@link #SIZE_MEASURED}.
       * @param msg            Human-readable failure message for {@link #AD_FAILED}.
       * @param rewardType     Reward currency type for {@link #AD_DELIVER_REWARD}.
       * @param rewardAmount   Reward amount for {@link #AD_DELIVER_REWARD}.
       * @param metadata       Opaque metadata string for {@link #METADATA_CHANGED}.
       */
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

      /** Ad placement / type string from native layer. */
      public function get adType():String { return _adType; }
      /** Numeric error code when applicable (e.g. failed load). */
      public function get errorCode():int { return _errorCode; }
      /** Banner width after measurement (see {@link #SIZE_MEASURED}). */
      public function get width():int { return _width; }
      /** Banner height after measurement (see {@link #SIZE_MEASURED}). */
      public function get height():int { return _height; }
      /** Error or diagnostic message. */
      public function get msg():String { return _msg; }
      /** Reward type identifier for rewarded ads. */
      public function get rewardType():String { return _rewardType; }
      /** Reward amount for rewarded ads. */
      public function get rewardAmount():Number { return _rewardAmount; }
      /** Opaque metadata for advanced native callbacks. */
      public function get metadata():String { return _metadata; }
   }
}
