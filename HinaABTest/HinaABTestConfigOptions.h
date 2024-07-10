


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HinaABTestConfigOptions : NSObject<NSCopying>

- (instancetype)init NS_UNAVAILABLE;


/// 指定初始化方法，设置 serverURL
/// @param urlString 设置地址链接 URL
/// @return 实例对象
- (instancetype)initWithURL:(NSString *)urlString NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
