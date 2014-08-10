#import "JGAppDelegate.h"
#import "JGSystemDisabler.h"

@implementation JGAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [[NSUserDefaults standardUserDefaults] addObserver:self
                                          forKeyPath:@"shutdown"
                                             options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                                             context:NULL];
  [[NSUserDefaults standardUserDefaults] addObserver:self
                                          forKeyPath:@"startup"
                                             options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                                             context:NULL];
  [[NSUserDefaults standardUserDefaults] setValue:[NSDate dateWithTimeIntervalSinceNow:3] forKey:@"startup"];
  [[NSUserDefaults standardUserDefaults] setValue:[NSDate dateWithTimeIntervalSinceNow:7] forKey:@"shutdown"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
  state = [JGSystemDisabler disablerWithStartup:[object valueForKey:@"startup"] shutdown:[object valueForKey:@"shutdown"] disablerView:blockerView];
}

@end
