

#import "HinaABTestConfigOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface HinaABTestConfigOptions (Private)

/// 获取试验结果 url
@property (nonatomic, copy, readonly) NSURL *baseURL;

/// 项目 key
@property (nonatomic, copy, readonly) NSString *projectKey;

@end

NS_ASSUME_NONNULL_END
