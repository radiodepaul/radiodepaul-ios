//
//  AppDelegate.h
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HockeySDK/HockeySDK.h>
#import "DSFingerTipWindow.h"
#import "BeamMusicPlayerViewController.h"
#import "BeamMPMusicPlayerProvider.h"
#import "StreamManager.h"
#import "BeamMinimalExampleProvider.h"

@class StreamViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, BITHockeyManagerDelegate, BITUpdateManagerDelegate, BITCrashManagerDelegate>
{
    AudioStreamer *streamer;
}

@property (nonatomic, retain) BeamMusicPlayerViewController *beamViewController;
@property (nonatomic, retain) BeamMinimalExampleProvider *exampleProvider;

@property (nonatomic, retain) AudioStreamer *audioStreamer;
@property (nonatomic, retain) StreamViewController *streamViewController;
@property (strong, nonatomic) DSFingerTipWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *rootController;
@property (nonatomic) BOOL uiIsVisible;

- (void) setupUI;

@end
