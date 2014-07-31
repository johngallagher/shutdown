#import <Foundation/Foundation.h>

@protocol JGTimerDelegate;


@interface JGTimer : NSObject {
    id <JGTimerDelegate> delegate;
    NSTimer *timer;
}

+(JGTimer *)timerWithFireDate:(NSDate *)date delegate:(id <JGTimerDelegate>)aDelegate;

-(instancetype)initWithDate:(NSDate *)timer_ delegate:(id <JGTimerDelegate>)aDelegate;


@end