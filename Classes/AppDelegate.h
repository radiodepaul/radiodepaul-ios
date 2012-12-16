//
//  AppDelegate.h
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSFingerTipWindow.h"
#import "BeamMusicPlayerViewController.h"
#import "BeamMPMusicPlayerProvider.h"
#import "BeamMinimalExampleProvider.h"

@class StreamViewController;
@class BeamMusicPlayerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    AudioStreamer *streamer;
    ScheduleSlot *onAirSlot;
}

@property (nonatomic, retain) BeamMusicPlayerViewController *beamViewController;
//@property (nonatomic, retain) BeamMinimalExampleProvider *exampleProvider;

@property (strong, nonatomic, retain) BeamMusicPlayerViewController *viewController;
@property (strong, nonatomic, retain) id<BeamMusicPlayerDataSource,BeamMusicPlayerDelegate> exampleProvider;

@property (nonatomic, retain) AudioStreamer *audioStreamer;
@property (nonatomic, retain) StreamViewController *streamViewController;
@property (strong, nonatomic) DSFingerTipWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *rootController;
@property (nonatomic) BOOL uiIsVisible;
@property (nonatomic, retain) ScheduleSlot *onAirSlot;

- (void) setupUI;

+ (BeamMusicPlayerViewController *) sharedBeamViewController;

@end
