

#import <Foundation/Foundation.h>

#pragma mark libVersion
/// 当前版本号
extern NSString *const kSABLibVersion;

/// SA 最低支持版本
extern NSString *const kSABMinSupportedSALibVersion;

#pragma mark eventName
/// $ABTestTrigger 事件名
extern NSString *const kSABTriggerEventName;

#pragma mark propertyName
/// A/B 试验组 ID
extern NSString *const kSABTriggerExperimentId;

/// A/B 试验 ID
extern NSString *const kSABTriggerExperimentGroupId;

/// 采集插件版本号
extern NSString *const kSABLibPluginVersion;

/// abtesting iOS/macOS SDK 版本号
extern NSString *const kSABLibPrefix;

#pragma mark userId
extern NSString *const kSABLoginId;

extern NSString *const kSABDistinctId;

extern NSString *const kSABAnonymousId;

#pragma mark value
/// 请求试验 timeoutInterval 默认值
extern NSTimeInterval const kSABFetchABTestResultDefaultTimeoutInterval;

#pragma mark - fileName
/// 试验分流缓存文件名
extern NSString *const kSABExperimentResultFileName;

/// 自定义主体 ID
extern NSString *const kSABCustomIDsFileName;

/// 命中试验记录
extern NSString *const kHNABHitExperimentRecordSourcesFileName;

/// 事件触发配置
extern NSString *const kHNABTestTrackConfigFileName;


#pragma mark - NSNotificationName
#pragma mark H5 打通相关
/// SA 注入 H5 打通 Bridge
extern NSNotificationName const kSABSARegisterSAJSBridgeNotification;

/// H5 发送 abtest 消息
extern NSNotificationName const kSABSAMessageFromH5Notification;

#pragma mark 用户 id 变化
// login
extern NSNotificationName const kSABSALoginNotification;

// logout
extern NSNotificationName const kSABSALogoutNotification;

// identify
extern NSNotificationName const kSABSAIdentifyNotification;

// resetAnonymousId
extern NSNotificationName const kSABSAResetAnonymousIdNotification;

// 监听 SA 的生命周期通知，依赖版本 v2.6.3 及以上
extern NSNotificationName const kSABSAAppLifecycleStateDidChangeNotification;

#pragma mark 工具函数

void sabtest_dispatch_safe_sync(dispatch_queue_t queue,DISPATCH_NOESCAPE dispatch_block_t block);

void sabtest_dispatch_safe_async(dispatch_queue_t queue,DISPATCH_NOESCAPE dispatch_block_t block);
