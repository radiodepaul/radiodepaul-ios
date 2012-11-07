//
//  DisclosureDetailController.m
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "DisclosureDetailController.h"
#import <QuartzCore/QuartzCore.h>

@interface DisclosureDetailController ()

@end

@implementation DisclosureDetailController
@synthesize showTitle;
@synthesize showGenres;
@synthesize showDescription;
@synthesize showImage;
@synthesize showSchedule;
@synthesize label;
@synthesize message, show_id;

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern"]]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.showTitle.text = [self.show objectForKey:@"title"];
    self.showDescription.text = [self.show objectForKey:@"short_description"];
    NSData *image = [NSData alloc];
    if ([self.show objectForKey:@"photo_data"] != nil)
    {
        image = [self.show objectForKey:@"photo_data"];
    }
    else
    {
        image = [image initWithContentsOfURL:[[NSURL alloc] initWithString:[self.show objectForKey:@"photo"]]];
        [self.show setValue:image forKey:@"photo_data"];
    }
    showImage.image = [[UIImage alloc] initWithData:image];
    [showImage.layer setBorderWidth:5.0f];
    [showImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [showImage.layer setShadowRadius:5.0f];
    [showImage.layer setShadowOpacity:.85f];
    [showImage.layer setShadowOffset:CGSizeMake(1.0f, 2.0f)];
    [showImage.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [showImage.layer setShouldRasterize:YES];
    [showImage.layer setMasksToBounds:NO];
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    self.label = nil;
    self.message = nil;
    [self setShowTitle:nil];
    [self setShowGenres:nil];
    [self setShowImage:nil];
    [self setShowDescription:nil];
    [self setShowImage:nil];
    [self setShowSchedule:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
