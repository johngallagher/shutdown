#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "JGSystemDisabler.h"
#import "SystemShutdown.h"


@interface JGSystemDisablerTest : XCTestCase

@end

@implementation JGSystemDisablerTest

-(void)setUp {
    [super setUp];
}

-(void)tearDown {
    [super tearDown];
}

-(void)testWhenOutsideTheTimeRangeTheSystemShouldBeDisabled {
    id <SystemShutdown> shutdownMock = OCMProtocolMock(@protocol(SystemShutdown));
    JGSystemDisabler *state = [JGSystemDisabler stateWithStartup:[NSDate dateWithTimeIntervalSinceNow:-0.0001] shutdown:[NSDate dateWithTimeIntervalSinceNow:0.0001] blockerView:nil];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0002]];
    OCMVerify([shutdownMock shutdown]);
}


@end
