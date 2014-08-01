#import <Foundation/Foundation.h>
#import "JGSystemShutdown.h"


@interface JGDisabler : NSObject <JGSystemShutdown> {
    NSView *view;
}
-(instancetype)initWithView:(NSView *)aView;

+(instancetype)disablerWithView:(NSView *)aView;

@end