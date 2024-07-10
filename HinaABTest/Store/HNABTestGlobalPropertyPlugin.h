

#import <Foundation/Foundation.h>

#if __has_include(<SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>)
#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>
#elif __has_include("SensorsAnalyticsSDK.h")
#import "SensorsAnalyticsSDK.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/// AB 全局属性插件，采集试验记录属性
@interface HNABTestGlobalPropertyPlugin : SAPropertyPlugin

/// 刷新属性信息
///
/// 可能是命中记录或试验分流记录属性
- (void)refreshGlobalProperties:(NSDictionary *)properties;

@end

NS_ASSUME_NONNULL_END
