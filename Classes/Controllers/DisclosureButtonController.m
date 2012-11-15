#import "DisclosureButtonController.h"
#import "AppDelegate.h"
#import "DisclosureDetailController.h"
#import "ScheduleSlot.h"
#import "Show.h"
#import "Person.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVPullToRefresh.h"


@interface DisclosureButtonController () {
    MBProgressHUD *hud;
}

@property (strong, nonatomic) DisclosureDetailController *childController;
@end

@implementation DisclosureButtonController
@synthesize list;
@synthesize childController;
@synthesize day;

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = [self.day capitalizedString];
    
    [self loadSchedule];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self loadSchedule];
    }];
}

- (id) initWithDay:(NSString *) scheduleDay
{
    if (![[DisclosureButtonController alloc] initWithStyle:UITableViewStylePlain])
        return nil;
    
    self.day = scheduleDay;
    
    return self;
}

- (void)loadSchedule {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    // mapping for slots
    RKObjectMapping *slotMapping = [RKObjectMapping mappingForClass:[ScheduleSlot class]];
    
    [slotMapping mapKeyPath:@"id" toAttribute:@"identifier"];
    [slotMapping mapAttributes:@"quarter",
     @"start_time",
     @"end_time", nil];
    
    // mapping for shows
    RKObjectMapping* showMapping = [RKObjectMapping mappingForClass:[Show class] ];
    
    [showMapping mapKeyPath:@"id" toAttribute:@"identifier"];
    [showMapping mapAttributes:@"title",
     @"genres",
     @"short_description",
     @"long_description",
     @"facebook",
     @"twitter",
     @"website",
     @"show_url",
     @"photo_thumb",
     @"photo_small",
     @"photo_medium",
     @"photo_large",
     nil];
    
    // relationship
    [slotMapping mapKeyPath:@"show" toRelationship:@"show" withMapping:showMapping];
    
    // mapping for persons
    RKObjectMapping* personMapping = [RKObjectMapping mappingForClass:[Person class]];
    
    [personMapping mapKeyPath:@"id" toAttribute:@"identifier"];
    [personMapping mapKeyPath:@"name" toAttribute:@"fullName"];
    [personMapping mapAttributes:@"nickname",
     @"bio",
     @"influences",
     @"major",
     @"hometown",
     @"class_year",
     @"facebook",
     @"twitter",
     @"photo_thumb",
     @"photo_small",
     @"photo_medium",
     @"photo_large",
     nil];
    
    [showMapping mapKeyPath:@"hosts" toRelationship:@"hosts" withMapping:personMapping];

    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/api/getSchedule.json?day=" stringByAppendingString:day] usingBlock:^(RKObjectLoader* loader) {
        [loader setObjectMapping:slotMapping];
        loader.delegate = self;
        loader.method = RKRequestMethodGET;
    }];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    self.list = objects;
    [hud hide:true];
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView  reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.list = nil;
    self.childController = nil;
}

#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * DisclosureButtonCellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: DisclosureButtonCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                        reuseIdentifier: DisclosureButtonCellIdentifier];
    }
    [self prepareCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)prepareCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    ScheduleSlot *slot  = [list objectAtIndex:indexPath.row];
    cell.textLabel.text = slot.show.title;
    cell.detailTextLabel.text = slot.start_time;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.imageView setImageWithURL:slot.show.photo_thumb
                   placeholderImage:[UIImage imageNamed:@"placeholder_thumb"]];
}


#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ScheduleSlot *slot = [list objectAtIndex:[indexPath row]];
    childController = [[DisclosureDetailController alloc] initWithScheduleSlot:slot];
    [slot release];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:childController animated:YES];
}

@end