

#import <Foundation/Foundation.h>

@interface HNABURLUtils : NSObject

/// 解析 query 参数
/// @param URLString url 字符串
/// @return 参数 Dictionary
+ (NSDictionary<NSString *, NSString *> *)queryItemsWithURLString:(NSString *)URLString;

/// 解析 query 参数
/// @param url NSURL 对象
/// @return 参数 Dictionary
+ (NSDictionary<NSString *, NSString *> *)queryItemsWithURL:(NSURL *)url;

/// 解析 baseURL
/// @param URLString url 字符串
/// @return NSURL 对象
+ (NSURL *)baseURLWithURLString:(NSString *)URLString;

@end

