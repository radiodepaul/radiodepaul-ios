//
//  FirstLevelController.m
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "FirstLevelController.h"
#import "SecondLevelController.h"
#import "DisclosureButtonController.h"

@interface FirstLevelController ()

@end

@implementation FirstLevelController
@synthesize controllers;




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
    [TestFlight passCheckpoint:@"Visited Schedule View"];
    self.title = @"Schedule";
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    // Disclosure Button
    DisclosureButtonController *monday = [[DisclosureButtonController alloc]
                                                              initWithStyle:UITableViewStylePlain];
    monday.title = @"Monday";
    DisclosureButtonController *tuesday = [[DisclosureButtonController alloc]
                                                              initWithStyle:UITableViewStylePlain];
    tuesday.title = @"Tuesday";
    DisclosureButtonController *wednesday = [[DisclosureButtonController alloc]
                                           initWithStyle:UITableViewStylePlain];
    wednesday.title = @"Wednesday";
    DisclosureButtonController *thursday = [[DisclosureButtonController alloc]
                                           initWithStyle:UITableViewStylePlain];
    thursday.title = @"Thursday";
    DisclosureButtonController *friday = [[DisclosureButtonController alloc]
                                           initWithStyle:UITableViewStylePlain];
    friday.title = @"Friday";
    DisclosureButtonController *saturday = [[DisclosureButtonController alloc]
                                           initWithStyle:UITableViewStylePlain];
    saturday.title = @"Saturday";
    DisclosureButtonController *sunday = [[DisclosureButtonController alloc]
                                           initWithStyle:UITableViewStylePlain];
    sunday.title = @"Sunday";
    
    NSMutableArray *days = [[NSMutableArray alloc] initWithObjects:monday,tuesday,wednesday,thursday,friday,saturday,sunday, nil];
    [array addObjectsFromArray:days];
    
    
    self.controllers = array;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.controllers = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.controllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *FirstLevelCell= @"FirstLevelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: FirstLevelCell];
    }
    // Configure the cell
    NSUInteger row = [indexPath row];
    SecondLevelController *controller =
    [controllers objectAtIndex:row];
    cell.textLabel.text = controller.title;
    cell.imageView.image = controller.rowImage;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    SecondLevelController *nextController = [self.controllers
                                                    objectAtIndex:row];
    [self.navigationController pushViewController:nextController
                                         animated:YES];
}

@end
