

#import "AppDelegate.h"
#import <SensorsAnalyticsSDK.h>
#import <HinaABTest.h>

/// 测试环境，获取试验地址
static NSString* kSABResultsTestURL = @"http://10.129.29.10:8202/api/v2/abtest/online/results?project-key=130EB9E0EE57A09D91AC167C6CE63F7723CE0B22";

// 测试环境，数据接收地址
static NSString* kSABTestServerURL = @"http://10.129.28.106:8106/sa?project=default";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self startSensorsAnalyticsSDKWithConfigOptions:launchOptions];

    [self startHinaABTest];
    
    return YES;
}

- (void)startSensorsAnalyticsSDKWithConfigOptions:(NSDictionary *)launchOptions {
    SAConfigOptions *options = [[SAConfigOptions alloc] initWithServerURL:kSABTestServerURL launchOptions:launchOptions];
//    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd | SensorsAnalyticsEventTypeAppClick | SensorsAnalyticsEventTypeAppViewScreen;
    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd | SensorsAnalyticsEventTypeAppViewScreen;

    options.enableHeatMap = YES;
    options.enableVisualizedAutoTrack = YES;
    options.enableJavaScriptBridge = YES;
#ifdef DEBUG
    options.enableLog = YES;
    options.flushNetworkPolicy = SensorsAnalyticsNetworkTypeNONE;
#endif


    [SensorsAnalyticsSDK startWithConfigOptions:options];

}

- (void)startHinaABTest {
    HinaABTestConfigOptions *abtestConfigOptions = [[HinaABTestConfigOptions alloc] initWithURL:kSABResultsTestURL];
    [HinaABTest startWithConfigOptions:abtestConfigOptions];

    [HinaABTest.sharedInstance setCustomIDs:@{@"custom_subject_id":@"iOS自定义主体333"}];

}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([[HinaABTest sharedInstance] handleOpenURL:url]) {
        return YES;
    }
    return NO;
}

@end
