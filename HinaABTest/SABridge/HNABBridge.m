
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#if __has_include(<SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>)
#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>
#elif __has_include("SensorsAnalyticsSDK.h")
#import "SensorsAnalyticsSDK.h"
#endif

#import "HNABBridge.h"
#import "HNABLogBridge.h"

@interface SensorsAnalyticsSDK(HNABBridge)
@property (nonatomic, strong, readonly) SAConfigOptions *configOptions;
@end

@interface SAConfigOptions(HNABBridge)

// 注册自定义插件
@property (nonatomic, strong, readonly) NSMutableArray *storePlugins;
@end

@implementation HNABBridge

+ (id)sensorsAnalyticsInstance {
    id instance = nil;
    // 这里 catch SensorsAnalyticsSDK 未初始化的断言，依赖 HinaABTesting 的断言提示
    @try {
        instance = SensorsAnalyticsSDK.sharedInstance;
    } @catch (NSException *exception) {
        SABLogWarn(@"%@", exception);
    } @finally {
        return instance;
    }
}

#pragma mark get properties
+ (NSString *)anonymousId {
    return [SensorsAnalyticsSDK.sharedInstance anonymousId];
}

+ (NSString *)loginId {
    return [SensorsAnalyticsSDK.sharedInstance loginId];
}

+ (NSString *)distinctId {
    return [SensorsAnalyticsSDK.sharedInstance distinctId];
}

+ (NSString *)libVersion {
    return [SensorsAnalyticsSDK.sharedInstance libVersion];
}

+ (NSDictionary *)presetProperties {
    return [SensorsAnalyticsSDK.sharedInstance getPresetProperties];
}

+ (NSMutableArray *)storePlugins {
    return SensorsAnalyticsSDK.sharedInstance.configOptions.storePlugins;
}

#pragma mark track
+ (void)track:(NSString *)eventName properties:(NSDictionary *)properties {
    [SensorsAnalyticsSDK.sharedInstance track:eventName withProperties:properties];
}

+ (void)registerABTestPropertyPlugin:(SAPropertyPlugin *)propertyPlugin {
    [SensorsAnalyticsSDK.sharedInstance registerPropertyPlugin:propertyPlugin];
}

+ (void)unregisterWithPropertyPluginClass:(Class)pluginClass {
    [SensorsAnalyticsSDK.sharedInstance unregisterPropertyPluginWithPluginClass:pluginClass];
}
@end
