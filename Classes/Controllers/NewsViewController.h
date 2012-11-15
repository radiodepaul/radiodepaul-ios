//
//  NewsViewController.h
//  Radio DePaul
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class NewsPostViewController;

@interface NewsViewController : UITableViewController <MBProgressHUDDelegate, RKRequestDelegate, RKObjectLoaderDelegate> {
    NSArray *newsPosts;
}

@property (nonatomic, retain) NSArray *newsPosts;
@property (strong, nonatomic) NewsPostViewController *childController;

@end
