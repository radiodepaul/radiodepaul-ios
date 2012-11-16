//
//  ListenNavigationViewController.m
//  Radio DePaul
//
//  Created by Devon Blandin on 11/13/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "ListenNavigationViewController.h"
#import "ListenViewController.h"
#import "DisclosureDetailController.h"
#import "ListenViewController.h"

@interface ListenNavigationViewController ()
@end

@implementation ListenNavigationViewController

@synthesize streamViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Listen";
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    [self addChildViewController: streamViewController];
//    CGRect bottomViewFrame = CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 50);
//    streamViewController.view.frame = bottomViewFrame;
//    [self.view addSubview:streamViewController.view];
        
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// Setting the image of the tab.
- (NSString *)tabImageName
{
    return @"listen.png";
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return @"On Air Now";
}

@end