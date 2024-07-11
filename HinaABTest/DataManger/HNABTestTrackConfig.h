

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 事件触发配置
@interface HNABTestTrackConfig : NSObject<NSCoding>

/// 是否触发 H_ABTestTrigger 事件
@property (nonatomic, assign) BOOL triggerSwitch;

/// 是否任意事件都包含试验信息配置
@property (nonatomic, assign) BOOL propertySwitch;

/// H_ABTestTrigger 事件，扩展属性列表
@property (nonatomic, copy) NSArray *extendedPropertyKeys;

/// 扩展字段，是否为远程下发配置
@property (nonatomic, assign, getter=isRemoteConfig) BOOL remoteConfig;

/// 根据 json 初始化触发配置
- (instancetype)initWithDictionary:(NSDictionary *)triggerConfig;

@end

NS_ASSUME_NONNULL_END
