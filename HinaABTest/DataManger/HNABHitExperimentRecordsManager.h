

#import <Foundation/Foundation.h>
#import "HNABFetchResultResponse.h"

NS_ASSUME_NONNULL_BEGIN

/// 命中记录数据管理
@interface HNABHitExperimentRecordsManager : NSObject

/// 指定初始化接口
/// @param serialQueue 串行队列
- (instancetype)initWithSerialQueue:(dispatch_queue_t)serialQueue NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// 命中试验，是否需要触发事件
/// @param resultData 命中的试验组信息
/// @return 是否需要触发事件
- (BOOL)enableTrackWithHitExperiment:(SABExperimentResult *)resultData;


/// 查询当前用户的所有命中记录试验结果 Id
/// @param userIdenty 用户信息
/// @return 试验结果 Id 集合
- (nullable NSArray <NSString *> *)queryAllResultIdOfHitRecordsWithUser:(SABUserIdenty *)userIdenty;

@end

NS_ASSUME_NONNULL_END
