

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HinaABTestExperiment.h"
#import "HNABConstants.h"
#import "HinaABTestExperiment+Private.h"

@interface HinaABTestExperiment ()

/// 试验参数
@property (nonatomic, copy, readwrite) NSString *paramName;

/// 默认值
@property (nonatomic, strong, readwrite) id defaultValue;

/// 获取类型
@property (nonatomic, assign) SABFetchABTestModeType modeType;

/// 回调函数
@property (nonatomic, copy) SABCompletionHandler handler;

@end

@implementation HinaABTestExperiment

- (instancetype)initWithParamName:(NSString *)paramName defaultValue:(id)defaultValue {
    self = [super init];
    if (self) {
        _paramName = paramName;
        _defaultValue = defaultValue;
        _timeoutInterval = kSABFetchABTestResultDefaultTimeoutInterval;
    }
    return self;
}

+ (HinaABTestExperiment *)experimentWithParamName:(NSString *)paramName defaultValue:(id)defaultValue {
    return [[HinaABTestExperiment alloc] initWithParamName:paramName defaultValue:defaultValue];
}

@end
