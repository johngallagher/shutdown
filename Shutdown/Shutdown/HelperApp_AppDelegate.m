//
//  HelperApp_AppDelegate.m
//  Shutdown
//
//  Created by John Gallagher on 16/11/2009.
//  Copyright 2009 Synaptic Mishap. All rights reserved.
//

#import "HelperApp_AppDelegate.h"

@class ShutdownHelperToolExecutor;

@implementation HelperApp_AppDelegate

+(void)initialize {
    NSDictionary *defaultsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)32400], kStartTime,
                                  [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)62400], kStopTime,
                                  [NSNumber numberWithInt:10], kReminderTime, nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDict];
}

-(void)convertShutdownTimesToToday {
    // Start and stop dates are just times taken with respect to the 1970 reference date. We need to convert that into a time today.
    startTimeToday      = [startTime    convert1970RefTimeToToday];
    stopTimeToday       = [stopTime     convert1970RefTimeToToday];
    
    // Work out the time we need to fire the reminder.
    int                 reminderSecondsBeforeShutdown = 0 - ([reminderTime intValue] * 60);
    NSTimeInterval      reminderTimeIntervalBeforeShutdown = (NSTimeInterval)reminderSecondsBeforeShutdown;
    
    reminderTimeToday   = [stopTimeToday  dateByAddingTimeInterval:reminderTimeIntervalBeforeShutdown];
}


-(void)installShutdownTimer {
    // Should we be able to use our computer now? 
    BOOL timeIsAfterStart = ([[NSDate date] timeIntervalSinceDate:startTimeToday] > 0);
    BOOL timeIsBeforeStop = ([[NSDate date] timeIntervalSinceDate:stopTimeToday] < 0);

    BOOL currentTimeIsLegal = (timeIsAfterStart && timeIsBeforeStop);
    if (currentTimeIsLegal) {
        // If so, setup the timers to warn and shutdown the computer.
        [warnBeforeShutdownTimer    invalidate];
        [shutdownTimer              invalidate];
        warnBeforeShutdownTimer     = [[NSTimer alloc] initWithFireDate:reminderTimeToday interval:0 target:self selector:@selector(warnBeforeShutdown:) userInfo:nil repeats:NO];
        shutdownTimer               = [[NSTimer alloc] initWithFireDate:stopTimeToday interval:0 target:self selector:@selector(shutdownComputer:) userInfo:nil repeats:NO];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        [runLoop addTimer:warnBeforeShutdownTimer   forMode:NSDefaultRunLoopMode];
        [runLoop addTimer:shutdownTimer             forMode:NSDefaultRunLoopMode];
        NSLog(@"Installed Timer to shutdown at: %@", stopTimeToday);
        
    } else {
        // If not, tell the user then shutdown the computer immediately.
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert setMessageText:@"Shutdown."];
        [alert addButtonWithTitle:@"OK"];
        [alert setInformativeText:@"You can't log in now. The computer will shut down immediately."];
        
        [NSApp activateIgnoringOtherApps:YES];
        
        [self shutdownComputer:nil];
        [alert runModal];
    }

}

-(void)updateShutdownTimes {
    // Get current prefs
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    startTime      = [[NSUserDefaults standardUserDefaults] objectForKey:kStartTime];
    stopTime       = [[NSUserDefaults standardUserDefaults] objectForKey:kStopTime];
    reminderTime   = [[NSUserDefaults standardUserDefaults] objectForKey:kReminderTime];
    
    // Calculate shutdown dates
    [self convertShutdownTimesToToday];
    [self installShutdownTimer];
}

-(void)applicationDidFinishLaunching:(NSNotification *)note {
    // Register for distributed notifications
    NSDistributedNotificationCenter *NSDNC = [NSDistributedNotificationCenter defaultCenter];
    
    [NSDNC addObserver:self
              selector:@selector(preferencesChanged:)
                  name:PrefPanePreferencesChanged
                object:nil];
    [NSDNC addObserver:self
              selector:@selector(terminateHelperApp:)
                  name:Terminate_Helper_App
                object:nil];
    [NSDNC addObserver:self
              selector:@selector(shutdownComputer:)
                  name:Shutdown_Computer
                object:nil];
    
    [self installSleepWakeObservers];
    [self updateShutdownTimes];
}

-(void)installSleepWakeObservers {
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self 
                                                           selector:@selector(updateShutdownTimes) 
                                                               name:NSWorkspaceDidWakeNotification 
                                                             object:NULL];
}



-(void)preferencesChanged:(NSNotification *)note {
    NSLog(@"Prefs changed. From helper app.");
    // We've changed startup/shutdown times so update the NSTimers and shutdown if needed.
    [self updateShutdownTimes];
}

-(void)terminateHelperApp:(NSNotification *)note {
#pragma unused(note)
    NSLog(@"Shutdown message recieved. From helper app. Shutting down.");
	[NSApp terminate:nil];
}

-(void)sendDisablePrefPane {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:DisablePrefPaneControls 
                                                                   object:nil];

}

-(void)warnBeforeShutdown:(NSTimer *)timer {
    [self sendDisablePrefPane];
    
    xMinutesLeftAlert = [[NSAlert alloc] init];
    [xMinutesLeftAlert setAlertStyle:NSCriticalAlertStyle];
    [xMinutesLeftAlert setMessageText:@"Shutdown."];
    [xMinutesLeftAlert addButtonWithTitle:@"OK"];
    [xMinutesLeftAlert setInformativeText:[NSString stringWithFormat:@"The computer will shut down in %d minutes. Please save your work.", [reminderTime intValue]]];
    
    [NSApp activateIgnoringOtherApps:YES];
    
    NSTimer *myTimer = [NSTimer timerWithTimeInterval:5.0
                                               target:self
                                             selector:@selector(killXMinutesLeftAlert:)
                                             userInfo:nil
                                              repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:myTimer
                                 forMode:NSModalPanelRunLoopMode];
    
    [xMinutesLeftAlert runModal];
    [myTimer invalidate];
}

-(void)killXMinutesLeftAlert:(NSTimer *)timer {
    [[xMinutesLeftAlert window] close];
}

-(void)shutdownComputer:(NSTimer *)timer {
    oneMinuteLeftAlert = [[NSAlert alloc] init];
    [oneMinuteLeftAlert setAlertStyle:NSCriticalAlertStyle];
    [oneMinuteLeftAlert setMessageText:@"Shutdown."];
    [oneMinuteLeftAlert addButtonWithTitle:@"OK"];
    [oneMinuteLeftAlert setInformativeText:@"The computer will shutdown in 1 minute."];
    
    [NSApp activateIgnoringOtherApps:YES];
    
    NSTimer *myTimer = [NSTimer timerWithTimeInterval:5.0
                                               target:self
                                             selector:@selector(killOneMinuteLeftAlert:)
                                             userInfo:nil
                                              repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:myTimer
                                 forMode:NSModalPanelRunLoopMode];
    
    NSLog(@"Shutting down the computer in 1`minute...");
    ShutdownHelperToolExecutor *helperTool = [[ShutdownHelperToolExecutor alloc] init];
    [helperTool quitOtherApps];
    [helperTool doShutdown];
    
    [oneMinuteLeftAlert runModal];
    [myTimer invalidate];
}

-(void)killOneMinuteLeftAlert:(NSTimer *)timer {
    [[oneMinuteLeftAlert window] close];
}
    
@end
