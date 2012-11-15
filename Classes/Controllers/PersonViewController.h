//
//  PersonViewController.h
//  Radio DePaul
//
//  Created by Devon Blandin on 11/14/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
@class Person;

@interface PersonViewController : UITableViewController {
    Person *person;
}

@property (nonatomic, retain) Person *person;

- (id) initWithPerson:(Person *) aPerson;
@end
