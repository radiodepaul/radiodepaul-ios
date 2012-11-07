//
//  AppDelegate.m
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <dispatch/dispatch.h>

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_4_0
    #define kCFCoreFoundationVersionNumber_iPhoneOS_4_0 550.32
#endif

#import "AppDelegate.h"
#import "FirstLevelController.h"
#import "AudioStreamer.h"

@implementation AppDelegate
@synthesize rootController;
@synthesize uiIsVisible;

#pragma mark -
#pragma mark Application lifecycle

- (void) setupUI
{
    UIImage *navBarImage = [UIImage imageNamed:@"navBar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    #define TESTING 1
    #ifdef TESTING
        [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    #endif
    [TestFlight takeOff:@"fba3976b6f0afd7168adf869914a5680_MTUxMDY0MjAxMi0xMS0wNCAwMjo1ODo0OS4xMTA4NTA"];
    [BugSenseCrashController sharedInstanceWithBugSenseAPIKey:@"b31ef469"];
    self.uiIsVisible = YES;
    [self setupUI];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[NSBundle mainBundle] loadNibNamed:@"TabBarController" owner:self options:nil];
    [self.window addSubview:rootController.view];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(presentAlertWithTitle:)
	 name:ASPresentAlertWithTitleNotification
	 object:nil];
	[[NSThread currentThread] setName:@"Main Thread"];
    
    [TestFlight passCheckpoint:@"Launched App"];
    
    [[UINavigationBar appearance] setBackgroundImage: [UIImage imageNamed:@"MyImageName"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    self.uiIsVisible = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    self.uiIsVisible = NO;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(presentAlertWithTitle:)
	 name:ASPresentAlertWithTitleNotification
	 object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    self.uiIsVisible = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    self.uiIsVisible = NO;
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:ASPresentAlertWithTitleNotification
	 object:nil];
}

- (void)presentAlertWithTitle:(NSNotification *)notification
{
    NSString *title = [[notification userInfo] objectForKey:@"title"];
    NSString *message = [[notification userInfo] objectForKey:@"message"];
    
    //NSLog(@"Current Thread = %@", [NSThread currentThread]);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    
    dispatch_async(main_queue, ^{
        
        //NSLog(@"Current Thread (in main queue) = %@", [NSThread currentThread]);
        if (!uiIsVisible) {
#ifdef TARGET_OS_IPHONE
            if(kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_4_0) {
                UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                localNotif.alertBody = message;
                localNotif.alertAction = NSLocalizedString(@"Open", @"");
                [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
            }
#endif
        }
        else {
#ifdef TARGET_OS_IPHONE
            UIAlertView *alert = [
                                  [UIAlertView alloc]
                                   initWithTitle:title
                                   message:message
                                   delegate:nil
                                   cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                   otherButtonTitles: nil];
            /*
             [alert
             performSelector:@selector(show)
             onThread:[NSThread mainThread]
             withObject:nil
             waitUntilDone:NO];
             */
            [alert show];
#else
            NSAlert *alert =
            [NSAlert
             alertWithMessageText:title
             defaultButton:NSLocalizedString(@"OK", @"")
             alternateButton:nil
             otherButton:nil
             informativeTextWithFormat:message];
            /*
             [alert
             performSelector:@selector(runModal)
             onThread:[NSThread mainThread]
             withObject:nil
             waitUntilDone:NO];
             */
            [alert runModal];
#endif
        }
    });
}


@end
