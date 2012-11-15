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

@class AudioStreamer;

@interface StreamManager : NSObject
{
	AudioStreamer *streamer;
}

- (void)playbackStateChanged:(NSNotification *)aNotification;
- (void)createTimers:(BOOL)create;
- (void)updateProgress:(NSTimer *)updatedTimer;
@end
