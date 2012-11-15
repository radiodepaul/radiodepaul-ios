//
//  NavigationController.m
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "NavigationController.h"
#import "FirstLevelController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (id) initWithCoder:(NSCoder *)aDecoder
{
    [super initWithCoder:aDecoder];
    
    return self;
}

- (id) initWithRootViewController:(UIViewController *)rootViewController
{
    
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
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
