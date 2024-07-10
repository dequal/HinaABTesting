

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HNABHitExperimentRecordsManager.h"
#import "HNABHitExperimentRecordSources.h"
#import "HNABStoreManager.h"
#import "HNABConstants.h"

@interface HNABHitExperimentRecordsManager()

/// 所有用户的命中记录
@property (nonatomic, strong) NSMutableArray<HNABHitExperimentRecordSources *> *allHitExperimentRecordSources;

@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation HNABHitExperimentRecordsManager

#pragma mark - initialize
- (instancetype)initWithSerialQueue:(dispatch_queue_t)serialQueue {
    self = [super init];
    if (self) {
        _serialQueue = serialQueue;

        // 解析本地命中记录
        [self unarchiveABTestHitExperimentRecordSources];
    }

    return self;
}

/// 解析本地命中试验记录
- (void)unarchiveABTestHitExperimentRecordSources {
    dispatch_async(self.serialQueue, ^{
        NSData *data = [HNABStoreManager.sharedInstance objectForKey:kHNABHitExperimentRecordSourcesFileName];
        NSArray <HNABHitExperimentRecordSources *> *results = nil;
        if ([data isKindOfClass:NSData.class]) {
            results = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        self.allHitExperimentRecordSources = [NSMutableArray arrayWithArray:results];
    });
}

/// 缓存所有命中试验记录
 - (void)archiveABTestHitExperimentRecordSources {
     if (self.allHitExperimentRecordSources.count == 0) {
         return;
     }
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[self.allHitExperimentRecordSources copy]];
     dispatch_async(self.serialQueue, ^{
         // 存储到本地
         [HNABStoreManager.sharedInstance setObject:data forKey:kHNABHitExperimentRecordSourcesFileName];
     });
 }

#pragma mark - HitExperimentRecords
- (BOOL)enableTrackWithHitExperiment:(SABExperimentResult *)resultData {
    if (!resultData) {
        return NO;
    }

    // 构建命中试验记录
    SABHitExperimentRecord *experimentRecord = [[SABHitExperimentRecord alloc] initWithExperimentResult:resultData];

    // 查询当前试验对应用户的所有命中记录
    HNABHitExperimentRecordSources *currentUserRecordSources = [self queryHitExperimentRecordSourcesWithExperimentResult:resultData];

    if (currentUserRecordSources) {
        SABHitExperimentRecord *historyExperimentRecord = currentUserRecordSources.experimentRecords[resultData.experimentId];

        // 计算当前试验和历史命中记录的匹配类型
        SABExperimentMachResultType machResultType = [experimentRecord matchResultWithExperimentIdentifier:historyExperimentRecord];
        switch (machResultType) {
                // 试验 Id 匹配，试验组不同，移除缓存试验记录
            case SABExperimentMachResultTypeExperimentId:
                currentUserRecordSources.experimentRecords[resultData.experimentId] = nil;
                break;
                // 命中记录中匹配标识相同的试验，不再触发事件
            case SABExperimentMachResultTypeResultId:
                return NO;
            default:
                break;
        }

        // 保存当前试验记录
        [currentUserRecordSources insertHitExperimentRecord:experimentRecord];
    } else { // 不存在匹配用户的命中试验记录，新增一个用户的命中试验记录
        currentUserRecordSources = [[HNABHitExperimentRecordSources alloc] initWithExperimentResult:resultData];
        [self.allHitExperimentRecordSources addObject:currentUserRecordSources];
    }

    // 新命中试验，缓存命中记录
    [self archiveABTestHitExperimentRecordSources];

    return YES;
}

/// 查询当前用户的所有命中记录的标识
- (NSArray <NSString *> *)queryAllResultIdOfHitRecordsWithUser:(SABUserIdenty *)userIdenty {
    NSMutableSet <NSString *>*allResultIds = [NSMutableSet set];

    // 构建当前可能的用户
    // 用户主体
    SABUserIdenty *userSubject = [[SABUserIdenty alloc] initWithSubjectType:SABUserSubjectTypeUser subjectId:userIdenty.distinctId];

    // 设备主体
    SABUserIdenty *deviceSubject = [[SABUserIdenty alloc] initWithSubjectType:SABUserSubjectTypeDevice subjectId:userIdenty.anonymousId];

    // 自定义主体
    SABUserIdenty *customSubject = nil;
    if (userIdenty.customIDs.count > 0) {
        NSString *customId = [userIdenty.customIDs.allValues firstObject];
        customSubject = [[SABUserIdenty alloc] initWithSubjectType:SABUserSubjectTypeCustom subjectId:customId];
    }

    // 查询当前 App 所有用户的命中记录
    for (HNABHitExperimentRecordSources *recordSources in self.allHitExperimentRecordSources) {
        if ([recordSources.userIdenty isEqualUserIdenty:userSubject] || [recordSources.userIdenty isEqualUserIdenty:deviceSubject] || [recordSources.userIdenty isEqualUserIdenty:customSubject]) {
            for (SABHitExperimentRecord *experimentRecord in recordSources.experimentRecords.allValues) {
                [allResultIds addObject:experimentRecord.experimentResultId];
            }
        }
    }

    // experimentResultId = -1 为出组，需移除
    [allResultIds  removeObject:@"-1"];
    return [allResultIds allObjects];
}

/// 查询当前试验对应用户的命中记录
- (HNABHitExperimentRecordSources *)queryHitExperimentRecordSourcesWithExperimentResult:(SABExperimentResult *)experimentResult {
    for (HNABHitExperimentRecordSources *recordSources in self.allHitExperimentRecordSources) {
        if ([recordSources.userIdenty isEqualUserIdenty:experimentResult.userIdenty]) {
            return recordSources;
        }
    }
    return nil;
}

@end
