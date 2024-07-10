

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HNABPropertyValidator : NSObject

+ (NSDictionary *_Nullable)validateProperties:(NSDictionary *)properties error:(NSError **)error;

+ (NSDictionary *_Nullable)validateCustomIDs:(NSDictionary<NSString*, NSString*> * _Nullable)customIDs;

@end

NS_ASSUME_NONNULL_END
