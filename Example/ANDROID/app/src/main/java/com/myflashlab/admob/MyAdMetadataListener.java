package com.myflashlab.admob;

import android.util.Log;

import com.google.android.gms.ads.rewarded.OnAdMetadataChangedListener;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.myflashlab.dependency.overrideAir.MyExtension;

class MyAdMetadataListener implements OnAdMetadataChangedListener {
//class MyAdMetadataListener extends AdMetadataListener {
  //private RewardedVideoAd _rewardedVideoAd;
  private RewardedAd _rewardedVideoAd;
  
  //public MyAdMetadataListener(RewardedVideoAd $target) {
  public MyAdMetadataListener(RewardedAd $target) {
    this._rewardedVideoAd = $target;
  }
  
  public void onAdMetadataChanged() {
    String jsonString = "{}";
    if (this._rewardedVideoAd.getAdMetadata() != null) {
      toTrace("trying to convert '_rewardedVideoAd.getAdMetadata()' to JSON");
      try {
        Gson gson = (new GsonBuilder()).create();
        jsonString = gson.toJson(this._rewardedVideoAd.getAdMetadata());
      } catch (Exception e) {
        toTrace(e.getMessage());
      } 
    } else {
      toTrace("_rewardedVideoAd.getAdMetadata() is null");
    } 
    Log.d(ExConsts.METADATA_CHANGED, jsonString);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.METADATA_CHANGED, jsonString);
  }
  
  private void toTrace(String $msg) {
    MyExtension.toTrace(ExConsts.ANE_NAME, 
        
        getClass().getSimpleName(), $msg);
  }
}
