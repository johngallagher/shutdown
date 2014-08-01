#import "JGSystemDisabler.h"
#import "JGTimer.h"
#import "SystemShutdown.h"


@implementation JGSystemDisabler {

}
@synthesize enabled;

@synthesize startup;

-(instancetype)initWithStartup:(NSDate *)aStartup shutdown:(NSDate *)aDate blockerView:(NSView *)aView {
    self = [super init];
    if (self) {
        fullScreenBlockerView = aView;
        timer = [NSTimer scheduledTimerWithTimeInterval:[aDate timeIntervalSinceNow]
                                                 target:self
                                               selector:@selector(timerDidFireWithObject:)
                                               userInfo:nil
                                                repeats:NO];

    }

    return self;
}

-(void)timerDidFireWithObject:(id)object {
    // Now shutdown the system
    NSLog(@"Hey! I'm shutting down the system about now...");

    NSDictionary *fullScreenOptions = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES],   NSFullScreenModeAllScreens,
//                                       [NSNumber numberWithInt:1],      NSFullScreenModeApplicationPresentationOptions,
//                                       [NSNumber numberWithInt:2],      NSFullScreenModeWindowLevel,                                       
            nil];
    [fullScreenBlockerView enterFullScreenMode:[NSScreen mainScreen] withOptions:fullScreenOptions];
    [NSApp activateIgnoringOtherApps:YES];

}

+(instancetype)stateWithStartup:(NSDate *)aStartup shutdown:(NSDate *)aShutdown blockerView:(NSView *)aView {
    return [[self alloc] initWithStartup:aStartup shutdown:aShutdown blockerView:aView];
}

@end