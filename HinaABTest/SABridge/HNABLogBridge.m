

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HNABLogBridge.h"

typedef void (*SALogMethod)(id,SEL,BOOL,NSString*,NSUInteger,const char*,const char*,NSUInteger,NSInteger);

@implementation HNABLogBridge

+ (void)log:(BOOL)asynchronous level:(NSUInteger)level file:(const char *)file function:(const char *)function line:(NSUInteger)line context:(NSInteger)context format:(NSString *)format, ... {
    if (!format) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    Class saLogClass = NSClassFromString(@"HNLog");
    if (!saLogClass) {
        return;
    }
    SEL logMessageSEL = NSSelectorFromString(@"log:message:level:file:function:line:context:");
    SALogMethod logMessageIMP = (SALogMethod)[saLogClass methodForSelector:logMessageSEL];
    logMessageIMP(saLogClass,logMessageSEL,asynchronous,message,level,file,function,line,context);
}

@end
