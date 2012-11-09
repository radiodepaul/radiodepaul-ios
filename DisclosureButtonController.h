//
//  DisclosureButtonController.h
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "SecondLevelController.h"
#import "MBProgressHUD.h"

@interface DisclosureButtonController : SecondLevelController <MBProgressHUDDelegate> {
    NSMutableData *receivedData;
}
@property (copy, nonatomic) NSArray *list;
@property (copy, nonatomic) NSString *day;

@end
