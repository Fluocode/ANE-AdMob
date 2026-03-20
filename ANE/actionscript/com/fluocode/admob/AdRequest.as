package com.fluocode.admob
{
   import flash.geom.Point;

   public class AdRequest
   {
      public static const MAX_AD_CONTENT_RATING_G:String = "G";
      public static const MAX_AD_CONTENT_RATING_MA:String = "MA";
      public static const MAX_AD_CONTENT_RATING_PG:String = "PG";
      public static const MAX_AD_CONTENT_RATING_T:String = "T";
      public static const TAG_FOR_UNDER_AGE_OF_CONSENT_FALSE:int = 0;
      public static const TAG_FOR_UNDER_AGE_OF_CONSENT_TRUE:int = 1;
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

      public function AdRequest()
      {
         _keywords = [];
         _testDevices = [];
      }

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

      public function get keywords():Array { return _keywords; }
      public function set keywords(value:Array):void { _keywords = value; }
      public function get testDevices():Array { return _testDevices; }
      public function set testDevices(value:Array):void { _testDevices = value; }
      public function get contentUrl():String { return _contentUrl; }
      public function set contentUrl(value:String):void { _contentUrl = value; }
      public function get location():Point { return _location; }
      public function set location(value:Point):void { _location = value; }
      public function get requestAgent():String { return _requestAgent; }
      public function set requestAgent(value:String):void { _requestAgent = value; }
      public function get tagForChildDirectedTreatment():Boolean { return _tagForChildDirectedTreatment; }
      public function set tagForChildDirectedTreatment(value:Boolean):void { _tagForChildDirectedTreatment = value; }
      public function get maxAdContentRating():String { return _maxAdContentRating; }
      public function set maxAdContentRating(value:String):void { _maxAdContentRating = value; }
      public function get tagForUnderAgeOfConsent():int { return _tagForUnderAgeOfConsent; }
      public function set tagForUnderAgeOfConsent(value:int):void { _tagForUnderAgeOfConsent = value; }
      public function get extras():Object { return _extras; }
      public function set extras(value:Object):void { _extras = value; }
   }
}
