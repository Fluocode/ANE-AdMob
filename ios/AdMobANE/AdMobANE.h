//
// AdMobANE.h — Adobe AIR native extension entry points for iOS (fluocode.com).
// Add the AIR SDK include path so "FlashRuntimeExtensions.h" resolves (e.g. AIR_SDK/lib/native/ios).
//

#ifndef AdMobANE_AdMobANE_h
#define AdMobANE_AdMobANE_h

#include "FlashRuntimeExtensions.h"

void comFluocodeAdmobMyExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void comFluocodeAdmobMyExtensionFinalizer(void* extData);

#endif
