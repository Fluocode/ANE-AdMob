package com.myflashlab.admob;

import android.util.Log;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdView;

class MyAdListener extends AdListener {
  private AdView _adView;
  
  private String _target;
  
  public MyAdListener(String $target) {
    this._target = $target;
  }
  
  public MyAdListener(String $target, AdView $adView) {
    this._target = $target;
    this._adView = $adView;
  }
  
  public void onAdClosed() {
    Log.d(ExConsts.AD_CLOSED, this._target);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_CLOSED, this._target);
  }
  
  public void onAdFailedToLoad(int errCode) {
    Log.d(ExConsts.AD_FAILED, this._target + "|||" + errCode);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_FAILED, this._target + "|||" + errCode);
  }
  
  public void onAdLeftApplication() {
    Log.d(ExConsts.AD_LEFT_APP, this._target);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_LEFT_APP, this._target);
  }
  
  public void onAdOpened() {
    Log.d(ExConsts.AD_OPENED, this._target);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_OPENED, this._target);
  }
  
  public void onAdLoaded() {
    Log.d(ExConsts.AD_LOADED, this._target);
    MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.AD_LOADED, this._target);
  }
}
