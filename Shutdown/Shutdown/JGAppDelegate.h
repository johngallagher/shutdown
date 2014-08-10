#import <Cocoa/Cocoa.h>

@class JGSystemDisabler;

@interface JGAppDelegate : NSObject <NSApplicationDelegate> {
  JGSystemDisabler *state;
  IBOutlet NSView *blockerView;
}

@property(assign) IBOutlet NSWindow *window;

@end
