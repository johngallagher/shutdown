#import <Foundation/Foundation.h>
#import "JGTimerDelegate.h"

@class JGTimer;
@protocol SystemShutdown;

@interface JGSystemDisabler : NSObject <JGTimerDelegate> {
    BOOL enabled;
    NSTimer *timer;
    NSView *fullScreenBlockerView;
}
@property(nonatomic) BOOL enabled;

@property(nonatomic, strong) NSDate *startup;

-(instancetype)initWithStartup:(NSDate *)aStartup shutdown:(NSDate *)aShutdown blockerView:(NSView *)aView;

+(instancetype)stateWithStartup:(NSDate *)aStartup shutdown:(NSDate *)aShutdown blockerView:(NSView *)aView;

@end