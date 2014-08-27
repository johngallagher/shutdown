#import <Foundation/Foundation.h>


@interface JGUserDefaultsUpdater : NSObject {

  NSUserDefaults *userDefaults;
}
@property(nonatomic, strong) NSDate *startupDate;
@property(nonatomic, strong) NSDate *shutdownDate;

@property(nonatomic) BOOL timesAreValid;

-(instancetype)initWithUserDefaults:(NSUserDefaults *)anUserDefaults;

+(instancetype)updaterWithUserDefaults:(NSUserDefaults *)anUserDefaults;

@end