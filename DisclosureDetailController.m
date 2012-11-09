//
//  DisclosureDetailController.m
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "DisclosureDetailController.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

@interface DisclosureDetailController ()
{
    MWPhotoBrowser *browser;
}

@end

@implementation DisclosureDetailController
@synthesize showTitle;
@synthesize showGenres;
@synthesize showDescription;
@synthesize showImage;
@synthesize showSchedule;
@synthesize showStartTime;
@synthesize showEndTime;
@synthesize label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) setupUI;
{
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern"]]];
}

- (void)viewWillAppear:(BOOL)animated {

    browser = nil;
    NSMutableArray *photosIn = [[NSMutableArray array] init];
    [photosIn addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[[self.slot objectForKey:@"show"] objectForKey:@"photo_large"]]]];
    self.photos = [photosIn mutableCopy];
    NSDictionary *show = [self.slot objectForKey:@"show"];
    self.title = [show objectForKey:@"title"];
    self.showTitle.text = [show objectForKey:@"title"];
    self.showDescription.text = [show objectForKey:@"long_description"];
    self.showStartTime.text = [self.slot objectForKey:@"start_time"];
    self.showEndTime.text = [self.slot objectForKey:@"end_time"];
    self.showSchedule.text = [show objectForKey:@"schedule_at"];
    if (hasRetinaDisplay)
    {
        NSLog(@"medium image loaded");
        [showImage setImageWithURL:[NSURL URLWithString:[show objectForKey:@"photo_medium"]]
                  placeholderImage:[UIImage imageNamed:@"placeholder_small"]];
    }
    else
    {
        NSLog(@"small image loaded");
        [showImage setImageWithURL:[NSURL URLWithString:[show objectForKey:@"photo_small"]]
                  placeholderImage:[UIImage imageNamed:@"placeholder_small"]];
    }
    
    [showImage.layer setBorderWidth:5.0f];
    [showImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [showImage.layer setShadowRadius:5.0f];
    [showImage.layer setShadowOpacity:.85f];
    [showImage.layer setShadowOffset:CGSizeMake(1.0f, 2.0f)];
    [showImage.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [showImage.layer setShouldRasterize:YES];
    [showImage.layer setMasksToBounds:NO];
    
    browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setShowTitle:nil];
    [self setShowGenres:nil];
    [self setShowImage:nil];
    [self setShowDescription:nil];
    [self setShowImage:nil];
    [self setShowSchedule:nil];
    [self setShowStartTime:nil];
    [self setShowEndTime:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

BOOL hasRetinaDisplay(void)
{
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        return [[UIScreen mainScreen] scale] == 2.0 ? YES : NO;
    return NO;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (IBAction)showImageBrowser:(UIButton *)sender {
    NSLog(@"%@", self.title);
    browser.wantsFullScreenLayout = YES; // Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
    browser.displayActionButton = YES; // Show action button to save, copy or email photos (defaults to NO)
    [self.navigationController pushViewController:browser animated:YES];
}
@end
