#import <Cocoa/Cocoa.h>

@class JGSystemState;

@interface JGAppDelegate : NSObject <NSApplicationDelegate> {
    JGSystemState *_disabler;
    IBOutlet NSView *blockerView;
}


@property (assign) IBOutlet NSWindow *window;
@end
