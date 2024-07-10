

#import "HinaABTestExperiment.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @abstract
 * 获取试验结果方式类型
 *
 * @discussion
 * 获取试验结果方式类型
 *   SABFetchABTestModeType - 从缓存获取
 *   SABFetchABTestModeTypeAsync - 异步请求获取
 *   SABFetchABTestModeTypeFast - 快速获取（优先读缓存，无缓存再异步请求）
 */
typedef NS_ENUM(NSInteger, SABFetchABTestModeType) {
    SABFetchABTestModeTypeCache,
    SABFetchABTestModeTypeAsync,
    SABFetchABTestModeTypeFast
};

typedef void (^SABCompletionHandler)(id _Nullable result);

@interface HinaABTestExperiment (Private)

@property (nonatomic, assign) SABFetchABTestModeType modeType;
@property (nonatomic, copy) SABCompletionHandler handler;

@end

NS_ASSUME_NONNULL_END
