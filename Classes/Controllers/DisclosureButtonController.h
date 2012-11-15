//
//  DisclosureButtonController.h
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "SecondLevelController.h"
#import "MBProgressHUD.h"

@interface DisclosureButtonController : UITableViewController <MBProgressHUDDelegate, RKRequestDelegate, RKObjectLoaderDelegate> {
}
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSString *day;

- (id) initWithDay:(NSString *) scheduleDay;

@end
