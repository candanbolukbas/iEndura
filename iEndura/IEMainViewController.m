//
//  IEMainViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 28 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEMainViewController.h"
#import "IEViewController.h"
#import "IERemoteLocations.h"
#import "DDBadgeViewCell.h"

@interface IEMainViewController ()

@end

@implementation IEMainViewController
@synthesize rootLocationsTableView;
@synthesize testLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad 
{
    [super viewDidLoad];
    
    //Add items
    IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
    remoteLocations = [dbOps GetRemoteLocations];
    
    [self.view setBackgroundColor:[IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_LIGHT_BLUE]];
    
    //Set the title
    self.navigationItem.title = @"Countries";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [remoteLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    
    static NSString *CellIdentifier = @"Cell";

    //UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DDBadgeViewCell *cell = (DDBadgeViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DDBadgeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    IERemoteLocations *rl = [remoteLocations objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = rl.RemoteLocationName;
    cell.summary = rl.RemoteLocationName;
    cell.summaryColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
    cell.detail = @"Detail text goes here";
    cell.badgeText = [NSString stringWithFormat:@"%@", rl.NumberOfCameras];
    cell.badgeColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
    cell.badgeHighlightedColor = [UIColor lightGrayColor];
    UIImageView* accessoryViewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_indicator_light.png"]];
    cell.accessoryView = accessoryViewImage;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexRow = indexPath.row;
    
    NSLog(@"%d, %d", indexPath.row, indexPath.section);
    IERemoteLocations *rl = [remoteLocations objectAtIndex:indexRow];
    NSLog(@"%@", rl.RemoteLocationName);
}

- (void) viewDidAppear:(BOOL)animated {
    // Do any additional setup after loading the view from its nib.
    if ([IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_USRPASS_KEY]) {
        testLabel.text = [IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_USRPASS_KEY];
    }
    else {
        testLabel.text = @"No iEndura Server found!";
        IEViewController *iev = [[IEViewController alloc] initWithNibName:@"IEViewController" bundle:nil];
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:iev animated:YES];
    }
}

- (void) viewDidUnload {
    [self setTestLabel:nil];
    [self setRootLocationsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) finishedWithData:(NSData *)data forTag:(iEnduraRequestTypes)tag 
{
	if (tag == IE_Req_Auth) {
		NSLog(@"Ooops!");
	}
	else if (tag == IE_Req_CamList)  
    {
        NSArray *jsArray = [IEHelperMethods getExtractedDataFromJSONArray:data];
        NSMutableArray *pelcoCameras = [[NSMutableArray alloc] init];
        
        for (NSDictionary *jsDict in jsArray) 
        {
            IEPelcoCameraClass *pcc = [[IEPelcoCameraClass alloc] initWithDictionary:jsDict];
            [pelcoCameras addObject:pcc];
        }
        
        IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
        BOOL result = [dbOps InsertBulkPelcoCameras:pelcoCameras :YES];
        NSLog(@"Result: %@", result ? @"YES" : @"NO");
	}
    else {
        NSLog(@"We have a problem!");
    }
}

- (IBAction)goButtonClicked:(UIButton *)sender 
{
    NSString *encStr = APP_DELEGATE.encryptedUsrPassString;
    
    NSURL *camsUrl = [NSURL URLWithString:[NSString stringWithFormat:IENDURA_CAM_LIST_URL_FORMAT, encStr]];
    NSLog(@"%@", camsUrl);
	
	IEConnController *controller = [[IEConnController alloc] initWithURL:camsUrl property:IE_Req_CamList];
	controller.delegate = self;
	[controller startConnection];
}
@end






