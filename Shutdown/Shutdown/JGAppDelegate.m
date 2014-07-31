#import "JGAppDelegate.h"
#import "JGSystemDisabler.h"

@implementation JGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"shutdown"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate dateWithTimeIntervalSinceNow:3] forKey:@"shutdown"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    _disabler = [JGSystemDisabler stateWithStartup:[object valueForKey:@"startup"] shutdown:[object valueForKey:@"shutdown"] blockerView:blockerView];
}
@end
