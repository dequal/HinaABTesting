
#import "ViewController.h"
#import "WKWebViewController.h"
#import <HinaABTest.h>
#import <SensorsAnalyticsSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.rowHeight = 50;
    self.tableView.sectionHeaderHeight = 12;
    self.tableView.sectionFooterHeight = 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    switch (section) {
        case 0: {// fetchCache
            switch (row) {
                case 0: { // INTEGER
                    id result = [[HinaABTest sharedInstance] fetchCacheABTestWithParamName:@"color1" defaultValue:@(1111)];
                    NSLog(@"fetchCacheABTest，paramName：%@ - result:%@\n", @"color1", result);
                }
                    break;
                    
                case 1: { // BOOLEAN
                    id result = [[HinaABTest sharedInstance] fetchCacheABTestWithParamName:@"16" defaultValue:@(NO)];
                    NSLog(@"fetchCacheABTest，paramName：%@ - result:%@\n", @"16", result);
                }
                    break;
                    
                case 2: { // STRING
                    id result = [[HinaABTest sharedInstance] fetchCacheABTestWithParamName:@"hef_tes" defaultValue:@"默认值字符串"];
                    NSLog(@"fetchCacheABTest，paramName：%@ - result:%@\n", @"hef_tes", result);
                }
                    break;
                    
                case 3: { // JSON
                    id result = [[HinaABTest sharedInstance] fetchCacheABTestWithParamName:@"color4" defaultValue:@{}];
                    NSLog(@"fetchCacheABTest，paramName：%@ - result:%@\n", @"color4", result);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1: { // asyncFetch
            switch (row) {
                case 0: { // INTEGER
                    [[HinaABTest sharedInstance] asyncFetchABTestWithParamName:@"color1" defaultValue:@(1111) completionHandler:^(id _Nullable result) {
                        NSLog(@"asyncFetchABTest，paramName：%@ - result:%@\n", @"color1", result);
                    }];
                }
                    break;
                    
                case 1: { // BOOLEAN
                    [[HinaABTest sharedInstance] asyncFetchABTestWithParamName:@"color3" defaultValue:@(NO) completionHandler:^(id _Nullable result) {
                        NSLog(@"asyncFetchABTest，paramName：%@ - result:%@\n", @"color3", result);
                    }];
                }
                    break;
                    
                case 2: { // STRING
                    [[HinaABTest sharedInstance] asyncFetchABTestWithParamName:@"color2" defaultValue:@"默认值字符串" completionHandler:^(id _Nullable result) {
                        NSLog(@"asyncFetchABTest，paramName：%@ - result:%@\n", @"color2", result);
                    }];
                }
                    break;
                    
                case 3: { // JSON
                    [[HinaABTest sharedInstance] asyncFetchABTestWithParamName:@"color4" defaultValue:@{} completionHandler:^(id _Nullable result) {
                        NSLog(@"asyncFetchABTest，paramName：%@ - result:%@\n", @"color4", result);
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2: { // fastFetch
            switch (row) { // 试验 Id
                case 0: { // INTEGER
                    [[HinaABTest sharedInstance] fastFetchABTestWithParamName:@"color1" defaultValue:@(1111) completionHandler:^(id _Nullable result) {
                        NSLog(@"fastFetchABTest，paramName：%@ - result:%@\n", @"color1", result);
                    }];
                    
                }
                    break;
                    
                case 1: { // BOOLEAN
                    [[HinaABTest sharedInstance] fastFetchABTestWithParamName:@"color3" defaultValue:@(NO) completionHandler:^(id _Nullable result) {
                        NSLog(@"fastFetchABTest，paramName：%@ - result:%@\n", @"color3", result);
                    }];
                }
                    break;
                    
                case 2: { // STRING
                    [[HinaABTest sharedInstance] fastFetchABTestWithParamName:@"color2" defaultValue:@"默认值字符串" completionHandler:^(id _Nullable result) {
                        NSLog(@"fastFetchABTest，paramName：%@ - result:%@\n", @"color2", result);
                    }];
                }
                    break;
                    
                case 3: { // JSON
                    [[HinaABTest sharedInstance] fastFetchABTestWithParamName:@"color4" defaultValue:@{} completionHandler:^(id _Nullable result) {
                        NSLog(@"fastFetchABTest，paramName：%@ - result:%@\n", @"color4", result);
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3: { // Subject 多主体，fache 接口
            switch (row) { //
                case 0: { // user 主体
                    id result = [[HinaABTest sharedInstance] fetchCacheABTestWithParamName:@"cqs_index" defaultValue:@(1111)];
                    NSLog(@"fetchCacheABTest，Subject User，paramName：%@ - result:%@\n", @"cqs_index", result);
                }
                    break;
                    
                case 1: { // device 主体
                    id result = [[HinaABTest sharedInstance] fetchCacheABTestWithParamName:@"cqs_color" defaultValue:@"默认试验值"];
                    NSLog(@"fetchCacheABTest，Subject Device，paramName：%@ - result:%@\n", @"cqs_color", result);
                }
                    break;
                case 2: { // custom 主体
                    id result = [[HinaABTest sharedInstance] fetchCacheABTestWithParamName:@"cqs_os" defaultValue:@"默认试验值"];
                    NSLog(@"fetchCacheABTest，Subject Custom，paramName：%@ - result:%@\n", @"cqs_os", result);
                }
                    break;
                case 3: { // 自定义属性试验
                    HinaABTestExperiment *experiment = [[HinaABTestExperiment alloc] initWithParamName:@"cqs_device" defaultValue:@"设备默认值"];
                    experiment.properties = @{@"device": @"iPhone"};
                    [[HinaABTest sharedInstance] fastFetchABTestWithExperiment:experiment completionHandler:^(id  _Nullable result) {

                        NSLog(@"fastFetchABTestWithExperiment，自定义属性 device 试验，paramName：%@ - result:%@\n", @"cqs_device", result);
                    }];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 4: { // other
            switch (row) { //
                case 0: { // flush
                    [[SensorsAnalyticsSDK sharedInstance] flush];
                }
                    break;

                case 1: { // go webView
                    WKWebViewController *webViewVC = [[WKWebViewController alloc] init];
                    [self.navigationController pushViewController:webViewVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 5: { // login、logout、identify 、resetAnonymousId
            switch (row) {
                case 0: { // login
                    [[SensorsAnalyticsSDK sharedInstance] login:@"login_test_20201217" withProperties:@{ @"name": @"batest_relod_login" }];
                }
                    break;
                    
                case 1: { // logout
                    [[SensorsAnalyticsSDK sharedInstance] logout];
                }
                    break;
                    
                case 2: { // identify
                    [[SensorsAnalyticsSDK sharedInstance] identify:@"abtest_relod_identify_1234567"];
                }
                    break;
                    
                case 3: { // resetAnonymousId
                    [[SensorsAnalyticsSDK sharedInstance] resetAnonymousId];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            // other
        case 6: {
            switch (row) {
                case 0: {
                    
                    dispatch_queue_t serialQueue1 = dispatch_queue_create([@"test1" UTF8String], DISPATCH_QUEUE_SERIAL);
                    dispatch_queue_t serialQueue2 = dispatch_queue_create([@"test2" UTF8String], DISPATCH_QUEUE_SERIAL);
                    dispatch_queue_t serialQueue3 = dispatch_queue_create([@"test3" UTF8String], DISPATCH_QUEUE_SERIAL);
                    
                    for (NSInteger index = 0; index < 1000; index ++) {
                        dispatch_async(serialQueue1, ^{
                            id result = [[HinaABTest sharedInstance] fetchCacheABTestWithParamName:@"index_cqs" defaultValue:@(1111)];
                            NSLog(@"fetchCacheABTest1，paramName：%@ - result:%@\n", @"index_cqs", result);
                        });
                        
                        dispatch_async(serialQueue2, ^{
                            id result = [[HinaABTest sharedInstance] fetchCacheABTestWithParamName:@"index_cqs" defaultValue:@(2222)];
                            NSLog(@"fetchCacheABTest2，paramName：%@ - result:%@\n", @"index_cqs", result);
                        });
                        
                        dispatch_async(serialQueue3, ^{
                            id result = [[HinaABTest sharedInstance] fetchCacheABTestWithParamName:@"index_cqs" defaultValue:@(3333)];
                            NSLog(@"fetchCacheABTest3，paramName：%@ - result:%@\n", @"index_cqs", result);
                        });
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
        default:
            break;
    }
}

@end
