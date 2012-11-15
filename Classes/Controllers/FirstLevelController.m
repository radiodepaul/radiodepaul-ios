//
//  FirstLevelController.m
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "FirstLevelController.h"
#import "DisclosureButtonController.h"

@implementation FirstLevelController
@synthesize days;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Schedule";
    
    NSArray *scheduleDays = [[NSArray alloc] initWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
    
    self.days = scheduleDays;
    [scheduleDays release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.days = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.days count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *FirstLevelCell= @"FirstLevelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: FirstLevelCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: FirstLevelCell];
    }
    
    [self prepareCell:cell forIndexPath:indexPath];
    
    return cell;
}
- (void)prepareCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NSString *day = [self.days objectAtIndex:indexPath.row];
    cell.textLabel.text = day;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
}


#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *day = [[self.days objectAtIndex:indexPath.row] lowercaseString];
    DisclosureButtonController *childController = [[DisclosureButtonController alloc] initWithDay:day];
    
    [self.navigationController pushViewController:childController animated:YES];
}

// Setting the image of the tab.
- (NSString *)tabImageName
{
    return @"schedule.png";
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return @"Schedule";
}

@end
