

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HNABJSONUtils.h"
#import "HNABLogBridge.h"
#import "HNABValidUtils.h"

@implementation HNABJSONUtils

/// json 数据解析
+ (nullable id)JSONObjectWithData:(NSData *)data {
    if (![HNABValidUtils isValidData:data]) {
        SABLogInfo(@"json data is nil");
        return nil;
    }
    NSError *jsonError = nil;
    id jsonObject = nil;
    @try {
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    } @catch (NSException *exception) {
        HNABLogError(@"%@", exception);
    } @finally {
        return jsonObject;
    }
}

/// JsonString 数据解析
+ (nullable id)JSONObjectWithString:(NSString *)string {
    if (![HNABValidUtils isValidString:string]) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        HNABLogError(@"string dataUsingEncoding failure:%@",string);
        return nil;
    }
    return [self JSONObjectWithData:data];
}

+ (nullable NSData *)JSONSerializeObject:(id)obj {
    if (![NSJSONSerialization isValidJSONObject:obj]) {
        return nil;
    }
    NSError *error = nil;
    NSData *data = nil;
    @try {
        data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
    }
    @catch (NSException *exception) {
        HNABLogError(@"%@ exception encoding api data: %@", self, exception);
    }
    if (error) {
        HNABLogError(@"%@ error encoding api data: %@", self, error);
    }
    return data;
}

+ (NSString *)stringWithJSONObject:(id)obj {
    NSData *jsonData = [self JSONSerializeObject:obj];
    if (![jsonData isKindOfClass:NSData.class]) {
        HNABLogError(@"json data is invalid");
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (id)JSONObjectByRemovingKeysWithNullValues:(id)object {
    if (!object) {
        return nil;
    }
    return [self JSONObjectByRemovingKeysWithNullValues:object options:0];
}

/// 移除 json 中的 null
/// 已有合法性判断，暂未使用
+ (id)JSONObjectByRemovingKeysWithNullValues:(id)object options:(NSJSONReadingOptions)readingOptions {
    if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)object count]];
        for (id value in (NSArray *)object) {
            if (![value isEqual:[NSNull null]]) {
                [mutableArray addObject:[HNABJSONUtils JSONObjectByRemovingKeysWithNullValues:value options:readingOptions]];
            }
        }

        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:object];
        for (id <NSCopying> key in [(NSDictionary *)object allKeys]) {
            id value = (NSDictionary *)object[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                mutableDictionary[key] = [HNABJSONUtils JSONObjectByRemovingKeysWithNullValues:value options:readingOptions];
            }
        }

        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }

    return object;
}
@end
