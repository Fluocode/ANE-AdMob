package com.myflashlab.admob;

import com.google.android.gms.ads.rewarded.RewardItem;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;
import com.myflashlab.dependency.overrideAir.MyExtension;

class MyRewardListener extends RewardedAdLoadCallback {
//class MyRewardListener implements RewardedVideoAdListener {
  private String _target;
  
  public MyRewardListener(String $target) {
    toTrace("added MyRewardListener for " + $target);
    this._target = $target;
  }
  
  public void onRewardedVideoAdLoaded() {
    toTrace("AD_LOADED: " + this._target);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_LOADED, this._target);
  }
  
  public void onRewardedVideoAdOpened() {
    toTrace("AD_OPENED: " + this._target);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_OPENED, this._target);
  }
  
  public void onRewardedVideoStarted() {
    toTrace("AD_BEGIN_PLAYING: " + this._target);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_BEGIN_PLAYING, this._target);
  }
  
  public void onRewardedVideoAdClosed() {
    toTrace("AD_CLOSED: " + this._target);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_CLOSED, this._target);
  }
  
  public void onRewarded(RewardItem rewardItem) {
    toTrace("Reward received type: " + rewardItem.getType() + ", amount: " + rewardItem.getAmount());
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_DELIVER_REWARD, this._target + "|||" + rewardItem
        .getType() + "|||" + rewardItem.getAmount());
  }
  
  public void onRewardedVideoAdLeftApplication() {
    toTrace("AD_LEFT_APP: " + this._target);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_LEFT_APP, this._target);
  }
  
  public void onRewardedVideoAdFailedToLoad(int errCode) {
    toTrace("AD_FAILED: " + this._target + " errCode: " + errCode);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_FAILED, this._target + "|||" + errCode + "||| ");
  }
  
  public void onRewardedVideoCompleted() {
    toTrace("AD_END_PLAYING: " + this._target);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_END_PLAYING, this._target);
  }
  
  private void toTrace(String $msg) {
    MyExtension.toTrace(ExConsts.ANE_NAME, 
        
        getClass().getSimpleName(), $msg);
  }
}

