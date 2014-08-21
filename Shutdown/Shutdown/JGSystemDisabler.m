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

-(BOOL)currentDateIsAfterStartup {
  return ([[NSDate date] compare:[self todaysStartupDate]] == NSOrderedDescending);
}

-(BOOL)currentDateIsBeforeShutdown {
  return ([[NSDate date] compare:[self todaysShutdownDate]] == NSOrderedAscending);
}

-(NSDictionary *)fullScreenOptions {
  return @{NSFullScreenModeAllScreens : @NO};
  // Additional options
  //                                       [NSNumber numberWithInt:1],      NSFullScreenModeApplicationPresentationOptions,
  //                                       [NSNumber numberWithInt:2],      NSFullScreenModeWindowLevel,
}



-(void)enable {
  [self invalidateTimers];

  shutdownTimer = [NSTimer scheduledTimerWithTimeInterval:[[self nextShutdownDate] timeIntervalSinceNow]
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

-(NSDate *)nextShutdownDate {
  NSDateComponents *todayDate = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
  NSDateComponents *shutdownDateTimeComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:shutdownTime];
  [shutdownDateTimeComponents setDay:[todayDate day]];
  [shutdownDateTimeComponents setMonth:[todayDate month]];
  [shutdownDateTimeComponents setYear:[todayDate year]];
  [shutdownDateTimeComponents setCalendar:[NSCalendar currentCalendar]];

  if([[shutdownDateTimeComponents date] timeIntervalSinceNow] < 0) {
    [shutdownDateTimeComponents setDay:([shutdownDateTimeComponents day] + 1)];
  }

  return [shutdownDateTimeComponents date];
}


-(NSDate *)todaysShutdownDate {
  NSDateComponents *todayDate = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
  NSDateComponents *shutdownDateTimeComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:shutdownTime];
  [shutdownDateTimeComponents setDay:[todayDate day]];
  [shutdownDateTimeComponents setMonth:[todayDate month]];
  [shutdownDateTimeComponents setYear:[todayDate year]];
  [shutdownDateTimeComponents setCalendar:[NSCalendar currentCalendar]];

  return [shutdownDateTimeComponents date];
}



-(void)disable {
  [self invalidateTimers];

  startupTimer = [NSTimer scheduledTimerWithTimeInterval:[[self nextStartupDate] timeIntervalSinceNow]
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

-(NSDate *)nextStartupDate {
  NSDateComponents *todayDate = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
  NSDateComponents *startupDateTimeComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:startupTime];
  [startupDateTimeComponents setDay:(NSUInteger)([todayDate day])]; // Startup tomorrow
  [startupDateTimeComponents setMonth:[todayDate month]];
  [startupDateTimeComponents setYear:[todayDate year]];
  [startupDateTimeComponents setCalendar:[NSCalendar currentCalendar]];

  if([[startupDateTimeComponents date] timeIntervalSinceNow] < 0) {
    [startupDateTimeComponents setDay:([startupDateTimeComponents day] + 1)];
  }
  return [startupDateTimeComponents date];
}

-(NSDate *)todaysStartupDate {
  NSDateComponents *todayDate = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
  NSDateComponents *startupDateTimeComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:startupTime];
  [startupDateTimeComponents setDay:(NSUInteger)([todayDate day])]; // Startup tomorrow
  [startupDateTimeComponents setMonth:[todayDate month]];
  [startupDateTimeComponents setYear:[todayDate year]];
  [startupDateTimeComponents setCalendar:[NSCalendar currentCalendar]];

  return [startupDateTimeComponents date];
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
