//
//  OnAirNowViewController.m
//  Radio DePaul
//
//  Created by Devon Blandin on 11/13/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "OnAirNowViewController.h"

@interface OnAirNowViewController ()

@end

@implementation OnAirNowViewController

- (id)initWithViewController:(UIViewController*)viewController bottomView:(UIViewController*)bottomViewController
{
    self = [super init];
    if (self) {
        
        //  Set up view size for navigationController; use full bounds minus 60pt at the bottom
        CGRect navigationControllerFrame = self.view.bounds;
        navigationControllerFrame.size.height -= 60;
        viewController.view.frame = navigationControllerFrame;
        
        //  Set up view size for bottomView
        CGRect bottomViewFrame = CGRectMake(0, self.view.bounds.size.height-60, self.view.bounds.size.width, 60);
        bottomViewController.view.frame = bottomViewFrame;
        
        //  Enable autoresizing for both the navigationController and the bottomView
        viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bottomViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        //  Add views as subviews to the current view
        [self.view addSubview:viewController.view];
        [self.view addSubview:bottomViewController.view];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

@end
