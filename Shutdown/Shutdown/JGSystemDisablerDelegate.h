#import <Foundation/Foundation.h>

@protocol JGSystemDisablerDelegate <NSObject>
-(void)enable;
-(void)disable;
@end