#import <Foundation/Foundation.h>

@protocol JGTimerDelegate <NSObject>

-(void)timerDidFireWithObject:(id)object;
@end