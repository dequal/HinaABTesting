

#import <Foundation/Foundation.h>
#if __has_include(<SensorsAnalyticsSDK/SABaseStoreManager.h>)
#import <SensorsAnalyticsSDK/SAStorePlugin.h>
#elif __has_include("SAStorePlugin.h")
#import "SAStorePlugin.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/// 文件存储插件，兼容历史明文本地数据
@interface HNABFileStorePlugin : NSObject <SAStorePlugin>

@end

NS_ASSUME_NONNULL_END
