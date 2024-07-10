

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HNABURLUtils.h"
#import "HNABLogBridge.h"

@interface HNABURLUtils()
@end

@implementation HNABURLUtils

+ (NSDictionary<NSString *, NSString *> *)queryItemsWithURLString:(NSString *)URLString {
    if (URLString.length == 0) {
        return nil;
    }
    NSURLComponents *components = [NSURLComponents componentsWithString:URLString];
    return [self queryItemsWithURLComponents:components];
}

+ (NSDictionary<NSString *, NSString *> *)queryItemsWithURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    return [self queryItemsWithURLComponents:components];
}

+ (NSURL *)baseURLWithURLString:(NSString *)URLString {
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLComponents *urlComponets = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    if (!urlComponets) {
        HNABLogError(@"URLString is malformed, nil is returned.");
        return nil;
    }
    urlComponets.query = nil;
    return urlComponets.URL;
}


+ (NSDictionary<NSString *, NSString *> *)queryItemsWithURLComponents:(NSURLComponents *)components {
    if (!components) {
        return nil;
    }
    NSMutableDictionary *items = [NSMutableDictionary dictionaryWithCapacity:components.queryItems.count];
    for (NSURLQueryItem *queryItem in components.queryItems) {
        items[queryItem.name] = queryItem.value;
    }
    return items;
}

@end
