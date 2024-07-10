

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HNABValidUtils : NSObject

/// 是否为有效的字符串
+ (BOOL)isValidString:(NSString *)string;

/// 是否为有效 Dictionary
+ (BOOL)isValidDictionary:(NSDictionary *)dictionary;

/// 是否为有效的 data
+ (BOOL)isValidData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
