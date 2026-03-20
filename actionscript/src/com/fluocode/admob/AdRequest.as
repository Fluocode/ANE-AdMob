package com.fluocode.admob
{
   import flash.geom.Point;

   /**
    * Builder for ad request targeting options passed to native code as JSON.
    * <p>Use {@link #read} internally when calling {@link ApiBannerAds#loadAd} or similar.</p>
    *
    * @see ApiBannerAds#loadAd
    * @see ApiInterstitialAds#loadAd
    * @see ApiRewardedVideo#loadAd
    *
    * @langversion 3.0
    * @playerversion AIR 3.0
    */
   public class AdRequest
   {
      /** Maximum content rating: General audiences. */
      public static const MAX_AD_CONTENT_RATING_G:String = "G";
      /** Maximum content rating: Mature audiences. */
      public static const MAX_AD_CONTENT_RATING_MA:String = "MA";
      /** Maximum content rating: Parental guidance. */
      public static const MAX_AD_CONTENT_RATING_PG:String = "PG";
      /** Maximum content rating: Teen. */
      public static const MAX_AD_CONTENT_RATING_T:String = "T";
      /** Under-age consent flag: false. */
      public static const TAG_FOR_UNDER_AGE_OF_CONSENT_FALSE:int = 0;
      /** Under-age consent flag: true. */
      public static const TAG_FOR_UNDER_AGE_OF_CONSENT_TRUE:int = 1;
      /** Under-age consent flag: unspecified (default). */
      public static const TAG_FOR_UNDER_AGE_OF_CONSENT_UNSPECIFIED:int = -1;

      private var _keywords:Array;
      private var _testDevices:Array;
      private var _contentUrl:String = null;
      private var _location:Point = null;
      private var _requestAgent:String = null;
      private var _tagForChildDirectedTreatment:Boolean = false;
      private var _extras:Object;
      private var _maxAdContentRating:String;
      private var _tagForUnderAgeOfConsent:int = -1;

      /** Creates an empty request with default arrays for keywords and test devices. */
      public function AdRequest()
      {
         _keywords = [];
         _testDevices = [];
      }

      /**
       * Serializes this request to a JSON string for the native extension.
       *
       * @return JSON payload consumed by Android/iOS handlers.
       * @internal Used by API classes; not typically called from application code.
       */
      internal function read():String
      {
         var o:Object = {};
         o.keywords = _keywords || [];
         o.testDevices = _testDevices || [];
         o.contentUrl = _contentUrl || "";
         o.lat = _location ? _location.x : -1;
         o.lng = _location ? _location.y : -1;
         o.requestAgent = _requestAgent || "";
         o.tagForChildDirectedTreatment = _tagForChildDirectedTreatment;
         o.maxAdContentRating = _maxAdContentRating || "";
         o.tagForUnderAgeOfConsent = _tagForUnderAgeOfConsent;
         if (_extras) o.extras = _extras;
         return JSON.stringify(o);
      }

      /** Optional keywords for ad targeting. */
      public function get keywords():Array { return _keywords; }
      /** @param value Keyword list, or <code>null</code> to clear. */
      public function set keywords(value:Array):void { _keywords = value; }
      /** Device or emulator ids to receive test ads (platform-specific strings). */
      public function get testDevices():Array { return _testDevices; }
      /** @param value Test device id list, or <code>null</code> to clear. */
      public function set testDevices(value:Array):void { _testDevices = value; }
      /** Content URL for brand safety / contextual signals. */
      public function get contentUrl():String { return _contentUrl; }
      /** @param value URL string, or <code>null</code> for none. */
      public function set contentUrl(value:String):void { _contentUrl = value; }
      /** Approximate user location; use <code>(-1,-1)</code> in {@link #read} when unset. */
      public function get location():Point { return _location; }
      /** @param value Geo coordinates, or <code>null</code> to omit. */
      public function set location(value:Point):void { _location = value; }
      /** Custom request agent string if required by mediation. */
      public function get requestAgent():String { return _requestAgent; }
      /** @param value Agent string, or <code>null</code> for default. */
      public function set requestAgent(value:String):void { _requestAgent = value; }
      /** Whether the request is for child-directed treatment. */
      public function get tagForChildDirectedTreatment():Boolean { return _tagForChildDirectedTreatment; }
      /** @param value COPPA-directed treatment flag. */
      public function set tagForChildDirectedTreatment(value:Boolean):void { _tagForChildDirectedTreatment = value; }
      /** Max ad content rating; use {@link #MAX_AD_CONTENT_RATING_G} and related constants. */
      public function get maxAdContentRating():String { return _maxAdContentRating; }
      /** @param value Rating string, or <code>null</code> for default. */
      public function set maxAdContentRating(value:String):void { _maxAdContentRating = value; }
      /** Under-age of consent flag; see {@link #TAG_FOR_UNDER_AGE_OF_CONSENT_UNSPECIFIED} etc. */
      public function get tagForUnderAgeOfConsent():int { return _tagForUnderAgeOfConsent; }
      /** @param value Consent flag constant. */
      public function set tagForUnderAgeOfConsent(value:int):void { _tagForUnderAgeOfConsent = value; }
      /** Optional key-value extras forwarded to mediation (string values in native layer). */
      public function get extras():Object { return _extras; }
      /** @param value Plain object map, or <code>null</code> to omit extras. */
      public function set extras(value:Object):void { _extras = value; }
   }
}
