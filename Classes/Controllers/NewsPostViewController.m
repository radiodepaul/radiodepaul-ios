//
//  NewsPostViewController.m
//  Radio DePaul
//
//  Created by Devon Blandin on 11/14/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "NewsPostViewController.h"
#import "TFParagraphCell.h"
#import "NewsPost.h"
#import "NSString+NSStringAdditions.h"

typedef enum {
    NewsPostHeadlineIndex,
    NewsPostContentIndex,
    NewsPostPublishedAtIndex
} NewsPostIndices;

@implementation NewsPostViewController

@synthesize newsPost;

- (id) initWithNewsPost:(NewsPost *) aNewsPost
{
    if (![super initWithStyle:UITableViewStyleGrouped])
        return nil;
    
    NSLog(@"creating news post");
    
    self.newsPost = aNewsPost;
    self.title = self.newsPost.headline;;
    self.hidesBottomBarWhenPushed = true;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *ParagraphCellIdentifier = @"TFParagraphCell";
    
    if (indexPath.row == NewsPostContentIndex) {
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
    switch (indexPath.row)
    {
        case NewsPostHeadlineIndex:
            cell.textLabel.text = @"Headline";
            cell.detailTextLabel.text = newsPost.headline;
            break;
        case NewsPostPublishedAtIndex:
            cell.textLabel.text = @"Published On";
            cell.detailTextLabel.text = newsPost.published_at;
            break;
        case NewsPostContentIndex:
            cell.detailTextLabel.text = [newsPost.content stringByStrippingHTML];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == NewsPostContentIndex) {
        return [TFParagraphCell heightForCellInTable:tableView
                                            withText:[newsPost.content stringByStrippingHTML]];
    }
    
    return 44.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
