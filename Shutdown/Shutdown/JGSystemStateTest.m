#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "JGSystemDisabler.h"
#import "JGSystemShutdown.h"


@interface JGSystemStateTest : XCTestCase

@end

@implementation JGSystemStateTest

-(void)testWhenOutsideTheTimeRangeTheSystemShouldBeDisabled {
    id <JGSystemShutdown> shutdownMock = OCMProtocolMock(@protocol(JGSystemShutdown));
  [JGSystemDisabler disablerWithStartupTime:[NSDate dateWithTimeIntervalSinceNow:-0.0001] shutdownTime:[NSDate dateWithTimeIntervalSinceNow:0.01] disablerView:nil];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.02]];
    OCMVerify([shutdownMock shutdown]);
}

-(void)testWhenTimeIsInsideRangeSystemShouldBeEnabled {
    JGSystemDisabler *state = [JGSystemDisabler disablerWithStartupTime:[NSDate dateWithTimeIntervalSinceNow:-0.001] shutdownTime:[NSDate dateWithTimeIntervalSinceNow:0.001] disablerView:nil];

    XCTAssertTrue([state enabled]);
}

-(void)testWhenTimeIsAfterRangeSystemShouldBeDisabled {
    JGSystemDisabler *state = [JGSystemDisabler disablerWithStartupTime:[NSDate dateWithTimeIntervalSinceNow:-0.002] shutdownTime:[NSDate dateWithTimeIntervalSinceNow:-0.001] disablerView:nil];

    XCTAssertFalse([state enabled]);
}

-(void)testWhenTimeIsBeforeRangeSystemShouldBeDisabled {
    JGSystemDisabler *state = [JGSystemDisabler disablerWithStartupTime:[NSDate dateWithTimeIntervalSinceNow:0.001] shutdownTime:[NSDate dateWithTimeIntervalSinceNow:0.002] disablerView:nil];

    XCTAssertFalse([state enabled]);
}
@end
