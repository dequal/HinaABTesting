
#import "AppDelegate.h"
#import <SensorsAnalyticsSDK.h>
#import <SensorsABTest.h>


static NSString *const SADefaultServerURL = @"http://10.130.6.4:8106/sa?project=default";

/// 测试环境，获取试验地址
static NSString* kSABResultsTestURL = @"http://10.129.29.10:8202/api/v2/abtest/online/results?project-key=130EB9E0EE57A09D91AC167C6CE63F7723CE0B22";

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

    [self startSensorsAnalyticsSDKWithLaunching:aNotification];

    [self startSensorsABTest];
}

-  (void)startSensorsAnalyticsSDKWithLaunching:(NSNotification *)aNotification {
    SAConfigOptions *options = [[SAConfigOptions alloc] initWithServerURL:SADefaultServerURL launchOptions:nil];
    options.enableJavaScriptBridge = YES;
    options.enableLog = YES;
    options.flushNetworkPolicy = SensorsAnalyticsNetworkTypeALL;
    
    [SensorsAnalyticsSDK startWithConfigOptions:options];
}

- (void)startSensorsABTest {
    HinaABTestConfigOptions *abtestConfigOptions = [[HinaABTestConfigOptions alloc] initWithURL:kSABResultsTestURL];
    [SensorsABTest startWithConfigOptions:abtestConfigOptions];
}

- (void)application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls {
    for (NSURL *url in urls) {
        if ([SensorsABTest.sharedInstance handleOpenURL:url]) {
            return;
        }
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)application {
//   return YES;
//}


@end
