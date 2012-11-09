#import "DisclosureButtonController.h"
#import "AppDelegate.h"
#import "DisclosureDetailController.h"
#import "ShowTableViewCell.h"


@interface DisclosureButtonController () {
    MBProgressHUD *hud;
}
@property (strong, nonatomic) DisclosureDetailController *childController;
@end

@implementation DisclosureButtonController

@synthesize list;
@synthesize childController;
@synthesize day;

- (void)viewDidLoad {
    [super viewDidLoad];
    [TestFlight passCheckpoint:@"Visited Schedule Day View"];
    // Create the request.
    

}

- (void) viewWillAppear:(BOOL)animated
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    NSString *url = [[[NSString alloc] initWithString:@"http://radiodepaul.herokuapp.com/api/getSchedule.json?day="] stringByAppendingString:self.day];
    
    
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [[NSMutableData data] retain];
    } else {
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    [self displayShowData];
    // release the connection, and the data object
    [connection release];
    [receivedData release];

}


- (void) displayShowData
{
    NSError *e = nil;
    NSMutableArray *shows = [[NSMutableArray alloc] init];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: receivedData options: NSJSONReadingMutableContainers error: &e];
    
    for(NSDictionary *slot in jsonArray) {
        [shows addObject:slot];
    }
    self.list = shows;
    
    [self.tableView reloadData];
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
    
    static NSString * DisclosureButtonCellIdentifier = @"ShowCellIdentifier";
    
    ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             DisclosureButtonCellIdentifier];
    if (cell == nil) {
        cell = [[ShowTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: DisclosureButtonCellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *show = [[list objectAtIndex:row] objectForKey:@"show"];
    cell.textLabel.text = [show objectForKey:@"title"];
    
    [cell setShowPhoto:[show objectForKey:@"photo_thumb"]];
    
    return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (childController == nil) {
        childController = [[DisclosureDetailController alloc]
                           initWithNibName:@"DisclosureDetail" bundle:nil];
    }
    
    childController.slot = [list objectAtIndex:[indexPath row]];
    childController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:childController
                                         animated:YES];
}

- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

}

@end