package com.myflashlab.air.extensions.admob
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
         super();
      }
      
      internal function read() : String
      {
         var _loc1_:* = {};
         if(!_keywords)
         {
            _keywords = [];
         }
         _loc1_.keywords = _keywords;
         if(!_testDevices)
         {
            _testDevices = [];
         }
         _loc1_.testDevices = _testDevices;
         if(!_contentUrl)
         {
            _contentUrl = "";
         }
         _loc1_.contentUrl = _contentUrl;
         if(!_location)
         {
            _location = new Point(-1,-1);
         }
         _loc1_.lat = _location.x;
         _loc1_.lng = _location.y;
         if(!_requestAgent)
         {
            _requestAgent = "";
         }
         _loc1_.requestAgent = _requestAgent;
         _loc1_.tagForChildDirectedTreatment = _tagForChildDirectedTreatment;
         if(!_maxAdContentRating)
         {
            _maxAdContentRating = "";
         }
         _loc1_.maxAdContentRating = _maxAdContentRating;
         _loc1_.tagForUnderAgeOfConsent = _tagForUnderAgeOfConsent;
         if(_extras)
         {
            _loc1_.extras = _extras;
         }
         return JSON.stringify(_loc1_);
      }
      
      public function get extras() : Object
      {
         return _extras;
      }
      
      public function set extras(param1:Object) : void
      {
         _extras = param1;
      }
      
      public function get tagForChildDirectedTreatment() : Boolean
      {
         return _tagForChildDirectedTreatment;
      }
      
      public function set tagForChildDirectedTreatment(param1:Boolean) : void
      {
         _tagForChildDirectedTreatment = param1;
      }
      
      public function get requestAgent() : String
      {
         return _requestAgent;
      }
      
      public function set requestAgent(param1:String) : void
      {
         _requestAgent = param1;
      }
      
      public function get location() : Point
      {
         return _location;
      }
      
      public function set location(param1:Point) : void
      {
         _location = param1;
      }
      
      public function get contentUrl() : String
      {
         return _contentUrl;
      }
      
      public function set contentUrl(param1:String) : void
      {
         _contentUrl = param1;
      }
      
      public function get keywords() : Array
      {
         return _keywords;
      }
      
      public function set keywords(param1:Array) : void
      {
         _keywords = param1;
      }
      
      public function get testDevices() : Array
      {
         return _testDevices;
      }
      
      public function set testDevices(param1:Array) : void
      {
         _testDevices = param1;
      }
      
      public function set maxAdContentRating(param1:String) : void
      {
         _maxAdContentRating = param1;
      }
      
      public function get maxAdContentRating() : String
      {
         return _maxAdContentRating;
      }
      
      public function set tagForUnderAgeOfConsent(param1:int) : void
      {
         _tagForUnderAgeOfConsent = param1;
      }
      
      public function get tagForUnderAgeOfConsent() : int
      {
         return _tagForUnderAgeOfConsent;
      }
   }
}
