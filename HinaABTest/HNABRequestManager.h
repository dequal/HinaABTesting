

#import "HinaABTestExperiment.h"
#import "HNABRequest.h"

NS_ASSUME_NONNULL_BEGIN

/// 请求任务管理
///
/// 考虑到 asyncFetch 请求，都是直接触发，所以此处只针对 fastFetch 触发的请求
@interface HNABRequestManager : NSObject

/// 检查当前是否已存在相同的请求任务
/// @param request 检查对象
/// @return 检查结果
- (BOOL)containsRequest:(SABExperimentRequest *)request;

/// 合并当前请求参数至已存在的相同请求任务中
/// @param request 当前请求
/// @param experiment 当前试验
- (void)mergeExperimentWithRequest:(SABExperimentRequest *)request experiment:(HinaABTestExperiment *)experiment;

/// 添加新请求任务到当前列表中
/// @param request 当前请求
/// @param experiment 当前试验
- (void)addRequestTask:(SABExperimentRequest *)request experiment:(HinaABTestExperiment *)experiment;

/// 执行对应请求任务关联的所有试验回调
/// @param request 当前请求
/// @param completion 试验结果处理闭包
- (void)excuteExperimentsWithRequest:(SABExperimentRequest *)request completion:(void(^)(HinaABTestExperiment *))completion;

@end

NS_ASSUME_NONNULL_END
