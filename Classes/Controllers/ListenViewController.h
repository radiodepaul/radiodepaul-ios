//
//  ListenViewController.h
//  Radio DePaul
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "AudioStreamer.h"
#import "LevelMeterView.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ScheduleSlot.h"
#import "Show.h"
#import "Person.h"
#import "MWPhotoBrowser.h"
#import "BeamMusicPlayerViewController.h"

@class AudioStreamer, LevelMeterView;

@interface ListenViewController : UITableViewController <RKRequestDelegate, RKObjectLoaderDelegate>
{
    ScheduleSlot *onAirSlot;
    NSArray *photos;
    MBProgressHUD *hud;
}
@property (nonatomic, retain) ScheduleSlot *onAirSlot;
@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, retain) UIView *streamView;

-(bool) hasRetinaDisplay;
@end
