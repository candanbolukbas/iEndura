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
#import "IECamListViewController.h"

@interface IEMainViewController ()

@end

@implementation IEMainViewController
@synthesize remoteLocationsTableView;
@synthesize updateRsultLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [remoteLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    
    static NSString *CellIdentifier = @"Cell";
    
    DDBadgeViewCell *cell = (DDBadgeViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DDBadgeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    IERemoteLocations *rl = [remoteLocations objectAtIndex:indexPath.row];
    
    cell.summary = rl.RemoteLocationName;
    cell.summaryColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
    cell.detail = @"Detail text goes here";
    cell.badgeText = [NSString stringWithFormat:@"%@", rl.NumberOfCameras];
    cell.badgeColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
    cell.badgeHighlightedColor = [UIColor lightGrayColor];
    cell.imageView.image = [UIImage imageNamed:@"remote_icon.png"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source.
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }   
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexRow = indexPath.row;
    IERemoteLocations *rl = [remoteLocations objectAtIndex:indexRow];
    
    IECameraLocation *cl = [[IECameraLocation alloc] init];
    cl.RemoteLocation = rl.RemoteLocationName;
    cl.LocationType = IE_Cam_Loc_Remote;
    if(rl.RemoteLocationName == FAVORITE_CAMERAS_TITLE)
        cl.LocationType = IE_Cam_Loc_Fav;
    
    IECamListViewController *clvc = [[IECamListViewController alloc] initWithNibName:@"IECamListViewController" bundle:[NSBundle mainBundle]];
    [clvc.navigationItem setTitle:cl.RemoteLocation];
    clvc.CurrentCameraLocation = cl;

	[self.navigationController pushViewController:clvc animated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    // Do any additional setup after loading the view from its nib.
    if (![IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_USRPASS_KEY]) 
    {
        IEViewController *iev = [[IEViewController alloc] initWithNibName:@"IEViewController" bundle:nil];
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:iev animated:YES];
    }
    
    if(APP_DELEGATE.dbRequiresUpdate)
    {
        [self UpdateCameraList:YES];
        APP_DELEGATE.dbRequiresUpdate = NO;
    }
    
    IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
    remoteLocations = [dbOps GetRemoteLocations];
    [remoteLocationsTableView reloadData];
}

- (void) viewDidLoad 
{
    [super viewDidLoad];
    timeOutCamList = 60;
    if ([IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_USRPASS_KEY]) 
    {
        if([APP_DELEGATE.userSeesionId isEqualToString:@""])
        {
            NSURL *authUrl = [IEServiceManager GetAuthenticationUrlFromUsrPass];
            [self showUpdateDatabaseView];
            IEConnController *controller = [[IEConnController alloc] initWithURL:authUrl property:IE_Req_Auth];
            controller.delegate = self;
            [controller startConnection];
        }
    }
    
    self.navigationItem.title = @"iEndura";
	self.navigationController.navigationBar.tintColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
	UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(UpdateCameraList:)];
	self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void) viewDidUnload 
{
    [self setRemoteLocationsTableView:nil];
    remoteLocations = nil;
    [self setUpdateRsultLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        UIView *overlayView = [self.view viewWithTag:105];
        overlayView.frame = CGRectMake(0, 0, 480, 320);
    }
    else 
    {
        UIView *overlayView = [self.view viewWithTag:105];
        overlayView.frame = CGRectMake(0, 0, 320, 480);
    }
    return YES;
}

- (void) finishedWithData:(NSData *)data forTag:(iEnduraRequestTypes)tag 
{
	if (tag == IE_Req_Auth) 
    {
		[self setUserSessionId:data];
	}
	else if (tag == IE_Req_CamList)  
    {
        NSArray *jsArray = [IEHelperMethods getExtractedDataFromJSONArray:data];
        NSMutableArray *Cameras = [[NSMutableArray alloc] init];
        
        for (NSDictionary *jsDict in jsArray) 
        {
            IECameraClass *cc = [[IECameraClass alloc] initWithDictionary:jsDict];
            [Cameras addObject:cc];
        }
        
        IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
        BOOL result = [dbOps InsertBulkCameras:Cameras :YES];
        if(result)
        {
            IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
            remoteLocations = [dbOps GetRemoteLocations];
            [remoteLocationsTableView reloadData];
            [self hideUpdateDatabaseView];
        }
        else 
        {
            NSLog(@"Result: %@", result ? @"YES" : @"NO");
        }
	}
    else {
        NSLog(@"We have a problem!");
    }
}

- (void) setUserSessionId:(NSData *)responseData 
{
    NSDictionary *jsDict = [IEHelperMethods getExtractedDataFromJSONItem:responseData];
    SimpleClass *sc = [[SimpleClass alloc] initWithDictionary:jsDict];
    if ([sc.Id isEqualToString:POZITIVE_VALUE]) 
    {
        APP_DELEGATE.userSeesionId = sc.Value;
        [self UpdateCameraList:NO];
    }
}

- (void) showUpdateDatabaseView
{
    camListTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CheckCamListResult:) userInfo:nil repeats:YES];
    camListConnectionCounter = 0;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [updateRsultLabel setText:@"Updating..."];
    UIView *overlayView = [self.view viewWithTag:105];
    [overlayView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3f]];
    [overlayView setAlpha:0.0f];
    [self.view addSubview:overlayView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [overlayView setAlpha:1.0f];
                     }];
}

- (void) hideUpdateDatabaseView
{
    UIView *overlayView = [self.view viewWithTag:105];
    
    [UIView animateWithDuration:(camListConnectionCounter == timeOutCamList ? 5 : 1)
                     animations:^{
                         [overlayView setAlpha:0.0f];
                     }];
    [camListTimer invalidate];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void)CheckCamListResult:(NSTimer *)theTimer
{
    if(camListConnectionCounter == timeOutCamList)
    {
        [updateRsultLabel setText:@"Can't connect to server."];
        [self hideUpdateDatabaseView];
    }
    else
    {
        camListConnectionCounter++;
    }
}

- (void)UpdateCameraList:(BOOL)showProgress
{   
    NSURL *camsUrl = [IEServiceManager GetCamListUrl];
	IEConnController *controller = [[IEConnController alloc] initWithURL:camsUrl property:IE_Req_CamList];
	controller.delegate = self;
	[controller startConnection];
    if(showProgress)
        [self showUpdateDatabaseView];
}

@end






