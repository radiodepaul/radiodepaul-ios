//
//  NewsViewController.m
//  Radio DePaul
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "ListenViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "TFParagraphCell.h"
#import "Person.h"
#import "PersonViewController.h"
#import "SVPullToRefresh.h"
#import "AppDelegate.h"


typedef enum {
    ScheduleSlotDetailTitleIndex,
    ScheduleSlotDetailGenresIndex,
    ScheduleSlotDetailStartTimeIndex,
    ScheduleSlotDetailEndTimeIndex,
    ScheduleSlotDetailDescriptionIndex,
    ScheduleSlotDetailWebsiteIndex,
    ScheduleSlotDetailFacebookIndex,
    ScheduleSlotDetailTwitterIndex,
} ScheduleSlotDetailIndices;

typedef enum {
    ScheduleSlotStats,
    ScheduleSlotShowHosts
} SectionIndices;

@implementation ListenViewController
@synthesize onAirSlot;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    [super initWithCoder:aDecoder];
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    return self;
}

- (void) setupUI
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern"]]];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"On Air Now";
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Now Playing" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonTouchUpInside:)];
    self.navigationItem.rightBarButtonItem = btnCancel;
    
    
    [self loadOnAirNow];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self loadOnAirNow];
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
    }];
    
}

- (IBAction) buttonTouchUpInside:(id)sender {
    NSLog(@"Media Player");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [self.navigationController pushViewController:appDelegate.beamViewController animated:YES];
    //do as you please with buttonClicked.argOne
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    
//    CGRect navigationControllerFrame = self.view.bounds;
//    navigationControllerFrame.size.height -= 50;
//    self.view.frame = navigationControllerFrame;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == ScheduleSlotStats)
        return 8;
    else if (section == ScheduleSlotShowHosts)
        [onAirSlot.show.hosts count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellPhotoIdentifier = @"CellPhoto";
    static NSString *ParagraphCellIdentifier = @"TFParagraphCell";
    
    if (indexPath.row == ScheduleSlotDetailDescriptionIndex) {
        TFParagraphCell *cell = (TFParagraphCell *)[tableView dequeueReusableCellWithIdentifier:ParagraphCellIdentifier];
        if (cell == nil)
            cell = [TFParagraphCell cellWithReuseIdentifier:ParagraphCellIdentifier];
        
        [self prepareCell:cell forIndexPath:indexPath];
        return cell;
    }
    
    if (indexPath.section == ScheduleSlotShowHosts) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellPhotoIdentifier];
        if (cell == nil)
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:CellPhotoIdentifier] autorelease];
        
        [self prepareCell:cell forIndexPath:indexPath];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                       reuseIdentifier:CellIdentifier] autorelease];
    
    [self prepareCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)prepareCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case ScheduleSlotStats:
            switch (indexPath.row)
            {
                case ScheduleSlotDetailTitleIndex:
                    cell.textLabel.text = @"Title";
                    cell.detailTextLabel.text = onAirSlot.show.title;
                    break;
                case ScheduleSlotDetailGenresIndex:
                    cell.textLabel.text = @"Genres";
                    cell.detailTextLabel.text = onAirSlot.show.genres;
                    break;
                case ScheduleSlotDetailStartTimeIndex:
                    cell.textLabel.text = @"Start Time";
                    cell.detailTextLabel.text = onAirSlot.start_time;
                    break;
                case ScheduleSlotDetailEndTimeIndex:
                    cell.textLabel.text = @"End Time";
                    cell.detailTextLabel.text = onAirSlot.end_time;
                    break;
                case ScheduleSlotDetailDescriptionIndex:
                    cell.detailTextLabel.text = onAirSlot.show.long_description;
                    break;
                case ScheduleSlotDetailFacebookIndex:
                    cell.textLabel.text = @"Facebook";
                    cell.detailTextLabel.text = onAirSlot.show.facebook;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case ScheduleSlotDetailTwitterIndex:
                    cell.textLabel.text = @"Twitter";
                    cell.detailTextLabel.text = onAirSlot.show.twitter;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case ScheduleSlotDetailWebsiteIndex:
                    cell.textLabel.text = @"Website";
                    cell.detailTextLabel.text = onAirSlot.show.website;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
            }
            break;
        case ScheduleSlotShowHosts:
            cell.textLabel.text = [[onAirSlot.show.hosts objectAtIndex:indexPath.row] fullName];
            cell.detailTextLabel.text = [[onAirSlot.show.hosts objectAtIndex:indexPath.row] bio];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.imageView setImageWithURL:[[onAirSlot.show.hosts objectAtIndex:indexPath.row] photo_thumb]
                           placeholderImage:[UIImage imageNamed:@"placeholder_thumb"]];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ScheduleSlotDetailDescriptionIndex) {
        return [TFParagraphCell heightForCellInTable:tableView
                                            withText:onAirSlot.show.long_description];
    }
    
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == ScheduleSlotShowHosts)
        return @"Hosts";
    
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row >= 8)
    {
        //Person *person = [onAirSlot.show.hosts objectAtIndex:indexPath.row - 8];
        //PersonViewController *child = [[PersonViewController alloc] initWithPerson:person];
        //[self.navigationController pushViewController:child animated:YES];
    }
}

- (void)loadOnAirNow {
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
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/getOnAir.json" usingBlock:^(RKObjectLoader* loader) {
        [loader setObjectMapping:slotMapping];
        loader.delegate = self;
        loader.method = RKRequestMethodGET;
    }];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    self.onAirSlot = [objects objectAtIndex:0];
    
    [hud hide:true];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           self.view.bounds.size.width,
                                                                           self.view.bounds.size.width)];

    self.tableView.tableHeaderView = imageView;
    
    self.photos = [[NSArray alloc] initWithObjects:[MWPhoto photoWithURL:onAirSlot.show.photo_large], nil];
    
    [(id)self.tableView.tableHeaderView setImageWithURL: onAirSlot.show.photo_medium
                                   placeholderImage:[UIImage imageNamed:@"placeholder_medium"]];
    
    [self.tableView.tableHeaderView.layer setBorderWidth:5.0f];
    [self.tableView.tableHeaderView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.tableView.tableHeaderView.layer setShadowRadius:5.0f];
    [self.tableView.tableHeaderView.layer setShadowOpacity:.85f];
    [self.tableView.tableHeaderView.layer setShadowOffset:CGSizeMake(1.0f, 2.0f)];
    [self.tableView.tableHeaderView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.tableView.tableHeaderView.layer setShouldRasterize:YES];
    [self.tableView.tableHeaderView.layer setMasksToBounds:NO];
    
    //browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    self.tableView.tableHeaderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [imageView release];
    [self.tableView  reloadData];
    
    [self.tableView.pullToRefreshView stopAnimating];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}



-(bool) hasRetinaDisplay
{
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        return [[UIScreen mainScreen] scale] == 2.0 ? YES : NO;
    return NO;
}


@end
