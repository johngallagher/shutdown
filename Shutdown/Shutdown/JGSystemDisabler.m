#import "JGSystemDisabler.h"
#import "JGSystemShutdown.h"


@implementation JGSystemDisabler {
}

@synthesize enabled;

+(instancetype)disablerWithStartupTime:(NSDate *)aStartup shutdownTime:(NSDate *)aShutdown disablerView:(NSView *)aView {
  return [[self alloc] initWithStartupTime:aStartup shutdownTime:aShutdown disablerView:aView];
}

-(instancetype)initWithStartupTime:(NSDate *)aStartupTime shutdownTime:(NSDate *)aShutdownTime disablerView:(NSView *)aView {
  self = [super init];
  if (self) {
    view = aView;
    shutdownTime = aShutdownTime;
    startupTime = aStartupTime;

    if([self currentDateIsBetweenStartupAndShutdown]) {
      [self enable];
    } else {
      [self disable];
    }
  }

  return self;
}


-(BOOL)currentDateIsBetweenStartupAndShutdown {
  return ([self currentDateIsAfterStartup] && [self currentDateIsBeforeShutdown]);
}

-(BOOL)currentDateIsBeforeShutdown {
  return ([[NSDate date] compare:shutdownTime] == NSOrderedAscending);
}

-(BOOL)currentDateIsAfterStartup {
  return ([[NSDate date] compare:startupTime] == NSOrderedDescending);
}

-(NSDictionary *)fullScreenOptions {
  return @{NSFullScreenModeAllScreens : @NO};
  // Additional options
  //                                       [NSNumber numberWithInt:1],      NSFullScreenModeApplicationPresentationOptions,
  //                                       [NSNumber numberWithInt:2],      NSFullScreenModeWindowLevel,
}


-(void)enable {
  [self invalidateTimers];

  NSDateComponents *todayDate = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
  NSDateComponents *shutdownDateTimeComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:shutdownTime];
  [shutdownDateTimeComponents setDay:[todayDate day]];
  [shutdownDateTimeComponents setMonth:[todayDate month]];
  [shutdownDateTimeComponents setYear:[todayDate year]];
  [shutdownDateTimeComponents setCalendar:[NSCalendar currentCalendar]];

  if([[shutdownDateTimeComponents date] timeIntervalSinceNow] < 0) {
    [shutdownDateTimeComponents setDay:([shutdownDateTimeComponents day] + 1)];
  }

  shutdownTimer = [NSTimer scheduledTimerWithTimeInterval:[[shutdownDateTimeComponents date] timeIntervalSinceNow]
                                                   target:self
                                                 selector:@selector(disable)
                                                 userInfo:nil
                                                  repeats:NO];

  NSLog(@"about to enable");
  if ([view isInFullScreenMode]) {
    [view exitFullScreenModeWithOptions:[self fullScreenOptions]];
    [NSApp deactivate];
  }
}

-(void)disable {
  [self invalidateTimers];

  NSDateComponents *todayDate = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
  NSDateComponents *startupDateTimeComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:startupTime];
  [startupDateTimeComponents setDay:(NSUInteger)([todayDate day])]; // Startup tomorrow
  [startupDateTimeComponents setMonth:[todayDate month]];
  [startupDateTimeComponents setYear:[todayDate year]];
  [startupDateTimeComponents setCalendar:[NSCalendar currentCalendar]];

  if([[startupDateTimeComponents date] timeIntervalSinceNow] < 0) {
    [startupDateTimeComponents setDay:([startupDateTimeComponents day] + 1)];
  }
  startupTimer = [NSTimer scheduledTimerWithTimeInterval:[[startupDateTimeComponents date] timeIntervalSinceNow]
                                                   target:self
                                                 selector:@selector(enable)
                                                 userInfo:nil
                                                  repeats:NO];

  NSLog(@"about to disable");

  if (![view isInFullScreenMode]) {
    [view enterFullScreenMode:[NSScreen mainScreen] withOptions:[self fullScreenOptions]];
    [NSApp activateIgnoringOtherApps:YES];
  }
}

-(void)invalidateTimers {
  if(startupTimer) {
    [startupTimer invalidate];
  }
  if(shutdownTimer) {
    [shutdownTimer invalidate];
  }
}

@end
