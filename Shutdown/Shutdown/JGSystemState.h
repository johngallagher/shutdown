#import <Foundation/Foundation.h>
#import "JGTimerDelegate.h"

@class JGTimer;
@protocol JGSystemShutdown;

@interface JGSystemState : NSObject <JGTimerDelegate> {
    BOOL enabled;
    NSTimer *timer;
    NSView *fullScreenBlockerView;
    id <JGSystemShutdown> disabler;
}
@property(nonatomic) BOOL enabled;

-(instancetype)initWithStartup:(NSDate *)startupDate shutdown:(NSDate *)shutdownDate blockerView:(NSView *)aView shutdownDelegate:(id <JGSystemShutdown>)aDelegate;

+(instancetype)stateWithStartup:(NSDate *)aStartup shutdown:(NSDate *)aShutdown blockerView:(NSView *)aView shutdownDelegate:(id <JGSystemShutdown>)aDelegate;

@end