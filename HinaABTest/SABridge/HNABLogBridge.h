

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define SENSORS_ABTEST_LOG_MACRO(isAsynchronous, lvl, fnct, ctx, frmt, ...) \
[HNABLogBridge log : isAsynchronous                                     \
     level : lvl                                                \
      file : __FILE__                                           \
  function : fnct                                               \
      line : __LINE__                                           \
   context : ctx                                                \
    format : (frmt), ## __VA_ARGS__]

#define HNABLogError(frmt, ...)   SENSORS_ABTEST_LOG_MACRO(YES, (1 << 0), __PRETTY_FUNCTION__, 0, frmt, ##__VA_ARGS__)
#define SABLogWarn(frmt, ...)   SENSORS_ABTEST_LOG_MACRO(YES, (1 << 1), __PRETTY_FUNCTION__, 0, frmt, ##__VA_ARGS__)
#define SABLogInfo(frmt, ...)   SENSORS_ABTEST_LOG_MACRO(YES, (1 << 2), __PRETTY_FUNCTION__, 0, frmt, ##__VA_ARGS__)
#define SABLogDebug(frmt, ...)   SENSORS_ABTEST_LOG_MACRO(YES, (1 << 3), __PRETTY_FUNCTION__, 0, frmt, ##__VA_ARGS__)
#define SABLogVerbose(frmt, ...)   SENSORS_ABTEST_LOG_MACRO(YES, (1 << 4), __PRETTY_FUNCTION__, 0, frmt, ##__VA_ARGS__)

@interface HNABLogBridge : NSObject

+ (void)log:(BOOL)asynchronous
   level:(NSUInteger)level
    file:(const char *)file
function:(const char *)function
    line:(NSUInteger)line
 context:(NSInteger)context
  format:(NSString *)format, ... NS_FORMAT_FUNCTION(7, 8);

@end

NS_ASSUME_NONNULL_END
