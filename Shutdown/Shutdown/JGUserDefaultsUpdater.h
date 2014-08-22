#import <Foundation/Foundation.h>


@interface JGUserDefaultsUpdater : NSObject
@property(nonatomic, strong) NSDate *startupDate;
@property(nonatomic, strong) NSDate *shutdownDate;

@property(nonatomic) BOOL timesAreValid;
@end