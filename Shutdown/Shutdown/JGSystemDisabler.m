#import "JGSystemDisabler.h"
#import "JGSystemShutdown.h"


@implementation JGSystemDisabler

@synthesize enabled;

+(instancetype)disablerWithStartup:(NSDate *)aStartup shutdown:(NSDate *)aShutdown disablerView:(NSView *)aView {
  return [[self alloc] initWithStartup:aStartup shutdown:aShutdown disablerView:aView];
}

-(instancetype)initWithStartup:(NSDate *)startupDate shutdown:(NSDate *)shutdownDate disablerView:(NSView *)aView {
  self = [super init];
  if (self) {
    view = aView;
    if([self currentDateIsBetween:startupDate andDate:shutdownDate]) {
      [self enable];
      shutdownTimer = [NSTimer scheduledTimerWithTimeInterval:[shutdownDate timeIntervalSinceNow]
                                                       target:self
                                                     selector:@selector(disable)
                                                     userInfo:nil
                                                      repeats:NO];
    } else if([self currentDateIsBeforeStartup:startupDate]) {
      [self disable];
      startupTimer = [NSTimer scheduledTimerWithTimeInterval:[startupDate timeIntervalSinceNow]
                                                      target:self
                                                    selector:@selector(enable)
                                                    userInfo:nil
                                                     repeats:NO];
      shutdownTimer = [NSTimer scheduledTimerWithTimeInterval:[shutdownDate timeIntervalSinceNow]
                                                       target:self
                                                     selector:@selector(disable)
                                                     userInfo:nil
                                                      repeats:NO];
    } else {
      [self disable];
    }
  }

  return self;
}


-(BOOL)currentDateIsBetween:(NSDate *)startupDate andDate:(NSDate *)shutdownDate {
  return ([self currentDateIsAfterStartup:startupDate] && [self currentDateIsBeforeShutdown:shutdownDate]);
}

-(BOOL)currentDateIsBeforeShutdown:(NSDate *)shutdownDate {
  return ([[NSDate date] compare:shutdownDate] == NSOrderedAscending);
}

-(BOOL)currentDateIsAfterStartup:(NSDate *)startupDate {
  return ([[NSDate date] compare:startupDate] == NSOrderedDescending);
}

-(BOOL)currentDateIsBeforeStartup:(NSDate *)startupDate {
  return ![self currentDateIsAfterStartup:startupDate];
}

-(NSDictionary *)fullScreenOptions {
  return @{NSFullScreenModeAllScreens : @NO};
  // Additional options
  //                                       [NSNumber numberWithInt:1],      NSFullScreenModeApplicationPresentationOptions,
  //                                       [NSNumber numberWithInt:2],      NSFullScreenModeWindowLevel,
}


-(void)enable {
  if ([view isInFullScreenMode]) {
    NSLog(@"about to enable");
    [view exitFullScreenModeWithOptions:[self fullScreenOptions]];
    [NSApp deactivate];
  }
}

-(void)disable {
  if (![view isInFullScreenMode]) {
    NSLog(@"about to disable");
//    [view enterFullScreenMode:[NSScreen mainScreen] withOptions:[self fullScreenOptions]];
//    [NSApp activateIgnoringOtherApps:YES];
  }
}

@end
