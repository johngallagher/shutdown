#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "JGSystemState.h"
#import "JGSystemShutdown.h"


@interface JGSystemStateTest : XCTestCase

@end

@implementation JGSystemStateTest

-(void)testWhenOutsideTheTimeRangeTheSystemShouldBeDisabled {
    id <JGSystemShutdown> shutdownMock = OCMProtocolMock(@protocol(JGSystemShutdown));
    [JGSystemState stateWithStartup:[NSDate dateWithTimeIntervalSinceNow:-0.0001]
                                                      shutdown:[NSDate dateWithTimeIntervalSinceNow:0.01]
                                                   blockerView:nil
                                              shutdownDelegate:shutdownMock];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.02]];
    OCMVerify([shutdownMock shutdown]);
}

-(void)testWhenTimeIsInsideRangeSystemShouldBeEnabled {
    JGSystemState *state = [JGSystemState stateWithStartup:[NSDate dateWithTimeIntervalSinceNow:-0.001]
                                                      shutdown:[NSDate dateWithTimeIntervalSinceNow:0.001]
                                                   blockerView:nil
                                              shutdownDelegate:nil];

    XCTAssertTrue([state enabled]);
}

-(void)testWhenTimeIsAfterRangeSystemShouldBeDisabled {
    JGSystemState *state = [JGSystemState stateWithStartup:[NSDate dateWithTimeIntervalSinceNow:-0.002]
                                                      shutdown:[NSDate dateWithTimeIntervalSinceNow:-0.001]
                                                   blockerView:nil
                                              shutdownDelegate:nil];

    XCTAssertFalse([state enabled]);
}

-(void)testWhenTimeIsBeforeRangeSystemShouldBeDisabled {
    JGSystemState *state = [JGSystemState stateWithStartup:[NSDate dateWithTimeIntervalSinceNow:0.001]
                                                      shutdown:[NSDate dateWithTimeIntervalSinceNow:0.002]
                                                   blockerView:nil
                                              shutdownDelegate:nil];

    XCTAssertFalse([state enabled]);
}
@end
