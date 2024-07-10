

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HNABEventTracker : NSObject

/// hook SAEventTracker 对应方法，修改 distinct_id 等字段
- (void)sensorsabtest_trackEvent:(NSMutableDictionary *)event isSignUp:(BOOL)isSignUp;

@end

NS_ASSUME_NONNULL_END
