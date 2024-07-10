

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HinaABTestConfigOptions.h"
#import "HNABURLUtils.h"

@interface HinaABTestConfigOptions ()

/// 获取试验结果 url
@property (nonatomic, copy) NSURL *baseURL;

/// 项目 key
@property (nonatomic, copy) NSString *projectKey;

@end

@implementation HinaABTestConfigOptions

- (instancetype)initWithURL:(nonnull NSString *)urlString {
    self = [super init];
    if (self) {
        if (urlString) {
            NSDictionary *params = [HNABURLUtils queryItemsWithURLString:urlString];
            _projectKey = params[@"project-key"];
            _baseURL = [HNABURLUtils baseURLWithURLString:urlString];
        }
    }
    return self;
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone {
    HinaABTestConfigOptions *options = [[[self class] allocWithZone:zone] init];
    options.baseURL = self.baseURL;
    options.projectKey = self.projectKey;
    return options;
}
@end
