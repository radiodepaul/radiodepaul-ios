//
//  BeamMusicPlayerViewController.m
//  Part of BeamMusicPlayerViewController (license: New BSD)
//  -> https://github.com/BeamApp/MusicPlayerViewController
//
//  Created by Moritz Haarmann on 30.05.12.
//  Copyright (c) 2012 BeamApp UG. All rights reserved.
//

#import "BeamMusicPlayerViewController.h"
#import "UIImageView+Reflection.h"
#import "NSDateFormatter+Duration.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AutoScrollLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "ScheduleSlot.h"
#import "Show.h"
#import "MBProgressHUD.h"

@interface BeamMusicPlayerViewController()
{
    MBProgressHUD *hud;
}

@property (nonatomic,strong) IBOutlet MPVolumeView* volumeSlider; // Volume Slider
@property (retain, nonatomic) IBOutlet UIView *volumeView;

@property (nonatomic,strong) IBOutlet OBSlider* progressSlider; // Progress Slider buried in the Progress View

@property (nonatomic,strong) IBOutlet AutoScrollLabel* trackTitleLabel; // The Title Label
@property (nonatomic,strong) IBOutlet AutoScrollLabel* albumTitleLabel; // Album Label
@property (nonatomic,strong) IBOutlet AutoScrollLabel* artistNameLabel; // Artist Name Label

@property (nonatomic,strong) IBOutlet UIToolbar* controlsToolbar; // Encapsulates the Play, Forward, Rewind buttons

@property (nonatomic, retain) IBOutlet UIBarButtonItem *actionButton; // retain, since controller keeps a reference while it might be detached from view hierarchy
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton; // retain, since controller keeps a reference while it might be detached from view hierarchy

@property (nonatomic,strong) IBOutlet UIBarButtonItem* rewindButton; // Previous Track
@property (nonatomic,strong) IBOutlet UIBarButtonItem* fastForwardButton; // Next Track
@property (nonatomic,strong) IBOutlet UIBarButtonItem* playButton; // Play

@property (nonatomic,strong) IBOutlet UIImageView* albumArtImageView; // Album Art Image View
@property (nonatomic,strong) IBOutlet UIImageView* albumArtReflection; // It's reflection

@property (nonatomic,strong) NSTimer* playbackTickTimer; // Ticks each seconds when playing.

@property (nonatomic,strong) UITapGestureRecognizer* coverArtGestureRecognizer; // Tap Recognizer used to dim in / out the scrobble overlay.

@property (nonatomic,strong) IBOutlet UIView* scrobbleOverlay; // Overlay that serves as a container for all components visible only in scrobble-mode
@property (nonatomic,strong) IBOutlet UILabel* timeElapsedLabel; // Elapsed Time Label
@property (nonatomic,strong) IBOutlet UILabel* timeRemainingLabel; // Remaining Time Label
@property (nonatomic,strong) IBOutlet UIButton* shuffleButton; // Shuffle Button
@property (nonatomic,strong) IBOutlet UIButton* repeatButton; // Repeat button
@property (nonatomic,strong) IBOutlet UILabel* scrobbleHelpLabel; // The Scrobble Usage hint Label
@property (nonatomic,strong) IBOutlet UILabel* numberOfTracksLabel; // Track x of y or the scrobble speed
@property (nonatomic,strong) IBOutlet UIImageView* scrobbleHighlightShadow; // It's reflection


@property (nonatomic) CGFloat currentTrackLength; // The Length of the currently playing track
@property (nonatomic) NSInteger numberOfTracks; // Number of tracks, <0 if unknown
@property (readonly) BOOL numberOfTracksAvailable;

@property (nonatomic) BOOL scrobbling; // Whether the player is currently scrobbling

@property (nonatomic) BOOL lastDirectionChangePositive; // Whether the last direction change was positive.

@property (nonatomic,strong) IBOutlet UINavigationItem* navigationItem;



@end

@implementation BeamMusicPlayerViewController

@synthesize trackTitleLabel;
@synthesize albumTitleLabel;
@synthesize artistNameLabel;
@synthesize actionButton;
@synthesize backButton;
@synthesize rewindButton;
@synthesize fastForwardButton;
@synthesize playButton;
@synthesize volumeSlider;
@synthesize volumeView;
@synthesize progressSlider;
@synthesize controlsToolbar;
@synthesize albumArtImageView;
@synthesize albumArtReflection;
@synthesize delegate;
@synthesize dataSource;
@synthesize currentTrack;
@synthesize currentPlaybackPosition;
@synthesize playbackTickTimer;
@synthesize playing;
@synthesize scrobbleOverlay;
@synthesize timeElapsedLabel;
@synthesize timeRemainingLabel;
@synthesize shuffleButton;
@synthesize repeatButton;
@synthesize coverArtGestureRecognizer;
@synthesize currentTrackLength;
@synthesize numberOfTracks;
@synthesize scrobbling;
@synthesize scrobbleHelpLabel;
@synthesize numberOfTracksLabel;
@synthesize scrobbleHighlightShadow;
@synthesize repeatMode;
@synthesize shuffling;
@synthesize lastDirectionChangePositive;
@synthesize shouldHideNextTrackButtonAtBoundary;
@synthesize shouldHidePreviousTrackButtonAtBoundary;
@synthesize navigationItem;
@synthesize preferredSizeForCoverArt;
@synthesize backBlock, actionBlock;
@synthesize placeholderImageDelay;

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		[streamer stop];
		streamer = nil;
	}
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
	if (streamer)
	{
		return;
	}
    
	[self destroyStreamer];
    
	NSURL *url = [NSURL URLWithString:@"http://rock.radio.depaul.edu:8000"];
	streamer = [[AudioStreamer alloc] initWithURL:url];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	
    
    NSLog(@"my delegate is %@", self.delegate);
    NSLog(@"my datasource is %@", self.dataSource);
    
    MPVolumeView *volumeSliderView = [[MPVolumeView alloc] initWithFrame:volumeView.bounds];
	[volumeView addSubview:volumeSliderView];
	[volumeView sizeToFit];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIApplication *application = [UIApplication sharedApplication];
	if([application respondsToSelector:@selector(beginReceivingRemoteControlEvents)])
		[application beginReceivingRemoteControlEvents];
	[self becomeFirstResponder]; // this enables listening for events
	// update the UI in case we were in the background
    
	NSNotification *notification =
	[NSNotification
	 notificationWithName:ASStatusChangedNotification
	 object:self];
	[[NSNotificationCenter defaultCenter]
	 postNotification:notification];
}

#pragma mark Remote Control Events
/* The iPod controls will send these events when the app is in the background */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlPlay:
			[streamer start];
			break;
		case UIEventSubtypeRemoteControlPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlStop:
			[streamer stop];
			break;
		default:
			break;
	}
}

- (void)playbackStateChanged:(NSNotification *)aNotification
{
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if ([streamer isWaiting])
	{
		if (appDelegate.uiIsVisible) {
			[streamer setMeteringEnabled:NO];
		}
	}
	else if ([streamer isPlaying])
	{
		if (appDelegate.uiIsVisible) {
			[streamer setMeteringEnabled:YES];
            [hud hide:true];
		}
	}
	else if ([streamer isPaused]) {
		if (appDelegate.uiIsVisible) {
			[streamer setMeteringEnabled:NO];
		}
	}
	else if ([streamer isIdle])
	{
		if (appDelegate.uiIsVisible) {
		}
		[self destroyStreamer];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Scrobble Ovelray alpha should be 0, initialize the gesture recognizer
    self.scrobbleOverlay.alpha = 0;
    self.coverArtGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverArtTapped:)];
    [self.albumArtImageView addGestureRecognizer:self.coverArtGestureRecognizer];
    
    // Knobs for the sliders
    
    UIImage* sliderBlueTrack = [[UIImage imageNamed:@"BeamMusicPlayerController.bundle/images/VolumeBlueTrack.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0];
    UIImage* slideWhiteTrack = [[UIImage imageNamed:@"BeamMusicPlayerController.bundle/images/VolumeWhiteTrack.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0];
    UIImage* knob = [UIImage imageNamed:@"BeamMusicPlayerController.bundle/images/VolumeKnob"];
    
    [[UISlider appearanceWhenContainedIn:[self class], nil] setThumbImage:knob forState:UIControlStateNormal];

    [[UISlider appearance] setMinimumTrackImage:sliderBlueTrack forState:UIControlStateNormal];
    [[UISlider appearance] setMaximumTrackImage:slideWhiteTrack forState:UIControlStateNormal];

    // The Original Toolbar is 48px high in the iPod/Music app
    CGRect toolbarRect = self.controlsToolbar.frame;
    toolbarRect.size.height = 48;
    self.controlsToolbar.frame = toolbarRect;

    // Set UI to non-scrobble
    [self setScrobbleUI:NO];
    
    // Set up labels. These are autoscrolling and need code-base setup.
    [self.artistNameLabel setShadowColor:[UIColor blackColor]];
    [self.artistNameLabel setShadowOffset:CGSizeMake(0, -1)];
    [self.artistNameLabel setTextColor:[UIColor lightTextColor]];
    [self.artistNameLabel setFont:[UIFont boldSystemFontOfSize:12]];

    
    [self.albumTitleLabel setShadowColor:[UIColor blackColor]];
    [self.albumTitleLabel setShadowOffset:CGSizeMake(0, -1)];
    [self.albumTitleLabel setTextColor:[UIColor lightTextColor]];
    [self.albumTitleLabel setFont:[UIFont boldSystemFontOfSize:12]];

    self.trackTitleLabel.textColor = [UIColor whiteColor];
    [self.trackTitleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    
    self.placeholderImageDelay = 0.5;
    
}

- (void)viewDidUnload
{
    self.actionButton = nil;
    self.backButton = nil;
    [self destroyStreamer];
    [self setVolumeView:nil];
    [super viewDidUnload];
    self.coverArtGestureRecognizer = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    } else {
        return YES;
    }
}

-(void)setDelegate:(id<BeamMusicPlayerDelegate>)value {
    self->delegate = value;
    self.navigationItem.rightBarButtonItem = self.actionBlock ? self.actionButton : nil;
    self.navigationItem.leftBarButtonItem = self.backBlock ? self.backButton : nil;
}


#pragma mark - Playback Management

-(BOOL)numberOfTracksAvailable {
    return self.numberOfTracks >= 0;
}

-(void)setAlbumArtToPlaceholder {
    self.albumArtImageView.image = [UIImage imageNamed:@"BeamMusicPlayerController.bundle/images/noartplaceholder.png"];
    self.albumArtReflection.image = [self.albumArtImageView reflectedImageWithHeight:self.albumArtReflection.frame.size.height];
}

/**
 * Updates the UI to match the current track by requesting the information from the datasource.
 */
-(void)updateUIForCurrentTrack {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.artistNameLabel.text = @"Radio DePaul";//[self.dataSource musicPlayer:self artistForTrack:self.currentTrack];
    self.trackTitleLabel.text = app.onAirSlot.show.title;//[self.dataSource musicPlayer:self titleForTrack:self.currentTrack];
    self.albumTitleLabel.text = app.onAirSlot.show.genres;//[self.dataSource musicPlayer:self albumForTrack:self.currentTrack];

    // set coverart to placeholder at a later point in time. Might be cancelled if datasource provides different image (see below)
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setAlbumArtToPlaceholder) object:nil];
    [self performSelector:@selector(setAlbumArtToPlaceholder) withObject:nil afterDelay:self.placeholderImageDelay];

    // We only request the coverart if the delegate responds to it.
    if ( [self.dataSource respondsToSelector:@selector(musicPlayer:artworkForTrack:receivingBlock:)]) {
        
        // TODO: this transition needs to be overhauled before going live
//        CATransition* transition = [CATransition animation];
//        transition.type = kCATransitionPush;
//        transition.subtype = self.lastDirectionChangePositive ? kCATransitionFromRight : kCATransitionFromLeft;
//        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        [[self.albumArtImageView layer] addAnimation:transition forKey:@"SlideOutandInImagek"];
//
//        [[self.albumArtReflection layer] addAnimation:transition forKey:@"SlideOutandInImagek"];

        // Copy the current track to another variable, otherwise we would just access the current one.
        NSUInteger track = self.currentTrack;
        // Request the image. 
        [self.dataSource musicPlayer:self artworkForTrack:self.currentTrack receivingBlock:^(UIImage *image, NSError *__autoreleasing *error) {
            if ( track == self.currentTrack ){
            
                // If there is no image given, stay with the placeholder
                if ( image  != nil ){

                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setAlbumArtToPlaceholder) object:nil];
                        [(id)self.albumArtImageView setImageWithURL: app.onAirSlot.show.photo_large
                    placeholderImage:[UIImage imageNamed:@"placeholder_large"]];
                        self.albumArtReflection.image = [self.albumArtImageView reflectedImageWithHeight:self.albumArtReflection.frame.size.height];
                    });
                }
            
            } else {
                NSLog(@"Discarded CoverArt for track: %d, current track already moved to %d.", track, self.currentTrack);
            }
        }];
    }
}

-(void)play {
    if ( !self.playing ){
        self->playing = YES;
        
        self.playbackTickTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playbackTick:) userInfo:nil repeats:YES];
        
        [self createStreamer];
		[streamer start];
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if ([MPNowPlayingInfoCenter class])  {
            /* we're on iOS 5, so set up the now playing center */
            MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:self.albumArtImageView.image];
            
            NSDictionary *currentlyPlayingTrackInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Radio DePaul", app.onAirSlot.show.title, app.onAirSlot.show.genres, albumArt, nil] forKeys:[NSArray arrayWithObjects:MPMediaItemPropertyArtist, MPMediaItemPropertyTitle, MPMediaItemPropertyAlbumTitle, MPMediaItemPropertyArtwork, nil]];
            [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = currentlyPlayingTrackInfo;
        }
        
        if ( [self.delegate respondsToSelector:@selector(musicPlayerDidStartPlaying:)] ){
            [self.delegate musicPlayerDidStartPlaying:self];
        }
        [self adjustPlayButtonState];
    }
}

-(void)pause {
    if ( self.playing ){
        self->playing = NO;
        [self.playbackTickTimer invalidate];
        self.playbackTickTimer = nil;
        
        if ( [self.delegate respondsToSelector:@selector(musicPlayerDidStopPlaying:)] ){
            [self.delegate musicPlayerDidStopPlaying:self];
        }
        
        [streamer pause];
        
        [self adjustPlayButtonState];

    }
}

-(void)next {
    self.lastDirectionChangePositive = YES;
    [self changeTrack:self->currentTrack+1];
}

-(void)previous {
    self.lastDirectionChangePositive = NO;

    [self changeTrack:self->currentTrack-1];
}

/*
 * Called when the player finished playing the current track. 
 */
-(void)currentTrackFinished {
    // TODO: deactivate automatic actions via additional property
    // overhaul this method
    if ( self.repeatMode != MPMusicRepeatModeOne ){
        // [self next];  - reactivate me

    } else {
        self->currentPlaybackPosition = 0;
        [self updateSeekUI];
    }
}

-(void)playTrack:(NSUInteger)track atPosition:(CGFloat)position volume:(CGFloat)volume {
    self.volume = volume;
    [self changeTrack:track];
    self->currentPlaybackPosition = position;
    [self play];
}

-(void)updateUI {
    // Slider
    self.progressSlider.maximumValue = self.currentTrackLength;
    self.progressSlider.minimumValue = 0;
    
    [self updateUIForCurrentTrack];
    [self updateSeekUI];
    [self updateTrackDisplay];
    [self adjustDirectionalButtonStates];
}

/*
 * Changes the track to the new track given.
 */
-(void)changeTrack:(NSInteger)newTrack {
    BOOL shouldChange = YES;
    if ( [self.delegate respondsToSelector:@selector(musicPlayer:shoulChangeTrack:) ]){
        shouldChange = [self.delegate musicPlayer:self shouldChangeTrack:newTrack];
    }
    
    if([self.dataSource respondsToSelector:@selector(numberOfTracksInPlayer:)])
        self.numberOfTracks = [self.dataSource numberOfTracksInPlayer:self];
    else
        self.numberOfTracks = -1;

    if (newTrack < 0 || (self.numberOfTracksAvailable && newTrack >= self.numberOfTracks)){
        shouldChange = NO;
        // If we can't next, stop the playback.
        // TODO: notify delegate about the fact we felt off the playlist
        [self pause];
    }
    
    if ( shouldChange ){
        if ( [self.delegate respondsToSelector:@selector(musicPlayer:didChangeTrack:) ]){
            newTrack = [self.delegate musicPlayer:self didChangeTrack:newTrack];
        }
        if(newTrack == NSNotFound) {
            // TODO: notify delegate about the fact we felt off the playlist
            [self pause];
        } else {
            self->currentPlaybackPosition = 0;
            self.currentTrack = newTrack;
            
            self.currentTrackLength = [self.dataSource musicPlayer:self lengthForTrack:self.currentTrack];
            [self updateUI];
        }
    }
}

/**
 * Reloads data from the data source and updates the player.
 */
-(void)reloadData {
    if([self.dataSource respondsToSelector:@selector(numberOfTracksInPlayer:)])
        self.numberOfTracks = [self.dataSource numberOfTracksInPlayer:self];
    else
        self.numberOfTracks = -1;
    self.currentTrackLength = [self.dataSource musicPlayer:self lengthForTrack:self.currentTrack];
    
    [self updateUI];
}

/**
 * Tick method called each second when playing back.
 */
-(void)playbackTick:(id)unused {
    // Only tick forward if not scrobbling.
    if ( !self.scrobbling ){
        if ( self->currentPlaybackPosition+1.0 > self.currentTrackLength ){
            [self currentTrackFinished];
        } else {
            self->currentPlaybackPosition += 1.0f;
            [self updateSeekUI];
        }
    }
}

/*
 * Updates the remaining and elapsed time label, as well as the progress bar's value
 */
-(void)updateSeekUI {
    NSString* elapsed = [NSDateFormatter formattedDuration:(long)self.currentPlaybackPosition];
    NSString* remaining = [NSDateFormatter formattedDuration:(self.currentTrackLength-self.currentPlaybackPosition)*-1];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timeElapsedLabel.text =elapsed;
        self.timeRemainingLabel.text =remaining;
        self.progressSlider.value = self.currentPlaybackPosition;
    });
}

/*
 * Updates the Track Display ( Track 10 of 10 )
 */
-(void)updateTrackDisplay {
    if ( !self.scrobbling ){
        self.numberOfTracksLabel.text = @"Live Stream";//[NSString stringWithFormat:@"Track %d of %d", self.currentTrack+1, self.numberOfTracks];
        self.numberOfTracksLabel.hidden = !self.numberOfTracksAvailable;
    }
}

-(void)updateRepeatButton {
    MPMusicRepeatMode currentMode = self->repeatMode;
    NSString* imageName = nil;
    switch (currentMode) {
        case MPMusicRepeatModeDefault:
            imageName = @"repeat_off.png";
            break;
        case MPMusicRepeatModeOne:
            imageName = @"repeat_on_1.png";
            break;
        case MPMusicRepeatModeAll:
            imageName = @"repeat_on.png";
            break;
    }
    if ( imageName )
        [self.repeatButton setImage:[UIImage imageNamed:[@"BeamMusicPlayerController.bundle/images/" stringByAppendingString:imageName]] forState:UIControlStateNormal];
}

#pragma mark Repeat mode

-(void)setRepeatMode:(int)newRepeatMode {
    self->repeatMode = newRepeatMode;
    [self updateRepeatButton];
}

#pragma mark Shuffling ( Every day I'm )

-(void)setShuffling:(BOOL)newShuffling {
    self->shuffling = newShuffling;
    
    NSString* imageName = ( self.shuffling ? @"shuffle_on.png" : @"shuffle_off.png");
    [self.shuffleButton setImage:[UIImage imageNamed:[@"BeamMusicPlayerController.bundle/images/" stringByAppendingString:imageName]] forState:UIControlStateNormal];
}

#pragma mark - Volume

/*
 * Setting the volume really just changes the slider
 */
-(void)setVolume:(CGFloat)volume {
    //self.volumeSlider.value = volume;
}

/*
 * The Volume value is the slider value
 */
-(CGFloat)volume {
    return 0.0f;
    //return self.volumeSlider.value;
}

#pragma mark - User Interface ACtions

-(IBAction)playAction:(UIBarButtonItem*)sender {
    if ( self.playing ){
        [self pause];
    } else {
        [self play];
    }
}

-(IBAction)nextAction:(id)sender {
    [self next];
}

-(IBAction)previousAction:(id)sender {
    // TODO: handle skipToBeginning if playbacktime <= 3
    [self previous];
}


/**
 * Called when the cover art is tapped. Either shows or hides the scrobble-ui
 */
-(IBAction)coverArtTapped:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        if ( self.scrobbleOverlay.alpha == 0 ){
            [self.scrobbleOverlay setAlpha:1];
        } else {
            [self.scrobbleOverlay setAlpha:0];
        }
    }];
}



#pragma mark - Playback button state management

/*
 * Adjusts the directional buttons to comply with the shouldHide-Button settings.
 */
-(void)adjustDirectionalButtonStates {
    if (self.numberOfTracksAvailable && self.currentTrack+1 == self.numberOfTracks && self.shouldHideNextTrackButtonAtBoundary ){
        self.fastForwardButton.enabled = NO;
    } else {
        self.fastForwardButton.enabled = YES;
    }
    
    if (self.numberOfTracksAvailable && self.currentTrack == 0 && self.shouldHidePreviousTrackButtonAtBoundary ){
        self.rewindButton.enabled = NO;
    } else {
        self.rewindButton.enabled = YES;
    }
}

/*
 * Adjusts the state of the play button to match the current state of the player
 */
-(void)adjustPlayButtonState {
    if ( !self.playing ){
        self.playButton.image = [UIImage imageNamed:@"BeamMusicPlayerController.bundle/images/play.png"];
    } else {
        self.playButton.image = [UIImage imageNamed:@"BeamMusicPlayerController.bundle/images/pause.png"];
    }
}

-(void)setShouldHideNextTrackButtonAtBoundary:(BOOL)newShouldHideNextTrackButtonAtBoundary {
    self->shouldHideNextTrackButtonAtBoundary = newShouldHideNextTrackButtonAtBoundary;
    [self adjustDirectionalButtonStates];
}

-(void)setShouldHidePreviousTrackButtonAtBoundary:(BOOL)newShouldHidePreviousTrackButtonAtBoundary {
    self->shouldHidePreviousTrackButtonAtBoundary = newShouldHidePreviousTrackButtonAtBoundary;
    [self adjustDirectionalButtonStates];
}

#pragma mark - scrubbing slider

/**
 * Called whenever the scrubber changes it's speed. Used to update the display of the scrobble speed.
 */
-(void)updateUIForScrubbingSpeed:(CGFloat)speed {
    if ( speed == 1.0 ){
        self.numberOfTracksLabel.text = @"Hi-Speed Scrubbing";
    } else if ( speed == 0.5 ){
        self.numberOfTracksLabel.text = @"Half-Speed Scrubbing";
        
    }else if ( speed == 0.25 ){
        self.numberOfTracksLabel.text = @"Quarter-Speed Scrubbing";
        
    } else {
        self.numberOfTracksLabel.text = @"Fine Scrubbing";
    }
}

/**
 * Dims away the repeat and shuffle button
 */
- (IBAction)sliderDidBeginScrubbing:(id)sender {
    self.scrobbling = YES;
    [self setScrobbleUI:YES];
}

/**
 * Shows the repeat and shuffle button and hides the scrobble help
 */
- (IBAction)sliderDidEndScrubbing:(id)sender {
    self.scrobbling = NO;
    [self setScrobbleUI:NO];
    [self updateTrackDisplay];
}

/*
 * Updates the UI according to the current scrobble state given.
 */
-(void)setScrobbleUI:(BOOL)scrobbleState {
    float alpha = ( scrobbleState ? 1 : 0 );
    [UIView animateWithDuration:0.25 animations:^{
        self.repeatButton.alpha = 1-alpha;
        self.shuffleButton.alpha = 1-alpha;
        self.scrobbleHelpLabel.alpha = alpha;
        self.scrobbleHighlightShadow.alpha = alpha;
    }];
}

/*
 * Action triggered by the continous track progress slider
 */
-(IBAction)sliderValueChanged:(id)slider {
    self->currentPlaybackPosition = self.progressSlider.value;
    [self updateUIForScrubbingSpeed: self.progressSlider.scrubbingSpeed];
    
    if ( [self.delegate respondsToSelector:@selector(musicPlayer:didSeekToPosition:)]) {
        [self.delegate musicPlayer:self didSeekToPosition:self->currentPlaybackPosition];
    }
    
    [self updateSeekUI];
    
}

/*
 * Action triggered by the volume slider
 */
-(IBAction)volumeSliderValueChanged:(id)sender {
    if ( [self.delegate respondsToSelector:@selector(musicPlayer:didChangeVolume:)]) {
        //[self.delegate musicPlayer:self didChangeVolume:self.volumeSlider.value];
    }
}

/*
 * Action triggered by the repeat mode button
 */
-(IBAction)repeatModeButtonAction:(id)sender{
    MPMusicRepeatMode currentMode = self.repeatMode;
    switch (currentMode) {
        case MPMusicRepeatModeDefault:
            self.repeatMode = MPMusicRepeatModeAll;
            break;
        case MPMusicRepeatModeOne:
            self.repeatMode = MPMusicRepeatModeDefault;
            break;
        case MPMusicRepeatModeAll:
            self.repeatMode = MPMusicRepeatModeOne ;
            break;
        default:
            self.repeatMode = MPMusicRepeatModeOne;
            break;
    }
    if ( [self.delegate respondsToSelector:@selector(musicPlayer:didChangeRepeatMode:)]) {
        [self.delegate musicPlayer:self didChangeRepeatMode:self.repeatMode];
    }
}

/*
 * Changes the shuffle mode and calls the delegate
 */
-(IBAction)shuffleButtonAction:(id)sender {
    self.shuffling = !self.shuffling;
    if ( [self.delegate respondsToSelector:@selector(musicPlayer:didChangeShuffleState:)]) {
        [self.delegate musicPlayer:self didChangeShuffleState:self.shuffling];
    }
}

- (IBAction)backButtonAction:(id)sender {
    if (self.backBlock)
        self.backBlock();
}

/*
 * Just forward the action message to the delegate
 */
-(IBAction)actionButtonAction:(id)sender {
    if(self.actionBlock)
        self.actionBlock();
}

#pragma mark Cover Art resolution handling

-(CGSize)preferredSizeForCoverArt {
    CGFloat scale = UIScreen.mainScreen.scale;
    CGSize points = self.albumArtImageView.frame.size;
    return  CGSizeMake(points.width * scale, points.height * scale);
}

-(CGFloat)displayScale {
    return [UIScreen mainScreen].scale;
}


- (void)dealloc {
    [volumeView release];
    [super dealloc];
}
@end
