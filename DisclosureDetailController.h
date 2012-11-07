//
//  DisclosureDetailController.h
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisclosureDetailController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *show_id;
@property (strong, nonatomic) IBOutlet UILabel *showTitle;
@property (strong, nonatomic) IBOutlet UILabel *showGenres;
@property (strong, nonatomic) IBOutlet UILabel *showDescription;
@property (strong, nonatomic) IBOutlet UIImageView *showImage;
@property (strong, nonatomic) IBOutlet UILabel *showSchedule;
@property (copy, nonatomic) NSDictionary *show;

@end
