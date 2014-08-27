#import "JGUserDefaultsUpdater.h"


@implementation JGUserDefaultsUpdater

-(id)init {
  self = [self initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
  return self;
}

-(instancetype)initWithUserDefaults:(NSUserDefaults *)anUserDefaults {
  self = [super init];
  if (self) {
    userDefaults = anUserDefaults;
    [self setStartupDate:[userDefaults objectForKey:@"startup"]];
    [self setShutdownDate:[userDefaults objectForKey:@"shutdown"]];
    [self addObserver:self forKeyPath:@"startupDate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context:NULL];
    [self addObserver:self forKeyPath:@"shutdownDate" options:NSKeyValueObservingOptionNew context:NULL];
  }

  return self;
}

+(instancetype)updaterWithUserDefaults:(NSUserDefaults *)anUserDefaults {
  return [[self alloc] initWithUserDefaults:anUserDefaults];
}


-(IBAction)update:(id)sender {
  if([self timesAreValid]) {
    [[NSUserDefaults standardUserDefaults] setObject:self.startupDate forKey:@"startup"];
    [[NSUserDefaults standardUserDefaults] setObject:self.shutdownDate forKey:@"shutdown"];
  }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  BOOL startupIsBeforeShutdown = ([[self startupDate] compare:[self shutdownDate]] == NSOrderedAscending);
  [self setTimesAreValid:startupIsBeforeShutdown];
}

-(void)dealloc {
  [self removeObserver:self forKeyPath:@"startupDate"];
  [self removeObserver:self forKeyPath:@"shutdownDate"];
}

@end