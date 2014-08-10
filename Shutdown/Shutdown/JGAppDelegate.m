#import "JGAppDelegate.h"
#import "JGSystemDisabler.h"

@implementation JGAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [[NSUserDefaults standardUserDefaults] addObserver:self
                                          forKeyPath:@"shutdown"
                                             options:NSKeyValueObservingOptionNew
                                             context:NULL];
  [[NSUserDefaults standardUserDefaults] addObserver:self
                                          forKeyPath:@"startup"
                                             options:NSKeyValueObservingOptionNew
                                             context:NULL];
  [[NSUserDefaults standardUserDefaults] setValue:[NSDate dateWithTimeIntervalSinceNow:5] forKey:@"startup"];
  [[NSUserDefaults standardUserDefaults] setValue:[NSDate dateWithTimeIntervalSinceNow:10] forKey:@"shutdown"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
  NSDate *startup = [object valueForKey:@"startup"];
  NSDate *shutdown = [object valueForKey:@"shutdown"];

  if([self startup:startup isBeforeShutdown:shutdown]) {
    NSLog(@"Startup and shutdown times are good...");
    state = [JGSystemDisabler disablerWithStartup:startup shutdown:shutdown disablerView:blockerView];
  } else {
    NSLog(@"Startup and shutdown times are invalid");
  }
}

-(BOOL)startup:(NSDate *)startup isBeforeShutdown:(NSDate *)shutdown {
  return [startup compare:shutdown] != NSOrderedDescending;
}

@end
