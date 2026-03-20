//
// AdMobANE.m — Registers the AIR FRE extension: extension/context initializers and the "command" native function.
// Produces a static library linked with Google Mobile Ads when building the final IPA.
//

#import "AdMobANE.h"
#import "AdMobCommand.h"

static AdMobCommand* s_command = nil;

static void contextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet);
static void contextFinalizer(void* extData);
static FREObject commandFunc(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

void comFluocodeAdmobMyExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &contextInitializer;
    *ctxFinalizerToSet = &contextFinalizer;
}

void comFluocodeAdmobMyExtensionFinalizer(void* extData)
{
}

static void contextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
{
    static const FRENamedFunction functions[] = {
        { (const uint8_t*)"command", NULL, &commandFunc },
    };
    *numFunctionsToSet = sizeof(functions) / sizeof(FRENamedFunction);
    *functionsToSet = functions;

    if (!s_command)
        s_command = [[AdMobCommand alloc] initWithContext:ctx];
}

static void contextFinalizer(void* extData)
{
    if (s_command) {
        [s_command dispose];
        s_command = nil;
    }
}

static FREObject commandFunc(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    if (argc < 1 || !s_command) return NULL;
    return [s_command dispatchCommand:argv argc:argc];
}
