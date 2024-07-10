

#if __has_include(<SensorsAnalyticsSDK/SABaseStoreManager.h>)
#import <SensorsAnalyticsSDK/SABaseStoreManager.h>
#elif __has_include("SABaseStoreManager.h")
#import "SABaseStoreManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface HNABStoreManager: SABaseStoreManager

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
