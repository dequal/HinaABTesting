

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HNABRequestManager.h"
#import "HinaABTestExperiment+Private.h"


@interface HNABRequestTask : NSObject

@property (nonatomic, strong) SABExperimentRequest *request;
@property (nonatomic, strong) NSMutableArray<HinaABTestExperiment*>  *experiments;

@end

@implementation HNABRequestTask

- (instancetype)initWithRequest:(SABExperimentRequest *)request {
    self = [super init];
    if (self) {
        _request = request;
        _experiments = [NSMutableArray array];
    }
    return self;
}

@end

@interface HNABRequestManager ()

@property (nonatomic, strong) NSMutableArray<HNABRequestTask *> *tasks;
@end

@implementation HNABRequestManager

- (NSMutableArray<HNABRequestTask *> *)tasks {
    if (!_tasks) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
}

- (HNABRequestTask *)requestTask:(SABExperimentRequest *)request {
    __block HNABRequestTask *task;
    [self.tasks enumerateObjectsUsingBlock:^(HNABRequestTask * obj, NSUInteger idx, BOOL * stop) {
        // 当有相同任务时，将当前获取试验相关信息关联至相同任务上
        if ([obj.request isEqualToRequest:request]) {
            task = obj;
            *stop = YES;
        }
    }];
    return task;
}

- (BOOL)containsRequest:(SABExperimentRequest *)request {
    HNABRequestTask *task = [self requestTask:request];
    // 当前只针对 Fast 模式开启合并接口逻辑，后续针对 Async 模式也开启时，只需要修改此处逻辑即可
    return task.experiments.firstObject.modeType == SABFetchABTestModeTypeFast;
}

- (void)mergeExperimentWithRequest:(SABExperimentRequest *)request experiment:(HinaABTestExperiment *)experiment {
    HNABRequestTask *task = [self requestTask:request];
    [task.experiments addObject:experiment];
}

- (void)addRequestTask:(SABExperimentRequest *)request experiment:(HinaABTestExperiment *)experiment {
    HNABRequestTask *task = [[HNABRequestTask alloc] initWithRequest:request];
    [task.experiments addObject:experiment];
    [self.tasks addObject:task];
}

- (void)excuteExperimentsWithRequest:(SABExperimentRequest *)request completion:(void(^)(HinaABTestExperiment *))completion {
    HNABRequestTask *task = [self requestTask:request];
    // 当存在当前任务时，直接移除任务。防止在遍历过程中有新的任务合并进当前任务
    [self.tasks removeObject:task];

    if (task.experiments.count == 0) {
        return;
    }
    [task.experiments enumerateObjectsUsingBlock:^(HinaABTestExperiment * obj, NSUInteger idx, BOOL * stop) {
        completion(obj);
    }];
}

@end
