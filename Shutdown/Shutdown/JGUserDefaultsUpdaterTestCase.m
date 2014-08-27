#import <XCTest/XCTest.h>
#import "JGUserDefaultsUpdater.h"

@interface JGUserDefaultsUpdaterTestCase : XCTestCase {
  NSUserDefaults *dummyDefaults;
  NSDate *today;
}
@end

@implementation JGUserDefaultsUpdaterTestCase
-(void)setUp {
  [super setUp];
  dummyDefaults = [[NSUserDefaults alloc] init];
  today = [NSDate date];

}

-(void)testSetsUpStartupAndShutdownOnInit {
  [dummyDefaults setObject:today forKey:@"startup"];
  [dummyDefaults setObject:[today dateByAddingTimeInterval:0.1] forKey:@"shutdown"];

  JGUserDefaultsUpdater *updater = [JGUserDefaultsUpdater updaterWithUserDefaults:dummyDefaults];
  XCTAssertEqualObjects([updater startupDate], today);
  XCTAssertEqualObjects([updater shutdownDate], [today dateByAddingTimeInterval:0.1]);
}

-(void)testDefaultsAreValidWhenShutdownIsAfterStartup {
  [dummyDefaults setObject:today forKey:@"startup"];
  [dummyDefaults setObject:[today dateByAddingTimeInterval:0.1] forKey:@"shutdown"];

  JGUserDefaultsUpdater *updater = [JGUserDefaultsUpdater updaterWithUserDefaults:dummyDefaults];
  XCTAssertTrue([updater timesAreValid]);
}

-(void)testDefaultsAreInvalidWhenShutdownIsBeforeStartup {
  [dummyDefaults setObject:today forKey:@"startup"];
  [dummyDefaults setObject:[today dateByAddingTimeInterval:-0.1] forKey:@"shutdown"];

  JGUserDefaultsUpdater *updater = [JGUserDefaultsUpdater updaterWithUserDefaults:dummyDefaults];
  XCTAssertFalse([updater timesAreValid]);
}

-(void)testDefaultsAreInvalidWhenTimesWhenEqual {
  [dummyDefaults setObject:today forKey:@"startup"];
  [dummyDefaults setObject:today forKey:@"shutdown"];
  
  JGUserDefaultsUpdater *updater = [JGUserDefaultsUpdater updaterWithUserDefaults:dummyDefaults];
  XCTAssertFalse([updater timesAreValid]);
}

@end
