//
// AdMobCommand.m — Banner, interstitial, and rewarded implementations using GAD* types from the Google Mobile Ads SDK.
// Depends on FlashRuntimeExtensions.h (AIR) and GoogleMobileAds.framework.
//

#import "AdMobCommand.h"
#import "FlashRuntimeExtensions.h"
#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AdMobCommand () <GADBannerViewDelegate, GADFullScreenContentDelegate>
@property (nonatomic, assign) FREContext context;
@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) GADBannerView* bannerView;
@property (nonatomic, strong) GADInterstitialAd* interstitialAd;
@property (nonatomic, copy) NSString* interstitialAdUnitId;
@property (nonatomic, strong) GADRewardedAd* rewardedAd;
@property (nonatomic, copy) NSString* rewardedAdUnitId;
@property (nonatomic, copy) NSString* rewardedUserId;
@property (nonatomic, assign) BOOL sdkInitialized;
@end

/** Returns the foreground key window, or the first window in the active scene (iOS 13+), falling back to keyWindow on older OS versions. */
static UIWindow *ADMobKeyWindow(void) {
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
                UIWindowScene *ws = (UIWindowScene *)scene;
                for (UIWindow *w in ws.windows) {
                    if (w.isKeyWindow) return w;
                }
                if (ws.windows.count > 0) return ws.windows.firstObject;
            }
        }
        return nil;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
}

@implementation AdMobCommand

- (instancetype)initWithContext:(FREContext)ctx
{
    if (self = [super init]) {
        _context = ctx;
        _sdkInitialized = NO;
    }
    return self;
}

- (void)dispose
{
    _bannerView.delegate = nil;
    [_bannerView removeFromSuperview];
    _bannerView = nil;
    _interstitialAd = nil;
    _rewardedAd = nil;
    _containerView = nil;
    _context = NULL;
}

- (FREObject)dispatchCommand:(FREObject*)argv argc:(uint32_t)argc
{
    if (argc < 1) return NULL;

    NSString* cmd = [self getString:argv[0]];
    if (!cmd) return NULL;

    if ([cmd isEqualToString:@"getNativeDimension"]) {
        return [self getNativeDimension];
    }
    if ([cmd isEqualToString:@"initialize"]) {
        [self initialize:[self getString:argv[1]]];
        return NULL;
    }
    if ([cmd isEqualToString:@"dispose"]) {
        [self dispose];
        return NULL;
    }
    if ([cmd isEqualToString:@"initBanner"]) {
        [self initBanner:[self getString:argv[1]] adSize:[self getInt:argv[2]]];
        return NULL;
    }
    if ([cmd isEqualToString:@"disposeBanner"]) {
        [self disposeBanner];
        return NULL;
    }
    if ([cmd isEqualToString:@"loadBanner"]) {
        [self loadBanner:[self getString:argv[1]]];
        return NULL;
    }
    if ([cmd isEqualToString:@"hideBanner"]) {
        [self hideBanner:[self getBool:argv[1]]];
        return NULL;
    }
    if ([cmd isEqualToString:@"setPosition"]) {
        [self setPosition:[self getDouble:argv[1]] y:[self getDouble:argv[2]]];
        return NULL;
    }
    if ([cmd isEqualToString:@"initInterstitial"]) {
        [self initInterstitial:[self getString:argv[1]]];
        return NULL;
    }
    if ([cmd isEqualToString:@"disposeInterstitial"]) {
        [self disposeInterstitial];
        return NULL;
    }
    if ([cmd isEqualToString:@"loadInterstitial"]) {
        [self loadInterstitial:[self getString:argv[1]]];
        return NULL;
    }
    if ([cmd isEqualToString:@"isInterstitialLoaded"]) {
        return [self newBool:self.interstitialAd != nil];
    }
    if ([cmd isEqualToString:@"showInterstitial"]) {
        [self showInterstitial];
        return NULL;
    }
    if ([cmd isEqualToString:@"loadRewardedVideo"]) {
        [self loadRewardedVideo:[self getString:argv[1]] unitId:[self getString:argv[2]]];
        return NULL;
    }
    if ([cmd isEqualToString:@"isRewardedVideoReady"]) {
        return [self newBool:self.rewardedAd != nil];
    }
    if ([cmd isEqualToString:@"showRewardedVideo"]) {
        [self showRewardedVideo];
        return NULL;
    }
    if ([cmd isEqualToString:@"rewardedVideoGetUserId"]) {
        return [self newString:self.rewardedUserId ?: @""];
    }
    if ([cmd isEqualToString:@"rewardedVideoSetUserId"]) {
        self.rewardedUserId = [self getString:argv[1]] ?: @"";
        return NULL;
    }
    if ([cmd isEqualToString:@"disposeRewardedVideo"]) {
        [self disposeRewardedVideo];
        return NULL;
    }
    if ([cmd isEqualToString:@"MobileAdsSetAppMuted"]) {
        [GADMobileAds sharedInstance].applicationMuted = [self getBool:argv[1]];
        return NULL;
    }
    if ([cmd isEqualToString:@"MobileAdsSetAppVolume"]) {
        [GADMobileAds sharedInstance].applicationVolume = (float)[self getDouble:argv[1]];
        return NULL;
    }

    return NULL;
}

#pragma mark - Helpers

- (NSString*)getString:(FREObject)obj
{
    if (!obj) return nil;
    uint32_t len;
    const uint8_t* ptr;
    if (FREGetObjectAsUTF8(obj, &len, &ptr) != FRE_OK) return nil;
    return [[NSString alloc] initWithBytes:ptr length:len encoding:NSUTF8StringEncoding];
}

- (int32_t)getInt:(FREObject)obj
{
    if (!obj) return 0;
    int32_t v;
    FREGetObjectAsInt32(obj, &v);
    return v;
}

- (double)getDouble:(FREObject)obj
{
    if (!obj) return 0;
    double v;
    FREGetObjectAsDouble(obj, &v);
    return v;
}

- (BOOL)getBool:(FREObject)obj
{
    if (!obj) return NO;
    uint32_t v;
    FREGetObjectAsBool(obj, &v);
    return v != 0;
}

- (FREObject)newString:(NSString*)s
{
    const char* utf8 = [s UTF8String];
    uint32_t len = (uint32_t)(strlen(utf8) + 1);
    FREObject result;
    if (FRENewObjectFromUTF8(len, (const uint8_t*)utf8, &result) != FRE_OK) return NULL;
    return result;
}

- (FREObject)newBool:(BOOL)value
{
    FREObject result;
    FRENewObjectFromBool(value ? 1 : 0, &result);
    return result;
}

- (void)dispatchEvent:(NSString*)code level:(NSString*)level
{
    if (!_context) return;
    const char* codeStr = [code UTF8String];
    const char* levelStr = level ? [level UTF8String] : "";
    FREDispatchStatusEventAsync(_context, (uint8_t*)codeStr, (uint8_t*)levelStr);
}

#pragma mark - Dimensions

- (FREObject)getNativeDimension
{
    UIWindow* win = ADMobKeyWindow();
    if (!win) win = [UIApplication sharedApplication].windows.firstObject;
    CGRect bounds = win ? win.bounds : [[UIScreen mainScreen] bounds];
    CGFloat w = CGRectGetWidth(bounds);
    CGFloat h = CGRectGetHeight(bounds);
    NSString* s = [NSString stringWithFormat:@"%d|||%d|||%d|||%d", (int)w, (int)h, (int)w, (int)h];
    return [self newString:s];
}

#pragma mark - Initialize

- (void)initialize:(NSString*)appId
{
    if (_sdkInitialized) return;
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // Delay Mobile Ads startup briefly so the AIR runtime completes initial view-controller appearance before ad views attach.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!wself) return;
            if (appId.length > 0) {
                [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus* status) {
                    wself.sdkInitialized = YES;
                }];
            } else {
                wself.sdkInitialized = YES;
            }
        });
    });
    _sdkInitialized = YES;
}

#pragma mark - Banner

- (void)initBanner:(NSString*)unitId adSize:(int)adSize
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self disposeBanner];
        UIViewController* root = [self rootViewController];
        if (!root) return;
        GADAdSize size = [self gadSizeFromInt:adSize];
        self.bannerView = [[GADBannerView alloc] initWithAdSize:size];
        self.bannerView.adUnitID = unitId;
        self.bannerView.rootViewController = root;
        self.bannerView.delegate = self;
        if (!self.containerView) {
            self.containerView = [[UIView alloc] initWithFrame:root.view.bounds];
            self.containerView.userInteractionEnabled = NO;
            [root.view addSubview:self.containerView];
        }
        [self.containerView addSubview:self.bannerView];
    });
}

- (GADAdSize)gadSizeFromInt:(int)adSize
{
    switch (adSize) {
        case 1: return GADAdSizeBanner;
        case 2: return GADAdSizeFullBanner;
        case 3: return GADAdSizeLargeBanner;
        case 4: return GADAdSizeLeaderboard;
        case 5: return GADAdSizeMediumRectangle;
        case 6: return GADAdSizeSkyscraper;
        case 7:
        case 8: return GADLargePortraitAnchoredAdaptiveBannerAdSizeWithWidth([UIScreen mainScreen].bounds.size.width);
        case 9: return GADLargeAnchoredAdaptiveBannerAdSizeWithWidth([UIScreen mainScreen].bounds.size.width);
        default: return GADAdSizeBanner;
    }
}

- (void)loadBanner:(NSString*)requestJson
{
    dispatch_async(dispatch_get_main_queue(), ^{
        GADRequest* req = [GADRequest request];
        [self applyRequestJson:requestJson toRequest:req];
        [self.bannerView loadRequest:req];
    });
}

- (void)hideBanner:(BOOL)hide
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bannerView.hidden = hide;
    });
}

- (void)setPosition:(double)x y:(double)y
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect f = self.bannerView.frame;
        f.origin.x = (CGFloat)x;
        f.origin.y = (CGFloat)y;
        self.bannerView.frame = f;
    });
}

- (void)disposeBanner
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bannerView.delegate = nil;
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    });
}

- (void)bannerViewDidReceiveAd:(GADBannerView*)bannerView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat w = bannerView.frame.size.width;
        CGFloat h = bannerView.frame.size.height;
        [self dispatchEvent:@"onBannerSizeMeasured" level:[NSString stringWithFormat:@"%d|||%d", (int)w, (int)h]];
        [self dispatchEvent:@"onAdLoaded" level:@"banner"];
    });
}

- (void)bannerView:(GADBannerView*)bannerView didFailToReceiveAdWithError:(NSError*)error
{
    [self dispatchEvent:@"onAdFailed" level:[NSString stringWithFormat:@"banner|||%ld|||%@", (long)error.code, error.localizedDescription]];
}

- (void)bannerViewDidRecordClick:(GADBannerView*)bannerView { }
- (void)bannerViewWillPresentScreen:(GADBannerView*)bannerView { [self dispatchEvent:@"onAdOpened" level:@"banner"]; }
- (void)bannerViewWillDismissScreen:(GADBannerView*)bannerView { }
- (void)bannerViewDidDismissScreen:(GADBannerView*)bannerView { [self dispatchEvent:@"onAdClosed" level:@"banner"]; }
- (void)bannerViewDidRecordImpression:(GADBannerView*)bannerView { }

#pragma mark - Interstitial

- (void)initInterstitial:(NSString*)unitId
{
    self.interstitialAdUnitId = unitId;
    self.interstitialAd = nil;
}

- (void)loadInterstitial:(NSString*)requestJson
{
    NSString* unitId = self.interstitialAdUnitId ?: @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        GADRequest* req = [GADRequest request];
        [self applyRequestJson:requestJson toRequest:req];
        [GADInterstitialAd loadWithAdUnitID:unitId request:req completionHandler:^(GADInterstitialAd* ad, NSError* error) {
            if (error) {
                [self dispatchEvent:@"onAdFailed" level:[NSString stringWithFormat:@"interstitial|||%ld|||%@", (long)error.code, error.localizedDescription]];
                return;
            }
            self.interstitialAd = ad;
            self.interstitialAd.fullScreenContentDelegate = self;
            [self dispatchEvent:@"onAdLoaded" level:@"interstitial"];
        }];
    });
}

- (void)showInterstitial
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController* root = [self rootViewController];
        if (self.interstitialAd && root) {
            [self.interstitialAd presentFromRootViewController:root];
        }
    });
}

- (void)disposeInterstitial
{
    _interstitialAd = nil;
}

- (void)adWillPresentFullScreenContent:(id)ad
{
    [self dispatchEvent:@"onAdOpened" level:@"interstitial"];
}

- (void)adDidDismissFullScreenContent:(id)ad
{
    [self dispatchEvent:@"onAdClosed" level:@"interstitial"];
    _interstitialAd = nil;
}

- (void)ad:(id)ad didFailToPresentFullScreenContentWithError:(NSError*)error
{
    [self dispatchEvent:@"onAdFailed" level:[NSString stringWithFormat:@"interstitial|||%ld|||%@", (long)error.code, error.localizedDescription]];
}

#pragma mark - Rewarded

- (void)loadRewardedVideo:(NSString*)requestJson unitId:(NSString*)unitId
{
    _rewardedAdUnitId = unitId;
    dispatch_async(dispatch_get_main_queue(), ^{
        GADRequest* req = [GADRequest request];
        [self applyRequestJson:requestJson toRequest:req];
        [GADRewardedAd loadWithAdUnitID:unitId request:req completionHandler:^(GADRewardedAd* ad, NSError* error) {
            if (error) {
                [self dispatchEvent:@"onAdFailed" level:[NSString stringWithFormat:@"rewardedVideo|||%ld|||%@", (long)error.code, error.localizedDescription]];
                return;
            }
            self.rewardedAd = ad;
            self.rewardedAd.fullScreenContentDelegate = self;
            [self dispatchEvent:@"onAdLoaded" level:@"rewardedVideo"];
        }];
    });
}

- (void)showRewardedVideo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController* root = [self rootViewController];
        if (self.rewardedAd && root) {
            [self.rewardedAd presentFromRootViewController:root userDidEarnRewardHandler:^{
                GADAdReward* reward = self.rewardedAd.adReward;
                NSString* level = [NSString stringWithFormat:@"%@|||%@|||%f", reward.type, reward.amount.stringValue, reward.amount.doubleValue];
                [self dispatchEvent:@"onAdDeliverReward" level:level];
            }];
        }
    });
}

- (void)disposeRewardedVideo
{
    _rewardedAd = nil;
    _rewardedAdUnitId = nil;
}

#pragma mark - Request JSON

- (void)applyRequestJson:(NSString*)json toRequest:(GADRequest*)request
{
    if (!json || json.length == 0) return;
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (!d) return;
    // Parsed JSON mirrors the Android-side AdRequest shape; current GADRequest on iOS does not map
    // keyword or test-device arrays the same way as AdRequest.Builder on Android, so those entries are unused here.
}

#pragma mark - Root VC

- (UIViewController*)rootViewController
{
    UIWindow* win = ADMobKeyWindow();
    if (!win) win = [UIApplication sharedApplication].windows.firstObject;
    UIViewController* vc = win.rootViewController;
    while (vc.presentedViewController) vc = vc.presentedViewController;
    return vc;
}

@end
