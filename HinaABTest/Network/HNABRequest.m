

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HNABRequest.h"
#import "HNABLogBridge.h"
#import "HNABURLUtils.h"
#import "HNABBridge.h"
#import "HNABJSONUtils.h"
#import "HNABConstants.h"
#import "HNABValidUtils.h"
#import "NSString+HNABHelper.h"

/// timeoutInterval 最小值保护
static NSTimeInterval kFetchABTestResultMinTimeoutInterval = 1;

NSString *const kHNABRequestBodyCustomIDs = @"custom_ids";
NSString *const kHNABRequestBodyCustomProperties = @"custom_properties";
NSString *const kHNABRequestBodyLoginID = @"login_id";
NSString *const kHNABRequestBodyAnonymousID = @"anonymous_id";
NSString *const kHNABRequestBodyTimeoutInterval = @"timeout_interval";
NSString *const kHNABRequestBodyParamName = @"param_name";

@interface SABExperimentRequest()

@property (nonatomic, copy) NSURL *baseURL;
@property (nonatomic, copy) NSString *projectKey;
@property (nonatomic, strong) NSMutableDictionary *body;

@end

@implementation SABExperimentRequest

// 初始化 App 原生分流请求
- (instancetype)initWithBaseURL:(NSURL *)url projectKey:(NSString *)key userIdenty:(SABUserIdenty *)userIdenty {
    self = [[SABExperimentRequest alloc] initWebRequestWithBaseURL:url projectKey:key userIdenty:userIdenty];
    if (self) {
        // 拼接自定义主体 ID
        [self appendCustomIDs:userIdenty.customIDs];
    }
    return self;
}

// 初始化 App 内嵌 H5 分流请求
- (instancetype)initWebRequestWithBaseURL:(NSURL *)url projectKey:(NSString *)key userIdenty:(SABUserIdenty *)userIdenty {
    self = [super init];
    if (self) {
        _baseURL = url;
        _projectKey = key;
        _timeoutInterval = kSABFetchABTestResultDefaultTimeoutInterval;

        _userIdenty = userIdenty;

        NSMutableDictionary *parametersBody = [NSMutableDictionary dictionary];

#if TARGET_OS_OSX
        parametersBody[@"platform"] = @"macOS";
#else
        parametersBody[@"platform"] = @"iOS";
#endif
        parametersBody[kHNABRequestBodyLoginID] = userIdenty.loginId;
        parametersBody[kHNABRequestBodyAnonymousID] = userIdenty.anonymousId;
        // abtest sdk 版本号
        parametersBody[@"abtest_lib_version"] = kSABLibVersion;

        NSDictionary *presetProperties = [HNABBridge presetProperties];
        // 需要的部分 App 预置属性
        if (presetProperties) {
            NSMutableDictionary *properties = [NSMutableDictionary dictionary];
            properties[@"H_app_version"] = presetProperties[@"H_app_version"];
            properties[@"H_os"] = presetProperties[@"H_os"];
            properties[@"H_os_version"] = presetProperties[@"H_os_version"];
            properties[@"H_model"] = presetProperties[@"H_model"];
            properties[@"H_manufacturer"] = presetProperties[@"H_manufacturer"];
            // 运营商
            properties[@"H_carrier"] = presetProperties[@"H_carrier"];
            // 是否首日
            properties[@"H_is_first_day"] = presetProperties[@"H_is_first_day"];
            parametersBody[@"properties"] = properties;
        }
        _body = parametersBody;

    }
    return self;
}

- (void)appendCustomIDs:(NSDictionary *)customIDs {
    if (customIDs.count == 0) {
        return;
    }
    [self appendRequestBody:@{kHNABRequestBodyCustomIDs: customIDs}];
}

- (void)appendRequestBody:(NSDictionary *)body {
    if (![HNABValidUtils isValidDictionary:body]) {
        return;
    }
    [self.body addEntriesFromDictionary:body];
}

- (NSDictionary *)compareParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kHNABRequestBodyLoginID] = self.body[kHNABRequestBodyLoginID];
    params[kHNABRequestBodyAnonymousID] = self.body[kHNABRequestBodyAnonymousID];
    params[kHNABRequestBodyTimeoutInterval] = @(self.timeoutInterval);
    params[kHNABRequestBodyParamName] = self.body[kHNABRequestBodyParamName];
    params[kHNABRequestBodyCustomProperties] = self.body[kHNABRequestBodyCustomProperties];
    params[kHNABRequestBodyCustomIDs] = self.body[kHNABRequestBodyCustomIDs];
    return params;
}

- (BOOL)isEqualToRequest:(SABExperimentRequest *)request {
    return [[request compareParams] isEqualToDictionary:[self compareParams]];
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    // timeoutInterval 合法性校验
    if (timeoutInterval <= 0) {
        SABLogWarn(@"setup timeoutInterval invalid，%f", timeoutInterval);
        _timeoutInterval = kSABFetchABTestResultDefaultTimeoutInterval;
    } else if (timeoutInterval < kFetchABTestResultMinTimeoutInterval) {
        SABLogWarn(@"setup timeoutInterval invalid，%f", timeoutInterval);
        _timeoutInterval = kFetchABTestResultMinTimeoutInterval;
    } else {
        _timeoutInterval = timeoutInterval;
    }
}

- (NSURLRequest *)request {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_baseURL];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = _timeoutInterval;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    // 设置 HTTPHeader
    [request setValue:self.projectKey forHTTPHeaderField:@"project-key"];

    // 设置 HTTPBody
    request.HTTPBody = [HNABJSONUtils JSONSerializeObject:self.body];

    return request;
}

@end

@implementation SABWhiteListRequest

- (instancetype)initWithOpenURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _openURL = url;
        _timeoutInterval = 30;

        NSDictionary<NSString *, NSString *> *queryItemsDic = [HNABURLUtils queryItemsWithURL:self.openURL];
        _baseURL = [NSURL URLWithString:queryItemsDic[@"sensors_abtest_url"]];

        NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
        paramsDic[@"feature_code"] = queryItemsDic[@"feature_code"];
        paramsDic[@"account_id"] = queryItemsDic[@"account_id"];
        paramsDic[@"distinct_id"] = [HNABBridge distinctId];
        _body = [paramsDic copy];
    }
    return self;
}

- (NSURLRequest *)request {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_baseURL];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = _timeoutInterval;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    /* 关闭 Keep-Alive，
     此处设置关闭 Keep-Alive，防止频繁连续扫码，后端 TCP 连接可能断开，并且扫码打开 App 此时尚未完全进入前台，NSURLSession 没有自动重试，导致扫码上传白名单可能失败
     */
    [request setValue:@"close" forHTTPHeaderField:@"Connection"];
    request.HTTPBody = [HNABJSONUtils JSONSerializeObject:self.body];
    
    return request;
}

@end
