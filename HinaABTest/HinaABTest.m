

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import <WebKit/WebKit.h>
#import "HinaABTest.h"
#import "HNABLogBridge.h"
#import "HNABBridge.h"
#import "NSString+HNABHelper.h"
#import "HNABManager.h"
#import "HNABConstants.h"
#import "HNABNetwork.h"
#import "HinaABTestConfigOptions+Private.h"
#import "HNABRequest.h"
#import "HNABSwizzler.h"
#import "HinaABTestExperiment+Private.h"

static HinaABTest *sharedABTest = nil;

@interface HinaABTest()
@property (nonatomic, strong) HNABManager *manager;
@end

@implementation HinaABTest

/// 通过配置参数，配置神策 A/B Testing SDK
/// @param configOptions 参数配置
+ (void)startWithConfigOptions:(HinaABTestConfigOptions *)configOptions {

    if (sharedABTest) {
        SABLogWarn(@"A/B Testing SDK repeat initialization! Only the first initialization valid!");
        return;
    }

    // 判断 configOptions 有效性
    NSAssert(configOptions.projectKey && configOptions.baseURL, @"请通过正确 url 初始化 SABConfigOptions 对象");
    if (!configOptions.projectKey || !configOptions.baseURL) {
        HNABLogError(@"Initialize the SABConfigOptions object with the valid URL");
        return;
    }

    // 判断 SensorsAnalyticsSDK 有效性
    NSAssert([HNABBridge sensorsAnalyticsInstance], @"HinaABTest SDK 依赖 SensorsAnalyticsSDK, 请先初始化 SensorsAnalyticsSDK");
    NSAssert([HinaABTest isSupportedSAVersion], @"HinaABTest SDK 依赖 SensorsAnalyticsSDK, SensorsAnalyticsSDK 最低要求版本为： %@", kSABMinSupportedSALibVersion);
    if (![HNABBridge sensorsAnalyticsInstance] || ![HinaABTest isSupportedSAVersion]) {
        HNABLogError(@"HinaABTest SDK depend SensorsAnalyticsSDK initialization, SensorsAnalyticsSDK required minimum version is %@", kSABMinSupportedSALibVersion);
        return;
    }

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedABTest = [[HinaABTest alloc] initWithConfigOptions:configOptions];
        [HNABSwizzler swizzleSATrackEvent];
    });
    SABLogInfo(@"start HinaABTest success");
}

/// 返回 神策 A/B Testing SDK 单例
+ (HinaABTest *)sharedInstance {
    NSAssert(sharedABTest, @"请先使用 startWithConfigOptions: 初始化 HinaABTest SDK");
    return sharedABTest;
}

#pragma mark - initialize
- (instancetype)initWithConfigOptions:(nonnull HinaABTestConfigOptions *)configOptions {
    self = [super init];
    if (self) {
        self.manager = [[HNABManager alloc] initWithConfigOptions:configOptions];
    }
    return self;
}

#pragma mark - Cache Method
- (nullable id)fetchCacheABTestWithParamName:(NSString *)paramName defaultValue:(id)defaultValue {
    __block id resultValue = defaultValue;
    HinaABTestExperiment *experiment = [HinaABTestExperiment experimentWithParamName:paramName defaultValue:defaultValue];
    experiment.modeType = SABFetchABTestModeTypeCache;
    experiment.handler = ^(id  _Nullable result) {
        resultValue = result;
    };
    [self.manager fetchABTestWithExperiment:experiment];
    return resultValue;
}

#pragma mark - Async Methods
- (void)asyncFetchABTestWithParamName:(NSString *)paramName defaultValue:(id)defaultValue completionHandler:(void (^)(id _Nullable result))completionHandler {
    [self asyncFetchABTestWithExperiment:[HinaABTestExperiment experimentWithParamName:paramName defaultValue:defaultValue] completionHandler:completionHandler];
}

- (void)asyncFetchABTestWithParamName:(NSString *)paramName defaultValue:(id)defaultValue timeoutInterval:(NSTimeInterval)timeoutInterval completionHandler:(void (^)(id _Nullable result))completionHandler {
    HinaABTestExperiment *experiment = [HinaABTestExperiment experimentWithParamName:paramName defaultValue:defaultValue];
    experiment.timeoutInterval = timeoutInterval;
    [self asyncFetchABTestWithExperiment:experiment completionHandler:completionHandler];
}

- (void)asyncFetchABTestWithExperiment:(HinaABTestExperiment *)experiment completionHandler:(void (^)(id _Nullable result))completionHandler {
    experiment.modeType = SABFetchABTestModeTypeAsync;
    experiment.handler = completionHandler;
    [self.manager fetchABTestWithExperiment:experiment];
}

#pragma mark - Fast Methods
- (void)fastFetchABTestWithParamName:(NSString *)paramName defaultValue:(id)defaultValue completionHandler:(void (^)(id _Nullable result))completionHandler {
    [self fastFetchABTestWithExperiment:[HinaABTestExperiment experimentWithParamName:paramName defaultValue:defaultValue] completionHandler:completionHandler];
}

- (void)fastFetchABTestWithParamName:(NSString *)paramName defaultValue:(id)defaultValue timeoutInterval:(NSTimeInterval)timeoutInterval completionHandler:(void (^)(id _Nullable result))completionHandler {
    HinaABTestExperiment *experiment = [HinaABTestExperiment experimentWithParamName:paramName defaultValue:defaultValue];
    experiment.timeoutInterval = timeoutInterval;
    [self fastFetchABTestWithExperiment:experiment completionHandler:completionHandler];
}

- (void)fastFetchABTestWithExperiment:(HinaABTestExperiment *)experiment completionHandler:(void (^)(id _Nullable result))completionHandler {
    experiment.modeType = SABFetchABTestModeTypeFast;
    experiment.handler = completionHandler;
    [self.manager fetchABTestWithExperiment:experiment];
}

#pragma mark action
- (BOOL)handleOpenURL:(NSURL *)url {
    if (![url isKindOfClass:NSURL.class] || ![url.host isEqualToString:@"abtest"]) {
        return NO;
    }
    SABWhiteListRequest *requestData = [[SABWhiteListRequest alloc] initWithOpenURL:url];
    [HNABNetwork dataTaskWithRequest:requestData.request completionHandler:^(id  _Nullable jsonObject, NSError * _Nullable error) {
        
        if (error) {
            SABLogWarn(@"upload distinctId failure，error:%@", error);
        } else {
            SABLogInfo(@"upload distinctId success");
        }
    }];
    return YES;
}

- (void)setCustomIDs:(NSDictionary <NSString*, NSString*> *)customIDs {
    [self.manager setCustomIDs:customIDs];
}

+ (BOOL)isSupportedSAVersion {
    return [HNABBridge.libVersion sensorsabtest_compareVersion:kSABMinSupportedSALibVersion] != NSOrderedAscending ;
}

@end
