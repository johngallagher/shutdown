#import "JGAppDelegate.h"
#import "JGSystemDisabler.h"

@implementation JGAppDelegate

+(void)initialize {
  [super initialize];
  NSDateFormatter *format = [[NSDateFormatter alloc] init];
  [format setTimeStyle:NSDateFormatterShortStyle];
  [format setDateStyle:NSDateFormatterNoStyle];

  [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"startup": [format dateFromString:@"7:00"], @"shutdown": [format dateFromString:@"21:00"]}];
  [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
}

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [[NSUserDefaults standardUserDefaults] addObserver:self
                                          forKeyPath:@"startup"
                                             options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                                             context:NULL];
  [[NSUserDefaults standardUserDefaults] addObserver:self
                                          forKeyPath:@"shutdown"
                                             options:NSKeyValueObservingOptionNew
                                             context:NULL];
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setMenu:menu];
  [statusItem setAlternateImage:[NSImage imageNamed:NSImageNameLockLockedTemplate]];
  [statusItem setImage:[NSImage imageNamed:NSImageNameLockLockedTemplate]];
  [statusItem setHighlightMode:YES];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
  NSDate *startup = [object valueForKey:@"startup"];
  NSDate *shutdown = [object valueForKey:@"shutdown"];

  if([self startup:startup isBeforeShutdown:shutdown]) {
    NSLog(@"Startup and shutdown times are good...");
    state = [JGSystemDisabler disablerWithStartupTime:startup shutdownTime:shutdown disablerView:blockerView];
  } else {
    NSLog(@"Startup and shutdown times are invalid");
  }
}

-(BOOL)startup:(NSDate *)startup isBeforeShutdown:(NSDate *)shutdown {
  return [startup compare:shutdown] != NSOrderedDescending;
}

@end
