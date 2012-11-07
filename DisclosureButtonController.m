#import "DisclosureButtonController.h"
#import "AppDelegate.h"
#import "DisclosureDetailController.h"

@interface DisclosureButtonController ()
@property (strong, nonatomic) DisclosureDetailController *childController;
@end

@implementation DisclosureButtonController

@synthesize list;
@synthesize childController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [TestFlight passCheckpoint:@"Visited Schedule Day View"];
    [self getShowData];
}

- (void) getShowData
{
    NSMutableArray *shows = [[NSMutableArray alloc] init];
    NSError *e = nil;
    NSString *url = @"http://radiodepaul.herokuapp.com/api/getSchedule.json";
    NSData *data = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:url]];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        for(NSDictionary *slot in jsonArray) {
            [shows addObject:slot];
        }
        self.list = shows;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.list = nil;
    self.childController = nil;
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * DisclosureButtonCellIdentifier = @"DisclosureButtonCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             DisclosureButtonCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: DisclosureButtonCellIdentifier];
    }
    NSUInteger row = [indexPath row];
    NSDictionary *show = [[list objectAtIndex:row] objectForKey:@"show"];
    NSString *rowString = [show objectForKey:@"title"];
    cell.textLabel.text = rowString;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    NSData *image = [NSData alloc];
    if ([show objectForKey:@"photo_data"] != nil)
    {
         image = [show objectForKey:@"photo_data"];
    }
    else
    {
        image = [image initWithContentsOfURL:[[NSURL alloc] initWithString:[show objectForKey:@"photo"]]];
        [show setValue:image forKey:@"photo_data"];
    }
    cell.imageView.image = [[UIImage alloc] initWithData:image];
    return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:
                          @"Hey, do you see the disclosure button?"
                                                    message:@"If you're trying to drill down, touch that instead"
                                                   delegate:nil
                                          cancelButtonTitle:@"Won't happen again"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (childController == nil) {
        childController = [[DisclosureDetailController alloc]
                           initWithNibName:@"DisclosureDetail" bundle:nil];
    }

    childController.title = @"Disclosure Button Pressed";
    NSUInteger row = [indexPath row];
    NSDictionary *selectedSlot = [list objectAtIndex:row];
    NSString *detailMessage = [[NSString alloc]
                               initWithFormat:@"You pressed the disclosure button for %@.",
                               [[selectedSlot objectForKey:@"show"] objectForKey:@"title"]];
    childController.show_id = [[selectedSlot objectForKey:@"show"] objectForKey:@"id"];
    childController.title = [[selectedSlot objectForKey:@"show"] objectForKey:@"title"];
    childController.message = detailMessage;
    childController.show = [selectedSlot objectForKey:@"show"];
    [self.navigationController pushViewController:childController
                                         animated:YES];
}

@end