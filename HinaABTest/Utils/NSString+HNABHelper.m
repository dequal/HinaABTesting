

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "NSString+HNABHelper.h"

@implementation NSString (SABHelper)

- (NSComparisonResult)sensorsabtest_compareVersion:(NSString *)version {
    NSArray<NSString *> *componentsA = [self componentsSeparatedByString:@"."];
    NSArray<NSString *> *componentsB = [version componentsSeparatedByString:@"."];
    NSUInteger length = MAX(componentsA.count, componentsB.count);
    for (NSUInteger index = 0; index < length; index++) {
        NSInteger num1 = index < componentsA.count ? [componentsA[index] integerValue] : 0;
        NSInteger num2 = index < componentsB.count ? [componentsB[index] integerValue] : 0;
        if (num1 < num2) {
            return NSOrderedAscending;
        } else if (num1 > num2) {
            return NSOrderedDescending;
        }
    }
    return NSOrderedSame;
}

@end
