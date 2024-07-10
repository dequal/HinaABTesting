

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "HNABNetwork.h"
#import "HNABLogBridge.h"
#import "HNABJSONUtils.h"

@interface HNABNetwork()

@property(nonatomic, strong) NSURLSession *session;

@end

@implementation HNABNetwork

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
        networkQueue.name = [NSString stringWithFormat:@"com.HinaABTest.HNABNetwork.%p", self];
        networkQueue.maxConcurrentOperationCount = 1;

        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.timeoutIntervalForRequest = 30;
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:networkQueue];
    }
    return self;
}

+ (instancetype) sharedInstance {
    static HNABNetwork *sharedInstance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    }) ;

    return sharedInstance;
}

+ (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(SABURLSessionTaskCompletionHandler)completionHandler {
    if (!request || !completionHandler) {
        return nil;
    }
    HNABNetwork *network = [HNABNetwork sharedInstance];
    NSURLSessionDataTask *task = [network.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (error || ![response isKindOfClass:[NSHTTPURLResponse class]]) {
            HNABLogError(@"Network dataTaskWithRequest failure, error: %@, response: %@",error, response);
            return completionHandler(nil, error);
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            completionHandler([HNABJSONUtils JSONObjectWithData:data], nil);
        } else {
            HNABLogError(@"Network dataTaskWithRequest failure, error: %@, response: %@",error, response);
            completionHandler(nil, error);
        }
    }];
    [task resume];
    return task;
}

@end
