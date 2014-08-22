#import "JGUserDefaultsUpdater.h"


@implementation JGUserDefaultsUpdater

-(id)init {
  self = [super init];
  if (self) {
    [self addObserver:self forKeyPath:@"startupDate" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"shutdownDate" options:NSKeyValueObservingOptionNew context:NULL];
    [self updateFromDefaults];
    [self updateTimesAreValid];
  }

  return self;
}

-(IBAction)update:(id)sender {
  if([self timesAreValid]) {
    [[NSUserDefaults standardUserDefaults] setObject:self.startupDate forKey:@"startup"];
    [[NSUserDefaults standardUserDefaults] setObject:self.shutdownDate forKey:@"shutdown"];
  }
}

-(void)updateTimesAreValid {
  BOOL startupIsBeforeShutdown = ([[self startupDate] compare:[self shutdownDate]] == NSOrderedAscending);
  [self setTimesAreValid:startupIsBeforeShutdown];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  [self updateTimesAreValid];
}

-(void)updateFromDefaults {
  [self setStartupDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"startup"]];
  [self setShutdownDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"shutdown"]];
}

-(void)dealloc {
  [self removeObserver:self forKeyPath:@"startupDate"];
  [self removeObserver:self forKeyPath:@"shutdownDate"];
}

@end