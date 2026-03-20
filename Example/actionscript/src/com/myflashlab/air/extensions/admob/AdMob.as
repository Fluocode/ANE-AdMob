package com.myflashlab.air.extensions.admob
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.external.ExtensionContext;
   import flash.system.Capabilities;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class AdMob
   {
      
      internal static const DEMO_ANE:Boolean = false;
      
      public static const ERROR_CODE_INTERNAL_ERROR:int = 0;
      
      public static const ERROR_CODE_INVALID_REQUEST:int = 1;
      
      public static const ERROR_CODE_NETWORK_ERROR:int = 2;
      
      public static const ERROR_CODE_NO_FILL:int = 3;
      
      public static const AD_TYPE_BANNER:String = "banner";
      
      public static const AD_TYPE_INTERSTITIAL:String = "interstitial";
      
      public static const AD_TYPE_REWARDED_VIDEO:String = "rewardedVideo";
      
      private static var _ex:AdMob;
      
      public static const EXTENSION_ID:String = "com.myflashlab.air.extensions.admob";
      
      public static const VERSION:String = "6.2.0";
      
      public static const IOS_SDK_VERSION:String = "7.63.0";
      
      public static const ANDROID_SDK_VERSION:String = "19.2.0";
       
      
      private var _ratioWidth:Number;
      
      private var _ratioHeight:Number;
      
      private var OverrideClass:Class;
      
      private var _api:AdMobApi;
      
      private var _context:ExtensionContext;
      
      private var _stage:Stage;
      
      public function AdMob($stage:Stage, $applicationCode:String)
      {
         super();
         OverrideClass = getDefinitionByName("com.myflashlab.air.extensions.dependency.OverrideAir") as Class;
         OverrideClass["applyToAneLab"](getQualifiedClassName(this));
         _stage = $stage;
         _context = ExtensionContext.createExtensionContext("com.myflashlab.air.extensions.admob",null);
         getDimensionRatio(_stage);
         _stage.addEventListener("resize",onResize);
         _api = new AdMobApi(this,_context,$applicationCode);
      }
      
      public static function init($stage:Stage, $applicationCode:String = null) : AdMob
      {
         if(!$applicationCode)
         {
            $applicationCode = "";
         }
         if(!_ex)
         {
            _ex = new AdMob($stage,$applicationCode);
         }
         return _ex;
      }
      
      public static function dispose() : void
      {
         if(!_ex)
         {
            return;
         }
         _ex._stage.addEventListener("resize",_ex.onResize);
         _ex._api.dispose();
         _ex = null;
      }
      
      public static function get api() : AdMobApi
      {
         if(!_ex)
         {
            return null;
         }
         return _ex._api;
      }
      
      private function onResize(param1:Event) : void
      {
         getDimensionRatio(_stage);
      }
      
      private function getDimensionRatio(param1:Stage) : void
      {
         var _loc7_:String = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(OverrideClass["os"] != OverrideClass["ANDROID"])
         {
            _loc2_ = (_loc7_ = _context.call("command","getNativeDimension") as String).split("|||");
            _loc3_ = parseInt(_loc2_[0],10);
            _loc6_ = parseInt(_loc2_[1],10);
            _ratioWidth = _loc3_ / param1.stageWidth;
            _ratioHeight = _loc6_ / param1.stageHeight;
         }
         else
         {
            _loc2_ = (_loc7_ = _context.call("command","getNativeDimension") as String).split("|||");
            _loc3_ = parseInt(_loc2_[0],10);
            _loc6_ = parseInt(_loc2_[1],10);
            _loc4_ = parseInt(_loc2_[2],10);
            _loc5_ = parseInt(_loc2_[3],10);
            if(param1.stageWidth > param1.stageHeight)
            {
               trace(param1.stageWidth + " ... " + Math.max(Capabilities.screenResolutionX,Capabilities.screenResolutionY));
               trace(param1.stageHeight + " ... " + Math.min(Capabilities.screenResolutionX,Capabilities.screenResolutionY));
               if(param1.stageWidth == Math.max(Capabilities.screenResolutionX,Capabilities.screenResolutionY) && param1.stageHeight == Math.min(Capabilities.screenResolutionX,Capabilities.screenResolutionY))
               {
                  _ratioWidth = _loc4_ / param1.stageWidth;
                  _ratioHeight = _loc5_ / param1.stageHeight;
                  trace("real ratio: " + _ratioWidth + "x" + _ratioHeight);
               }
               else
               {
                  _ratioWidth = _loc3_ / param1.stageWidth;
                  _ratioHeight = _loc6_ / param1.stageHeight;
                  trace("visible ratio: " + _ratioWidth + "x" + _ratioHeight);
               }
            }
            else
            {
               trace(param1.stageWidth + " ... " + Math.min(Capabilities.screenResolutionX,Capabilities.screenResolutionY));
               trace(param1.stageHeight + " ... " + Math.max(Capabilities.screenResolutionX,Capabilities.screenResolutionY));
               if(param1.stageWidth == Math.min(Capabilities.screenResolutionX,Capabilities.screenResolutionY) && param1.stageHeight == Math.max(Capabilities.screenResolutionX,Capabilities.screenResolutionY))
               {
                  _ratioWidth = _loc4_ / param1.stageWidth;
                  _ratioHeight = _loc5_ / param1.stageHeight;
                  trace("real ratio: " + _ratioWidth + "x" + _ratioHeight);
               }
               else
               {
                  _ratioWidth = _loc3_ / param1.stageWidth;
                  _ratioHeight = _loc6_ / param1.stageHeight;
                  trace("visible ratio: " + _ratioWidth + "x" + _ratioHeight);
               }
            }
         }
      }
      
      public function get context() : ExtensionContext
      {
         return _context;
      }
      
      internal function get ratioWidth() : Number
      {
         return _ratioWidth;
      }
      
      internal function get ratioHeight() : Number
      {
         return _ratioHeight;
      }
   }
}
