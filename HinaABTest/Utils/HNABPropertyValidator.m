

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HNABPropertyValidator.h"
#import "HNABJSONUtils.h"
#import "HNABLogBridge.h"

#define HNABPropertyError(errorCode, fromat, ...) \
    [NSError errorWithDomain:@"SensorsABTestErrorDomain" \
                        code:errorCode \
                    userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:fromat,##__VA_ARGS__]}] \

static NSUInteger const kSABPropertyLengthLimitation = 8191;

@protocol SABPropertyKeyValidateProtocol <NSObject>

- (BOOL)sensorsabtest_validatePropertyKey;

@end

@protocol SABPropertyValueValidateProtocol <NSObject>

- (NSString *)sensorsabtest_validatePropertyValue;

@end

@interface NSString (HNABPropertyValidator) <SABPropertyKeyValidateProtocol,SABPropertyValueValidateProtocol>

@end

@implementation NSString (HNABPropertyValidator)

static NSRegularExpression *_regexForValidKey;

- (BOOL)sensorsabtest_validatePropertyKey {
    if (self.length < 1) {
        return NO;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *name = @"^([a-zA-Z_][a-zA-Z\\d_]{0,99})$";
        _regexForValidKey = [NSRegularExpression regularExpressionWithPattern:name options:NSRegularExpressionCaseInsensitive error:nil];
    });
    // 保留字段通过字符串直接比较，效率更高
    NSSet *reservedProperties = [NSSet setWithObjects:@"date", @"datetime", @"distinct_id", @"event", @"events", @"first_id", @"id", @"original_id", @"properties", @"second_id", @"time", @"user_id", @"users", nil];
    for (NSString *reservedProperty in reservedProperties) {
        if ([reservedProperty caseInsensitiveCompare:self] == NSOrderedSame) {
            return NO;
        }
    }
    // 属性名通过正则表达式匹配，比使用谓词效率更高
    NSRange range = NSMakeRange(0, self.length);
    return ([_regexForValidKey numberOfMatchesInString:self options:0 range:range] > 0);
}

- (NSString *)sensorsabtest_validatePropertyValue {
    if (self.length < 1 || self.length > kSABPropertyLengthLimitation) {
        return nil;
    }
    return self;
}

@end

@interface NSNumber (HNABPropertyValidator) <SABPropertyValueValidateProtocol>

@end

@implementation NSNumber (HNABPropertyValidator)

- (NSString *)sensorsabtest_validatePropertyValue {
    return self.stringValue;
}

@end

@interface NSArray (HNABPropertyValidator) <SABPropertyValueValidateProtocol>

@end

@implementation NSArray (HNABPropertyValidator)

- (NSString *)sensorsabtest_validatePropertyValue {
    for (NSString *item in self) {
        if (![item isKindOfClass:NSString.class]) {
            return nil;
        }
        NSString *result = [(id<SABPropertyValueValidateProtocol>)item sensorsabtest_validatePropertyValue];
        if (!result) {
            return nil;
        }
    }
    return [HNABJSONUtils stringWithJSONObject:self];
}

@end

@interface NSSet (HNABPropertyValidator) <SABPropertyValueValidateProtocol>

@end

@implementation NSSet (HNABPropertyValidator)

- (NSString *)sensorsabtest_validatePropertyValue {
    for (NSString *item in self) {
        if (![item isKindOfClass:NSString.class]) {
            return nil;
        }

        NSString *result = [(id<SABPropertyValueValidateProtocol>)item sensorsabtest_validatePropertyValue];
        if (!result) {
            return nil;
        }
    }
    return [HNABJSONUtils stringWithJSONObject:self];
}

@end

@interface NSDate (HNABPropertyValidator) <SABPropertyValueValidateProtocol>

@end

@implementation NSDate (HNABPropertyValidator)

- (NSString *)sensorsabtest_validatePropertyValue {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    if (dateFormatter) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }
    return [dateFormatter stringFromDate:self];
}

@end

@implementation HNABPropertyValidator

+ (NSDictionary *_Nullable)validateProperties:(NSDictionary *)properties error:(NSError **)error {
    if (![properties isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (id key in properties) {
        if (![key conformsToProtocol:@protocol(SABPropertyKeyValidateProtocol)]) { // 键名类型不合法
            *error = HNABPropertyError(10001, @"property name [ %@ ] is not valid", key);
            return nil;
        }
        id value = properties[key];
        if (![value conformsToProtocol:@protocol(SABPropertyValueValidateProtocol)]) { // 键值类型不合法
            *error = HNABPropertyError(10002, @"property values must be String, Number, Boolean, String List or Date. property [ %@ ] of value [ %@ ] is not valid", key, value);
            return nil;
        }
        if (![key sensorsabtest_validatePropertyKey]) { // 键名内容不合法
            *error = HNABPropertyError(10003, @"property name [ %@ ] is not valid", key);
            return nil;
        }
        NSString *newValue = [value sensorsabtest_validatePropertyValue];
        if (!newValue) { // 键值内容不合法
            *error = HNABPropertyError(10004, @"property [ %@ ] of value [ %@ ] is not valid ", key, value);
            return nil;
        }
        result[key] = newValue;
    }
    return result;
}

+ (NSDictionary * _Nullable)validateCustomIDs:(NSDictionary<NSString*, NSString*> * _Nullable)customIDs {
    if (![customIDs isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (id key in customIDs) {
        if (![key isKindOfClass:NSString.class]) { // 键名类型不合法
            HNABLogError(@"customID name [ %@ ] is not valid", key);
            continue;
        }
        if (![key sensorsabtest_validatePropertyKey]) { // 键名内容不合法
            HNABLogError(@"customID name [ %@ ] is not valid", key);
            continue;
        }

        id value = customIDs[key];
        if (![value isKindOfClass:NSString.class]) { // 键值类型不合法
            HNABLogError(@"customID values must be String. customID [ %@ ] of value [ %@ ] is not valid", key, value);
            // 只报错提示，保留内容
            result[key] = value;
            continue;
        }

        NSString *newValue = (NSString *)value;
        if (newValue.length < 1 || newValue.length > 1024) { // 键值内容不合法
            HNABLogError(@"customID [ %@ ] of value [ %@ ] is not valid ", key, value);
        }
        result[key] = newValue;
    }
    return result;
}


@end
