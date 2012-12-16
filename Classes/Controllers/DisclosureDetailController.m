//
//  DisclosureDetailController.m
//  Nav
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "DisclosureDetailController.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MWPhoto.h"
#import "TFParagraphCell.h"
#import "PersonViewController.h"


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


@interface DisclosureDetailController ()
{
    MWPhotoBrowser *browser;
}

@end

@implementation DisclosureDetailController
@synthesize slot;

- (id)initWithScheduleSlot:(ScheduleSlot *) scheduleSlot
{
    if (![super initWithStyle:UITableViewStyleGrouped])
        return nil;
    
    self.slot = scheduleSlot;
    self.title = self.slot.show.title;
    self.hidesBottomBarWhenPushed = true;
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8 + [slot.show.hosts count];
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
    
    if (indexPath.row >= 8) {
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
    switch (indexPath.row)
    {
        case ScheduleSlotDetailTitleIndex:
            cell.textLabel.text = @"Title";
            cell.detailTextLabel.text = slot.show.title;
            break;
        case ScheduleSlotDetailGenresIndex:
            cell.textLabel.text = @"Genres";
            cell.detailTextLabel.text = slot.show.genres;
            break;
        case ScheduleSlotDetailStartTimeIndex:
            cell.textLabel.text = @"Start Time";
            cell.detailTextLabel.text = slot.start_time;
            break;
        case ScheduleSlotDetailEndTimeIndex:
            cell.textLabel.text = @"End Time";
            cell.detailTextLabel.text = slot.end_time;
            break;
        case ScheduleSlotDetailDescriptionIndex:
            cell.detailTextLabel.text = slot.show.long_description;
            break;
        case ScheduleSlotDetailFacebookIndex:
            cell.textLabel.text = @"Facebook";
            cell.detailTextLabel.text = slot.show.facebook;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case ScheduleSlotDetailTwitterIndex:
            cell.textLabel.text = @"Twitter";
            cell.detailTextLabel.text = slot.show.twitter;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case ScheduleSlotDetailWebsiteIndex:
            cell.textLabel.text = @"Website";
            cell.detailTextLabel.text = slot.show.website;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            cell.textLabel.text = [[slot.show.hosts objectAtIndex:indexPath.row - 8] fullName];
            cell.detailTextLabel.text = [[slot.show.hosts objectAtIndex:indexPath.row - 8] bio];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.imageView setImageWithURL:[[slot.show.hosts objectAtIndex:indexPath.row - 8] photo_thumb]
                           placeholderImage:[UIImage imageNamed:@"placeholder_thumb"]];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ScheduleSlotDetailDescriptionIndex) {
        return [TFParagraphCell heightForCellInTable:tableView
                                            withText:slot.show.long_description];
    }
    
    return 44.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           self.view.bounds.size.width,
                                                                           self.view.bounds.size.width)];
    
    self.tableView.tableHeaderView = imageView;
    
    self.photos = [[NSArray alloc] initWithObjects:[MWPhoto photoWithURL:slot.show.photo_large], nil];
    if (hasRetinaDisplay)
    {
     [(id)self.tableView.tableHeaderView setImageWithURL: self.slot.show.photo_medium
               placeholderImage:[UIImage imageNamed:@"placeholder_large"]];
    }
    else
    {
     [(id)self.tableView.tableHeaderView setImageWithURL:self.slot.show.photo_medium
               placeholderImage:[UIImage imageNamed:@"placeholder_medium"]];
    }


    [self.tableView.tableHeaderView.layer setBorderWidth:5.0f];
    [self.tableView.tableHeaderView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.tableView.tableHeaderView.layer setShadowRadius:5.0f];
    [self.tableView.tableHeaderView.layer setShadowOpacity:.85f];
    [self.tableView.tableHeaderView.layer setShadowOffset:CGSizeMake(1.0f, 2.0f)];
    [self.tableView.tableHeaderView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.tableView.tableHeaderView.layer setShouldRasterize:YES];
    [self.tableView.tableHeaderView.layer setMasksToBounds:NO];

    browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    self.tableView.tableHeaderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [imageView release];

    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

BOOL hasRetinaDisplay(void)
{
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        return [[UIScreen mainScreen] scale] == 2.0 ? YES : NO;
    return NO;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (IBAction)showImageBrowser:(UIButton *)sender {
    browser.wantsFullScreenLayout = YES;
    browser.displayActionButton   = YES;
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row >= 8)
    {
        Person *person = [slot.show.hosts objectAtIndex:indexPath.row - 8];
        PersonViewController *child = [[PersonViewController alloc] initWithPerson:person];
        [self.navigationController pushViewController:child animated:YES];
    }
}
@end
