#import <Foundation/Foundation.h>
#import "JGSystemDisablerDelegate.h"

@protocol JGSystemShutdown;

@interface JGSystemDisabler : NSObject <JGSystemDisablerDelegate> {
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