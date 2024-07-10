

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HinaABTestExperiment : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithParamName:(NSString *)paramName defaultValue:(id)defaultValue NS_DESIGNATED_INITIALIZER;

+ (HinaABTestExperiment *)experimentWithParamName:(NSString *)paramName defaultValue:(id)defaultValue;

/// 试验参数名
@property (copy, nonatomic, readonly) NSString *paramName;

/// 默认值
@property (strong, nonatomic, readonly) id defaultValue;

/// 自定义属性
@property (strong, nonatomic) NSDictionary *properties;

/// 超时时间，单位为秒
@property (assign, nonatomic) NSTimeInterval timeoutInterval;

@end

NS_ASSUME_NONNULL_END
