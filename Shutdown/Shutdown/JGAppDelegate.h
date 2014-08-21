#import <Cocoa/Cocoa.h>

@class JGSystemDisabler;

@interface JGAppDelegate : NSObject <NSApplicationDelegate> {
  JGSystemDisabler *state;
  IBOutlet NSView *blockerView;
  IBOutlet NSUserDefaultsController *defaultsController;
  NSStatusItem *statusItem;
  IBOutlet NSMenu *menu;
}

@property(assign) IBOutlet NSWindow *window;

@end
