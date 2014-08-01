#import "JGSystemState.h"
#import "JGTimer.h"
#import "JGSystemShutdown.h"


@implementation JGSystemState

@synthesize enabled;

-(instancetype)initWithStartup:(NSDate *)startupDate shutdown:(NSDate *)shutdownDate blockerView:(NSView *)aView shutdownDelegate:(id <JGSystemShutdown>)aDelegate {
    self = [super init];
    if (self) {
        enabled = [self currentDateIsBetween:startupDate andDate:shutdownDate];
        disabler = aDelegate;
        fullScreenBlockerView = aView;
        timer = [NSTimer scheduledTimerWithTimeInterval:[shutdownDate timeIntervalSinceNow]
                                                 target:self
                                               selector:@selector(timerDidFireWithObject:)
                                               userInfo:nil
                                                repeats:NO];

    }

    return self;
}

-(BOOL)currentDateIsBetween:(NSDate *)startupDate andDate:(NSDate *)shutdownDate {
    return (([[NSDate date] compare:startupDate] == NSOrderedDescending) && ([[NSDate date] compare:shutdownDate] == NSOrderedAscending));
}

-(void)timerDidFireWithObject:(id)object {
//    NSLog(@"Hey! I'm shutting down the system about now...");
    [disabler shutdown];
}

+(instancetype)stateWithStartup:(NSDate *)aStartup shutdown:(NSDate *)aShutdown blockerView:(NSView *)aView shutdownDelegate:(id <JGSystemShutdown>)aDelegate {
    return [[self alloc] initWithStartup:aStartup shutdown:aShutdown blockerView:aView shutdownDelegate:aDelegate];
}

@end
