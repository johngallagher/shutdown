#import "JGTimer.h"
#import "JGTimerDelegate.h"


@implementation JGTimer {
}

+(JGTimer *)timerWithFireDate:(NSDate *)aDate delegate:(id <JGTimerDelegate>)aDelegate {
    return [[self alloc] initWithDate:aDate delegate:aDelegate];
}

-(instancetype)initWithDate:(NSDate *)aDate delegate:(id <JGTimerDelegate>)aDelegate {
    self = [super init];
    if (self) {
        delegate = aDelegate;
        timer = [NSTimer scheduledTimerWithTimeInterval:[aDate timeIntervalSinceNow]
                                                 target:delegate
                                               selector:@selector(timerDidFireWithObject:)
                                               userInfo:nil
                                                repeats:NO];
    }

    return self;
}


@end