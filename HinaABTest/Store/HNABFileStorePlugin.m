

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HNABFileStorePlugin.h"
#import "HNABLogBridge.h"

static NSString * const kHNABFileStorePluginType = @"cn.sensorsdata.ABTesting.File.";

@implementation HNABFileStorePlugin

- (NSString *)filePath:(NSString *)key {
    NSString *newKey = [key stringByReplacingOccurrencesOfString:self.type withString:@""];
    NSString *filename = [NSString stringWithFormat:@"sensorsanalytics-abtest-%@.plist", newKey];
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:filename];
    return filepath;
}

#pragma mark - SAStorePlugin

- (NSString *)type {
    return kHNABFileStorePluginType;
}

- (void)upgradeWithOldPlugin:(nonnull id<SAStorePlugin>)oldPlugin {

}

- (nullable id)objectForKey:(nonnull NSString *)key {
    if (!key) {
        HNABLogError(@"key should not be nil for file store");
        return nil;
    }
    NSString *filePath = [self filePath:key];
    @try {
        NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } @catch (NSException *exception) {
        HNABLogError(@"%@ unable to unarchive data in %@, starting fresh", self, filePath);
        return nil;
    }
}

- (void)setObject:(nullable id)value forKey:(nonnull NSString *)key {
    if (!key || !value) {
        HNABLogError(@"key should not be nil for file store");
        return;
    }
    NSString *filePath = [self filePath:key];
    
#if TARGET_OS_IOS
    /* 为filePath文件设置保护等级 */
    NSDictionary *protection = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                           forKey:NSFileProtectionKey];
#elif TARGET_OS_OSX
    // macOS10.13 不包含 NSFileProtectionComplete
    NSDictionary *protection = [NSDictionary dictionary];
#endif
    
    [[NSFileManager defaultManager] setAttributes:protection
                                     ofItemAtPath:filePath
                                            error:nil];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    if (![NSKeyedArchiver archiveRootObject:data toFile:filePath]) {
        HNABLogError(@"%@ unable to archive %@", self, key);
    } else {
        SABLogDebug(@"%@ archived %@", self, key);
    }
}

- (void)removeObjectForKey:(nonnull NSString *)key {
    NSString *filePath = [self filePath:key];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
}

@end
