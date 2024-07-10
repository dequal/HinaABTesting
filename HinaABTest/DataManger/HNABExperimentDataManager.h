

#import <Foundation/Foundation.h>
#import "HNABFetchResultResponse.h"
#import "HNABRequest.h"
#import "HNABTestTrackConfig.h"

/// App 原生分流请求回调
typedef void(^HNABFetchResultResponseCompletionHandler)(HNABFetchResultResponse *_Nullable responseData, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

/// 数据存储和解析
@interface HNABExperimentDataManager : NSObject

/// 指定初始化接口
/// @param serialQueue 串行队列
- (instancetype)initWithSerialQueue:(dispatch_queue_t)serialQueue NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// 请求白名单，只在发送请求成功后更新，只有白名单内的试验参数名，才可能需要重新拉取试验配置
@property (atomic, strong, readonly) NSArray <NSString *> *fuzzyExperiments;

/// $ABTestTrigger 事件配置
@property (atomic, strong, readonly) HNABTestTrackConfig *trackConfig;

/// 当前用户信息
@property (atomic, strong, readonly) SABUserIdenty *currentUserIndenty;

/// 获取缓存试验结果
- (nullable SABExperimentResult *)cachedExperimentResultWithParamName:(NSString *)paramName;

/// 异步请求所有试验
- (void)asyncFetchAllExperimentWithRequest:(SABExperimentRequest *)requestData completionHandler:(HNABFetchResultResponseCompletionHandler)completionHandler;

/// 切换用户，清空分流结果缓存
- (void)clearExperimentResults;

/// 更新自定义主体
- (void)updateCustomIDs:(NSDictionary <NSString*, NSString*>*)customIDs;

/// 更新用户信息
- (void)updateUserIdenty;

/// 查询出组试验结果
- (nullable SABExperimentResult *)queryOutResultWithParamName:(NSString *)paramName;

/// 查询 $ABTestTrigger 扩展属性
/// @param resultData 当前试验数据
- (nullable NSDictionary *)queryExtendedPropertiesWithExperimentResult:(SABExperimentResult *)resultData;


/// 命中试验，是否触发事件
/// @param resultData 命中的试验组信息
/// @return 是否触发事件
- (BOOL)enableTrackWithHitExperiment:(SABExperimentResult *)resultData;

@end

NS_ASSUME_NONNULL_END
