#import "JGAppDelegate.h"
#import "JGSystemState.h"

@implementation JGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"shutdown"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"startup"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
//    [[NSUserDefaults standardUserDefaults] setValue:[NSDate dateWithTimeIntervalSinceNow:-3] forKey:@"startup"];
//    [[NSUserDefaults standardUserDefaults] setValue:[NSDate dateWithTimeIntervalSinceNow:3] forKey:@"shutdown"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    _disabler = [JGSystemState stateWithStartup:[object valueForKey:@"startup"] shutdown:[object valueForKey:@"shutdown"] blockerView:blockerView shutdownDelegate:nil];
}
@end
