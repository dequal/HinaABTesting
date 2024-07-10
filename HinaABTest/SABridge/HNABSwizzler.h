

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HNABSwizzler : NSObject

+ (void)swizzleSATrackEvent;

@end


@interface NSObject (HNABSwizzler)

+ (void)sensorsabtest_swizzle:(SEL)originalSelector withSelector:(SEL)destinationSelector destinationClass:(Class)destinationClass;

@end


NS_ASSUME_NONNULL_END
