#import <Foundation/Foundation.h>
#import "JGTimerDelegate.h"

@class JGTimer;
@protocol JGSystemShutdown;

@interface JGSystemDisabler : NSObject <JGTimerDelegate> {
  NSNumber *enabled;
  NSView *view;

  NSTimer *startupTimer;
  NSTimer *shutdownTimer;

  NSDate *startupTime;
  NSDate *shutdownTime;

  NSDate *startupDate;
  NSDate *shutdownDate;
}

@property(nonatomic, strong) NSNumber *enabled;

-(instancetype)initWithStartupTime:(NSDate *)aStartupTime shutdownTime:(NSDate *)aShutdownTime disablerView:(NSView *)aView;

+(instancetype)disablerWithStartupTime:(NSDate *)aStartup shutdownTime:(NSDate *)aShutdown disablerView:(NSView *)aView;

@end