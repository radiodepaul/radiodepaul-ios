//
//  DisclosureDetailController.h
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface DisclosureDetailController : UIViewController <MWPhotoBrowserDelegate>

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *showTitle;
@property (strong, nonatomic) IBOutlet UILabel *showGenres;
@property (strong, nonatomic) IBOutlet UILabel *showDescription;
@property (strong, nonatomic) IBOutlet UIImageView *showImage;
@property (strong, nonatomic) IBOutlet UILabel *showSchedule;
@property (strong, nonatomic) IBOutlet UILabel *showStartTime;
@property (strong, nonatomic) IBOutlet UILabel *showEndTime;
@property (copy, nonatomic) NSDictionary *slot;
@property (copy, nonatomic) NSArray *photos;
- (IBAction)showImageBrowser:(UIButton *)sender;

@end
