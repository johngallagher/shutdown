#import "JGDisabler.h"


@implementation JGDisabler

-(instancetype)initWithView:(NSView *)aView {
    self = [super init];
    if (self) {
        view = aView;
    }

    return self;
}

+(instancetype)disablerWithView:(NSView *)aView {
    return [[self alloc] initWithView:aView];
}


-(void)shutdown {
    NSDictionary *fullScreenOptions = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], NSFullScreenModeAllScreens,
//                                       [NSNumber numberWithInt:1],      NSFullScreenModeApplicationPresentationOptions,
//                                       [NSNumber numberWithInt:2],      NSFullScreenModeWindowLevel,
            nil];
    [view enterFullScreenMode:[NSScreen mainScreen] withOptions:fullScreenOptions];
    [NSApp activateIgnoringOtherApps:YES];

}


@end