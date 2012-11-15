//
//  NewsPostViewController.h
//  Radio DePaul
//
//  Created by Devon Blandin on 11/14/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsPost;

@interface NewsPostViewController : UITableViewController {
    NewsPost *newsPost;
}

@property (nonatomic, retain) NewsPost *newsPost;

- (id) initWithNewsPost:(NewsPost *) aNewsPost;
@end
