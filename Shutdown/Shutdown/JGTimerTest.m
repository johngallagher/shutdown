#import <XCTest/XCTest.h>
#import "JGTimer.h"
#import "JGTimerDelegate.h"
#import <OCMock/OCMock.h>

@interface JGTimerTest : XCTestCase

@end

@implementation JGTimerTest

-(void)setUp {
    [super setUp];
}

-(void)tearDown {
    [super tearDown];
}

-(void)testDelegateMethodIsCalledWhenTimerFires {
    id testDelegate = OCMProtocolMock(@protocol(JGTimerDelegate));
    OCMExpect([testDelegate timerDidFireWithObject:[OCMArg any]]);
    [JGTimer timerWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.0001] delegate:testDelegate];
    OCMVerifyAllWithDelay(testDelegate, 0.0002);
}

-(void)testDelegateMethodIsntCalledWhenTimerSetToZero {
    id testDelegate = OCMProtocolMock(@protocol(JGTimerDelegate));
    [JGTimer timerWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.0001] delegate:testDelegate];
    OCMVerifyAll(testDelegate);
}

@end
