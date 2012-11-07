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

@class AudioStreamer, LevelMeterView;

@interface ListenViewController : UIViewController
{
	IBOutlet UITextField *downloadSourceField;
	IBOutlet UIButton *button;
	IBOutlet UIView *volumeSlider;
	IBOutlet UILabel *positionLabel;
	IBOutlet UISlider *progressSlider;
	IBOutlet UITextField *metadataArtist;
	IBOutlet UITextField *metadataTitle;
	IBOutlet UITextField *metadataAlbum;
    IBOutlet UILabel *showTitle;
    IBOutlet UILabel *showGenres;
    IBOutlet UILabel *showDescription;
    IBOutlet UIImageView *showImage;
    IBOutlet UILabel *showStartTime;
    IBOutlet UILabel *showEndTime;
	AudioStreamer *streamer;
	NSTimer *progressUpdateTimer;
	NSTimer *levelMeterUpdateTimer;
	LevelMeterView *levelMeterView;
	NSString *currentArtist;
	NSString *currentTitle;
}

@property (retain) NSString* currentArtist;
@property (retain) NSString* currentTitle;

- (IBAction)buttonPressed:(id)sender;
- (void)spinButton;
- (void)forceUIUpdate;
- (void)playbackStateChanged:(NSNotification *)aNotification;
- (void)createTimers:(BOOL)create;
- (void)updateProgress:(NSTimer *)updatedTimer;
- (IBAction)sliderMoved:(UISlider *)aSlider;
- (void)getShowData;
- (void) setupUI;
@end
