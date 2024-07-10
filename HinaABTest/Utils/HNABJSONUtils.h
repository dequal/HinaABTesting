

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HNABJSONUtils : NSObject

/// json 数据解析
+ (nullable id)JSONObjectWithData:(NSData *)data;

/// JsonString 数据解析
+ (nullable id)JSONObjectWithString:(NSString *)string;

/// json 序列化
+ (nullable NSData *)JSONSerializeObject:(id)obj;

/// json string 序列化
+ (NSString *)stringWithJSONObject:(id)obj;

@end

NS_ASSUME_NONNULL_END
