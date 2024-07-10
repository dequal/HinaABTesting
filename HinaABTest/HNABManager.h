

#import <Foundation/Foundation.h>
#import "HinaABTestConfigOptions.h"
#import "HinaABTestExperiment.h"

NS_ASSUME_NONNULL_BEGIN

/// 试验结果数据管理
@interface HNABManager : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// HNABManager 初始化
/// @param configOptions configOptions 参数配置
/// @return HNABManager 实例对象
- (instancetype)initWithConfigOptions:(HinaABTestConfigOptions *)configOptions NS_DESIGNATED_INITIALIZER;

/// 获取试验结果
/// @param experiment 试验实例对象
- (void)fetchABTestWithExperiment:(HinaABTestExperiment *)experiment;

/// 设置获取试验时的自定义主体 ID，全局有效
/// @param customIDs 自定义主体 ID
- (void)setCustomIDs:(NSDictionary <NSString*, NSString*> *)customIDs;

@end

NS_ASSUME_NONNULL_END
