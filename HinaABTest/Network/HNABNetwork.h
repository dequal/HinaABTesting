

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SABURLSessionTaskCompletionHandler)(id _Nullable jsonObject, NSError * _Nullable error);

@interface HNABNetwork : NSObject

/// 通过 request 创建一个 task，并设置完成的回调
/// @param request 请求 request
/// @param completionHandler 结果回调
/// @return NSURLSessionDataTask 对象
+ (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(SABURLSessionTaskCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
