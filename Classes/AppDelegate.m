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
#import <SDWebImage/UIImageView+WebCache.h>
#import "StreamViewController.h"
#import "ListenNavigationViewController.h"
#import "ListenViewController.h"
#import "FirstLevelController.h"
#import "NewsViewController.h"
#import "InfoViewController.h"

@implementation AppDelegate
@synthesize rootController;
@synthesize uiIsVisible;
@synthesize beamViewController = _beamViewController;

#pragma mark -
#pragma mark Application lifecycle

- (void) setupUI
{
    UIImage *navBarImage = [UIImage imageNamed:@"navBar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[BITHockeyManager sharedHockeyManager] configureWithBetaIdentifier:@"a67815b310dd375403ce258a3b66da45"
                                                         liveIdentifier:@"1051a7cc9c114e635a665febab9b8533"
                                                               delegate:self];
    [[BITHockeyManager sharedHockeyManager] startManager];
 
    [RKClient clientWithBaseURLString:@"http://radiodepaul.herokuapp.com"];
    [RKObjectManager objectManagerWithBaseURLString:@"http://radiodepaul.herokuapp.com"];
    
    self.uiIsVisible = YES;
    [self setupUI];
    
    self.window = [[DSFingerTipWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
     self.exampleProvider = [[BeamMinimalExampleProvider alloc] init];
    
    self.beamViewController = [BeamMusicPlayerViewController new];
    self.beamViewController.delegate = self.exampleProvider;
    self.beamViewController.dataSource = self.exampleProvider;
    self.beamViewController.hidesBottomBarWhenPushed = YES;
    self.beamViewController.backBlock = ^{
        [[[UIAlertView alloc] initWithTitle:@"Action" message:@"The Player's back button was pressed." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    };
    self.beamViewController.actionBlock = ^{
        [[[UIAlertView alloc] initWithTitle:@"Action" message:@"The Player's action button was pressed." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    };
    
    [self.audioStreamer initWithURL:[NSURL URLWithString:@"http://rock.radio.depaul.edu:8000"]];
    
    //self.window.rootViewController = self.beamViewController;
    
    self.rootController = [[UITabBarController alloc] init];
    
    ListenNavigationViewController *listenNavigationViewController = [[ListenNavigationViewController alloc] initWithRootViewController:[[ListenViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    
    UINavigationController *scheduleController = [[UINavigationController alloc] initWithRootViewController:[[FirstLevelController alloc] initWithStyle:UITableViewStylePlain]];
    
    UINavigationController *newsController = [[UINavigationController alloc] initWithRootViewController:[[NewsViewController alloc] initWithStyle:UITableViewStylePlain]];
    
    //UINavigationController *infoController = [[UINavigationController alloc] initWithRootViewController:[[InfoViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    
    [self.rootController setViewControllers:[NSArray arrayWithObjects:listenNavigationViewController, scheduleController, newsController, nil]];
    
    UITabBarItem *item = (UITabBarItem *)[self.rootController.tabBar.items objectAtIndex:0]; //for first view
    item.title = @"Listen";
    [item setImage:[UIImage imageNamed:@"listen.png"]];
    
    item = (UITabBarItem *)[self.rootController.tabBar.items objectAtIndex:1]; //for first view
    item.title = @"Schedule";
    [item setImage:[UIImage imageNamed:@"schedule.png"]];
    
    item = (UITabBarItem *)[self.rootController.tabBar.items objectAtIndex:2]; //for first view
    item.title = @"News";
    [item setImage:[UIImage imageNamed:@"news.png"]];
    
    //item = (UITabBarItem *)[root.tabBar.items objectAtIndex:3]; //for first view
    //item.title = @"Info";
    //[item setImage:[UIImage imageNamed:@"info.png"]];
    
    
    //[[NSBundle mainBundle] loadNibNamed:@"TabBarController" owner:self options:nil];
    
    [self.window addSubview:self.rootController.view];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(presentAlertWithTitle:)
	 name:ASPresentAlertWithTitleNotification
	 object:nil];
	[[NSThread currentThread] setName:@"Main Thread"];
    
    //[[UINavigationBar appearance] setBackgroundImage: [UIImage imageNamed:@"MyImageName"] forBarMetrics:UIBarMetricsDefault];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    return YES;
}

#pragma mark - BITUpdateManagerDelegate
- (NSString *)customDeviceIdentifierForUpdateManager:(BITUpdateManager *)updateManager {
#ifndef CONFIGURATION_AppStore
    if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)])
        return [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
#endif
    return nil;
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


@end
