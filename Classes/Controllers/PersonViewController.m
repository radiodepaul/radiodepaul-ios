//
//  PersonViewController.m
//  Radio DePaul
//
//  Created by Devon Blandin on 11/14/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "PersonViewController.h"
#import "TFParagraphCell.h"
#import "Person.h"
#import "MWPhoto.h"
#import "NSString+NSStringAdditions.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MWPhoto.h"

typedef enum {
    PersonNameIndex,
    PersonHometownIndex,
    PersonMajorIndex,
    PersonFacebookIndex,
    PersonTwitterIndex,
    PersonWebsiteIndex
} PersonStatsIndices;

typedef enum {
    PersonStatsSectionIndex,
    PersonBioSectionIndex,
    PersonInfluencesSectionIndex
} PersonSectionIndices;

@implementation PersonViewController

@synthesize person;

- (id) initWithPerson:(Person *)aPerson
{
    if (![super initWithStyle:UITableViewStyleGrouped])
        return nil;
    
    self.person = aPerson;
    self.title = self.person.fullName;;
    self.hidesBottomBarWhenPushed = true;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           self.view.bounds.size.width,
                                                                           self.view.bounds.size.width)];
    
    self.tableView.tableHeaderView = imageView;
    
    if ([self hasRetinaDisplay])
    {
        [(id)self.tableView.tableHeaderView setImageWithURL: person.photo_medium
                                           placeholderImage:[UIImage imageNamed:@"placeholder_medium"]];
    }
    else
    {
        [(id)self.tableView.tableHeaderView setImageWithURL:person.photo_small
                                           placeholderImage:[UIImage imageNamed:@"placeholder_small"]];
    }
    
    
    [self.tableView.tableHeaderView.layer setBorderWidth:5.0f];
    [self.tableView.tableHeaderView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.tableView.tableHeaderView.layer setShadowRadius:5.0f];
    [self.tableView.tableHeaderView.layer setShadowOpacity:.85f];
    [self.tableView.tableHeaderView.layer setShadowOffset:CGSizeMake(1.0f, 2.0f)];
    [self.tableView.tableHeaderView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.tableView.tableHeaderView.layer setShouldRasterize:YES];
    [self.tableView.tableHeaderView.layer setMasksToBounds:NO];
    
    self.tableView.tableHeaderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [imageView release];
    
    
	// Do any additional setup after loading the view.
}

-(BOOL) hasRetinaDisplay
{
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        return [[UIScreen mainScreen] scale] == 2.0 ? YES : NO;
    return NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return 6;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *ParagraphCellIdentifier = @"TFParagraphCell";
    
    if (indexPath.section == PersonBioSectionIndex || indexPath.section == PersonInfluencesSectionIndex) {
        TFParagraphCell *cell = (TFParagraphCell *)[tableView dequeueReusableCellWithIdentifier:ParagraphCellIdentifier];
        if (cell == nil)
            cell = [TFParagraphCell cellWithReuseIdentifier:ParagraphCellIdentifier];
        
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
        case PersonStatsSectionIndex:
            switch (indexPath.row) {
                case PersonNameIndex:
                    cell.textLabel.text = @"Name";
                    cell.detailTextLabel.text = person.fullName;
                    break;
                case PersonHometownIndex:
                    cell.textLabel.text = @"Hometown";
                    cell.detailTextLabel.text = person.hometown;
                    break;
                case PersonMajorIndex:
                    cell.textLabel.text = @"Major";
                    cell.detailTextLabel.text = person.major;
                    break;
                case PersonFacebookIndex:
                    cell.textLabel.text = @"Facebook";
                    cell.detailTextLabel.text = person.facebook;
                    break;
                case PersonTwitterIndex:
                    cell.textLabel.text = @"Twitter";
                    cell.detailTextLabel.text = person.twitter;
                    break;
                case PersonWebsiteIndex:
                    cell.textLabel.text = @"Website";
                    cell.detailTextLabel.text = person.website;
                    break;
            }
            break;
        case PersonBioSectionIndex:
            cell.detailTextLabel.text = person.bio;
            break;
        case PersonInfluencesSectionIndex:
            cell.detailTextLabel.text = person.influences;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == PersonBioSectionIndex)
        return @"Bio";
    else if (section == PersonInfluencesSectionIndex)
        return @"Influences";
    
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == PersonBioSectionIndex) {
        return [TFParagraphCell heightForCellInTable:tableView
                                            withText:person.bio];
    }
    else if (indexPath.section == PersonInfluencesSectionIndex) {
        return [TFParagraphCell heightForCellInTable:tableView
                                            withText:person.influences];
    }
    
    return 44.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
