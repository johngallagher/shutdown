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


-(void)enable {
  [self invalidateTimers];

  shutdownTimer = [NSTimer scheduledTimerWithTimeInterval:[[self futureDate:shutdownTime] timeIntervalSinceNow]
                                                   target:self
                                                 selector:@selector(disable)
                                                 userInfo:nil
                                                  repeats:NO];

  NSLog(@"about to enable");
  if ([view isInFullScreenMode]) {
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    [NSApp deactivate];
    [view exitFullScreenModeWithOptions:[self fullScreenOptions]];
  }
}

-(void)disable {
  [self invalidateTimers];

  startupTimer = [NSTimer scheduledTimerWithTimeInterval:[[self futureDate:startupTime] timeIntervalSinceNow]
                                                  target:self
                                                selector:@selector(enable)
                                                userInfo:nil
                                                 repeats:NO];

  NSLog(@"about to disable");

  if (![view isInFullScreenMode]) {
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    [NSApp activateIgnoringOtherApps:YES];
    [view enterFullScreenMode:[NSScreen mainScreen] withOptions:[self fullScreenOptions]];
  }
}

-(BOOL)currentDateIsBetweenStartupAndShutdown {
  NSDate *todaysStartupDate = [[self todaysDateComponentsFromTime:startupTime] date];
  NSDate *todaysShutdownDate = [[self todaysDateComponentsFromTime:shutdownTime] date];
  BOOL afterStartup = ([[NSDate date] compare:todaysStartupDate] == NSOrderedDescending);
  BOOL beforeShutdown = ([[NSDate date] compare:todaysShutdownDate] == NSOrderedAscending);
  return (afterStartup && beforeShutdown);
}

-(NSDate *)futureDate:(NSDate *)date {
  NSDateComponents *startupDateTimeComponents = [self todaysDateComponentsFromTime:date];

  if([[startupDateTimeComponents date] timeIntervalSinceNow] < 0) {
    [startupDateTimeComponents setDay:([startupDateTimeComponents day] + 1)];
  }
  return [startupDateTimeComponents date];
}

-(NSDateComponents *)todaysDateComponentsFromTime:(NSDate *)time {
  NSDateComponents *todayDate = [[NSCalendar currentCalendar] components:([self dateComponents]) fromDate:[NSDate date]];
  NSDateComponents *shutdownDateTimeComponents = [[NSCalendar currentCalendar] components:([self timeComponents]) fromDate:time];
  [shutdownDateTimeComponents setDay:[todayDate day]];
  [shutdownDateTimeComponents setMonth:[todayDate month]];
  [shutdownDateTimeComponents setYear:[todayDate year]];
  return shutdownDateTimeComponents;
}

-(NSDictionary *)fullScreenOptions {
  return @{NSFullScreenModeAllScreens : @YES};
}

-(enum NSCalendarUnit)dateComponents {
  return NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
}

-(enum NSCalendarUnit)timeComponents {
  return NSCalendarUnitCalendar | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
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
