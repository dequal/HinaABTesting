

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HNABStoreManager.h"

@interface SABaseStoreManager (SABPrivate)

@property (nonatomic, strong, readonly) NSMutableArray<id<SAStorePlugin>> *plugins;

@end

@implementation HNABStoreManager 

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HNABStoreManager*manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[HNABStoreManager alloc] init];
    });
    return manager;
}

- (BOOL)isRegisteredCustomStorePlugin {
    // 默认情况下 HinaABTesting 只有 1 个文件存储插件
    return self.plugins.count > 1;
}

@end
