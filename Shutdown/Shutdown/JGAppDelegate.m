#import "JGAppDelegate.h"
#import "JGSystemDisabler.h"

@interface JGAppDelegate ()
+(void)registerDefaults;

-(void)watchForWakeFromSleep;

-(void)watchForChangesInStartupShutdownTime;

-(void)addStatusMenuBar;

-(void)refreshSystemStateStartupDefaults:(NSUserDefaults *)defaults;

-(BOOL)startup:(NSDate *)startup isBeforeShutdown:(NSDate *)shutdown;
@end

@implementation JGAppDelegate

+(void)initialize {
  [super initialize];
  [self registerDefaults];
  [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
}

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self watchForChangesInStartupShutdownTime];
  [self addStatusMenuBar];
  [self watchForWakeFromSleep];
}

-(IBAction)showPreferencesWindow:(id)sender {
  [NSApp activateIgnoringOtherApps:YES];
  [[self window] makeKeyAndOrderFront:self];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
  [self refreshSystemStateStartupDefaults:object];
}

#pragma mark private methods

+(void)registerDefaults {
  NSDateFormatter *format = [[NSDateFormatter alloc] init];
  [format setTimeStyle:NSDateFormatterShortStyle];
  [format setDateStyle:NSDateFormatterNoStyle];

  [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"startup": [format dateFromString:@"7:45"], @"shutdown": [format dateFromString:@"21:00"]}];
}

-(void)watchForWakeFromSleep {
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                         selector:@selector(refreshSystemStateStartupDefaults:)
                                                             name:NSWorkspaceDidWakeNotification
                                                           object:[NSUserDefaults standardUserDefaults]];
}

-(void)watchForChangesInStartupShutdownTime {
  [[NSUserDefaults standardUserDefaults] addObserver:self
                                          forKeyPath:@"startup"
                                             options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                                             context:NULL];
  [[NSUserDefaults standardUserDefaults] addObserver:self
                                          forKeyPath:@"shutdown"
                                             options:NSKeyValueObservingOptionNew
                                             context:NULL];
}


-(void)addStatusMenuBar {
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setMenu:menu];
  [statusItem setAlternateImage:[NSImage imageNamed:NSImageNameLockLockedTemplate]];
  [statusItem setImage:[NSImage imageNamed:NSImageNameLockLockedTemplate]];
  [statusItem setHighlightMode:YES];
}

-(void)refreshSystemStateStartupDefaults:(NSUserDefaults *)defaults {
  NSDate *startup = [defaults valueForKey:@"startup"];
  NSDate *shutdown = [defaults valueForKey:@"shutdown"];
  if([self startup:startup isBeforeShutdown:shutdown]) {
    NSLog(@"Startup and shutdown times are good...");
    state = [JGSystemDisabler disablerWithStartupTime:startup shutdownTime:shutdown disablerView:blockerView];
  } else {
    NSLog(@"Startup and shutdown times are invalid");
  }
}

-(BOOL)startup:(NSDate *)startup isBeforeShutdown:(NSDate *)shutdown {
  return [startup compare:shutdown] == NSOrderedAscending;
}

@end
