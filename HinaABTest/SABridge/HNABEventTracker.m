

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HNABEventTracker.h"
#import "HNABConstants.h"

static NSString * const kSALoginId = @"login_id";
static NSString * const kSADistinctId = @"distinct_id";
static NSString * const kSAAnonymousId = @"anonymous_id";
static NSString * const kSAProperties = @"properties";

@implementation HNABEventTracker

- (void)sensorsabtest_trackEvent:(NSMutableDictionary *)event isSignUp:(BOOL)isSignUp {
    NSString *eventName = event[@"event"];
    NSDictionary *properties = event[kSAProperties];

    if ([eventName isKindOfClass:[NSString class]] && [eventName isEqualToString: kSABTriggerEventName] && [properties isKindOfClass:[NSDictionary class]]) {

        // 实际为 NSMutableDictionary，直接修改即可，从而保证 SAEventTracker 日志打印中 distinct_id 等信息为修改后的
        NSMutableDictionary *tempEvent = event;
        if (![event isKindOfClass:NSMutableDictionary.class]) {
            tempEvent = [event mutableCopy];
        }

        // 用于移除 properties 中的 loginId, distinctId,anonymousId
        NSMutableDictionary *tempProperties = [properties mutableCopy];

        // 修改 loginId, distinctId,anonymousId
        if (properties[kSABLoginId]) {
            tempEvent[kSALoginId] = properties[kSABLoginId];
            tempProperties[kSABLoginId] = nil;
        }

        if (properties[kSABDistinctId]) {
            tempEvent[kSADistinctId] = properties[kSABDistinctId];
            tempProperties[kSABDistinctId] = nil;
        }

        if (properties[kSABAnonymousId]) {
            tempEvent[kSAAnonymousId] = properties[kSABAnonymousId];
            tempProperties[kSABAnonymousId] = nil;
        }

        tempEvent[kSAProperties] = tempProperties;
        [self sensorsabtest_trackEvent:tempEvent isSignUp:isSignUp];
    } else {
        [self sensorsabtest_trackEvent:event isSignUp:isSignUp];
    }
}

@end
