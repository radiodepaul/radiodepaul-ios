//
//  NewsViewController.m
//  Radio DePaul
//
//  Created by Devon Blandin on 11/5/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "NewsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "../Models/NewsPost.h"
#import "NSString+NSStringAdditions.h"
#import "NewsPostViewController.h"
#import "SVPullToRefresh.h"

@interface NewsViewController () {
    MBProgressHUD *hud;
}
@end

@implementation NewsViewController
@synthesize newsPosts;
@synthesize childController;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"initWithCoder");
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    return self;
}

- (void)loadNewsPosts {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    // mapping for slots
    RKObjectMapping *newsPostMapping = [RKObjectMapping mappingForClass:[NewsPost class]];
    
    [newsPostMapping mapKeyPath:@"id" toAttribute:@"identifier"];
    [newsPostMapping mapAttributes:@"headline",
                                   @"snippet",
                                   @"content",
                                   @"published_at", nil];

    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/news_posts/getList.json" usingBlock:^(RKObjectLoader* loader) {
        [loader setObjectMapping:newsPostMapping];
        loader.delegate = self;
        loader.method = RKRequestMethodGET;
    }];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    self.newsPosts = objects;
    [self.tableView.pullToRefreshView stopAnimating];
    [hud hide:true];
    [self.tableView  reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.newsPosts == nil)
        [self loadNewsPosts];
    
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"News";
    
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self loadNewsPosts];
    }];
    // Do any additional setup after loading the view from its nib.
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
    
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newsPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * NewsPostCellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NewsPostCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                      reuseIdentifier: NewsPostCellIdentifier];
    }
    [self prepareCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)prepareCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NewsPost *newsPost  = [newsPosts objectAtIndex:indexPath.row];
    cell.textLabel.text = newsPost.headline;
    cell.detailTextLabel.text = [newsPost.content stringByStrippingHTML];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}
#pragma mark Table Delegate Methods
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsPost *newsPost = [newsPosts objectAtIndex:indexPath.row];
    NewsPostViewController *child = [[NewsPostViewController alloc] initWithNewsPost:newsPost];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:child animated:YES];
}

// Setting the image of the tab.
- (NSString *)tabImageName
{
    return @"news.png";
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return @"News";
}
    
@end