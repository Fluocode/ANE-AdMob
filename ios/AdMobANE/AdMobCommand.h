//
// AdMobCommand.h — Objective-C bridge: parses FRE "command" calls from ActionScript and drives Google Mobile Ads APIs.
//

#import <Foundation/Foundation.h>

#ifndef _FREContext
typedef void* FREContext;
#endif
#ifndef _FREObject
typedef void* FREObject;
#endif

@interface AdMobCommand : NSObject
- (instancetype)initWithContext:(FREContext)ctx;
- (FREObject)dispatchCommand:(FREObject*)argv argc:(uint32_t)argc;
- (void)dispose;
@end
