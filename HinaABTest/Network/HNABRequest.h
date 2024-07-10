

#import <Foundation/Foundation.h>
#import "HNABFetchResultResponse.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kHNABRequestBodyCustomIDs;
extern NSString *const kHNABRequestBodyCustomProperties;
extern NSString *const kHNABRequestBodyParamName;

@protocol HNABRequestProtocol <NSObject>

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, copy, readonly) NSURLRequest *request;

@end

/// 分流试验请求
@interface SABExperimentRequest : NSObject <HNABRequestProtocol>

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/// 请求时刻的用户标识
@property (nonatomic, strong) SABUserIdenty *userIdenty;

- (instancetype)init NS_UNAVAILABLE;

/// 初始化 App 原生分流请求
/// @param url 分流 Base url
/// @param key SaaS 的项目 key
/// @param userIdenty 用户信息
- (instancetype)initWithBaseURL:(NSURL *)url projectKey:(NSString *)key userIdenty:(SABUserIdenty *)userIdenty NS_DESIGNATED_INITIALIZER;


/// 初始化 App 内嵌 H5 分流请求
/// @param url 分流 Base url
/// @param key SaaS 的项目 key
/// @param userIdenty 用户信息
- (instancetype)initWebRequestWithBaseURL:(NSURL *)url projectKey:(NSString *)key userIdenty:(SABUserIdenty *)userIdenty NS_DESIGNATED_INITIALIZER;

/// 增加请求参数
/// @param body 需要增加的参数 body
- (void)appendRequestBody:(NSDictionary *)body;

/**
 * @abstract
 * 比较两个请求是否相同
 *
 * @discussion
 * 当前比较内容只包含 body 中的 login_id/anonymous_id/param_name/custom_properties 和 timeoutInterval
 *
 * @param request 进行比较的实例对象
*/
- (BOOL)isEqualToRequest:(SABExperimentRequest *)request;

@end

/// 上传白名单请求
@interface SABWhiteListRequest : NSObject <HNABRequestProtocol>

@property (nonatomic, copy) NSURL *openURL;

@property (nonatomic, copy) NSURL *baseURL;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, copy) NSDictionary *body;

- (instancetype)initWithOpenURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
