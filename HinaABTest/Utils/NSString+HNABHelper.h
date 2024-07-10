

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SABHelper)

/// 比较版本号大小
/// @param version 版本号字符串
/// @return 比较结果
- (NSComparisonResult)sensorsabtest_compareVersion:(NSString *)version;

@end

NS_ASSUME_NONNULL_END
