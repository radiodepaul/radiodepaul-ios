//
//  InfoViewController.h
//  Radio DePaul
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
- (IBAction)sendFeedback:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (void) setupUI;
@end
