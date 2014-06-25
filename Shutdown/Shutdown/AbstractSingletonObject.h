//
//  PrefPaneAbstractSingletonObject.h
//  SysPrefPane
//
//  Created by John Gallagher on 10/11/2009.
//  Copyright 2009 Synaptic Mishap. All rights reserved.
//

@interface AbstractSingletonObject : NSObject {
	BOOL	_isInitialized;
}

/*!
 * @brief Returns the shared instance of this class.
 */
+ (id) sharedInstance;

/*!
 * @brief Releases and deallocates all the singletons that are subclasses of this object.
 *
 * Once +destroyAllSingletons has been called, no more singletons can be created
 * and every call to [SomeSingletonSubclass sharedInstance] will return nil.
 * Also note that a call to this method will destroy GBAbstractSingletonObject and all it's subclasses.
 * Even though that you generally can't release a singleton object, it's dealloc message WILL be called
 * when it's beeing destroyed.
 *
 * USE THIS METHOD WITH GREAT CAUTION!!!
 */
+ (void) destroyAllSingletons;

@end

/*!
 * @category GrowlSingletonObjectInit
 * @brief A private category for subclasses only.
 *
 * Only subclasses should override/call methods in the category.
 */
@interface AbstractSingletonObject (PrefPaneAbstractSingletonObjectInit)

/*!
 * @brief An init method for your singleton object.
 *
 * Implement this in your subclass to init your shared object.
 * You should call [super initSingleton] and return your initialized object.
 * Never call this method directly! It'll be automatically called when needed.
 */
- (id) initSingleton;

/*!
 * @brief Finish and clean up whatever your singleton does.
 *
 * This will be called before the singleton will be destroyed.
 * You should put whatever you would put in the -dealloc method here instead
 * and then call [super destroy].
 */
- (void) destroy;
@end
