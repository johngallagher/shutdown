#import <Foundation/Foundation.h>
#import "JGTimerDelegate.h"

@class JGTimer;
@protocol JGSystemShutdown;

@interface JGSystemDisabler : NSObject <JGTimerDelegate> {
  NSNumber *enabled;
  NSTimer *startupTimer;
  NSTimer *shutdownTimer;
  NSView *view;
}

@property(nonatomic, strong) NSNumber *enabled;

-(instancetype)initWithStartup:(NSDate *)startupDate shutdown:(NSDate *)shutdownDate disablerView:(NSView *)aView;

+(instancetype)disablerWithStartup:(NSDate *)aStartup shutdown:(NSDate *)aShutdown disablerView:(NSView *)aView;

@end