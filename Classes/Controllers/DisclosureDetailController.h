//
//  DisclosureDetailController.h
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "ScheduleSlot.h"
#import "Show.h"
#import "Person.h"

@interface DisclosureDetailController : UITableViewController <MWPhotoBrowserDelegate> {
    ScheduleSlot *slot;
    NSArray *photos;
}

@property (nonatomic, retain) ScheduleSlot *slot;
@property (nonatomic, retain) NSArray *photos;

- (IBAction)showImageBrowser:(UIButton *)sender;
- (id)initWithScheduleSlot:(ScheduleSlot *) scheduleSlot;

@end