//
//  IECamListViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 1 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IECamListViewController.h"
#import "DDBadgeViewCell.h"
#import "IECamPlayViewController.h"

@interface IECamListViewController ()

@end

@implementation IECamListViewController

@synthesize CurrentCameraLocation;

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
    return [LocAndCamList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    
    static NSString *CellIdentifier = @"Cell";
    
    // Set up the cell...
    DDBadgeViewCell *cell = (DDBadgeViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[DDBadgeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.summaryColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSObject *LocOrCam = [LocAndCamList objectAtIndex:indexPath.row];
    
    if([LocOrCam isKindOfClass:[IECameraClass class]])
    {
        IECameraClass *cc = [LocAndCamList objectAtIndex:indexPath.row];
        cell.summary = cc.Name;
        cell.detail = [NSString stringWithFormat:@"%@ - %@", cc.IP, cc.UpnpModelNumber];
        [cell HideBadge:YES];
        cell.imageView.image = [UIImage imageNamed:@"iendura_tab_icon.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if([LocOrCam isKindOfClass:[IECameraLocation class]])
    {
        IECameraLocation *cl = [LocAndCamList objectAtIndex:indexPath.row];
        
        if(CurrentCameraLocation.LocationType == IE_Cam_Loc_Remote)
        {
            cell.summary = cl.LocationRoot;
            cell.detail = @"Detail text goes here";
        }
        else if(CurrentCameraLocation.LocationType == IE_Cam_Loc_Root)
        {
            cell.summary = cl.LocationChild;
            cell.detail = @"Detail text goes here";
        }
        cell.badgeText = cl.NumberOfCameras;
        cell.badgeColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
        cell.badgeHighlightedColor = [UIColor lightGrayColor];
        
        //UIImageView* accessoryViewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_indicator_light.png"]];
        //cell.accessoryView = accessoryViewImage;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"iendura_tab_icon.png"];
    }
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
    NSObject *LocOrCam = [LocAndCamList objectAtIndex:indexPath.row];
    
    if([LocOrCam isKindOfClass:[IECameraClass class]])
    {
        IECameraClass *cc = [LocAndCamList objectAtIndex:indexPath.row];
        IECamPlayViewController *cpvc = [[IECamPlayViewController alloc] init];
        cpvc.CurrentCamera = cc;
        [cpvc.navigationItem setTitle:cc.Name];
        [self.navigationController pushViewController:cpvc animated:YES];
    }
    else if([LocOrCam isKindOfClass:[IECameraLocation class]])
    {
        IECameraLocation *rl = [LocAndCamList objectAtIndex:indexPath.row];
        IECamListViewController *clvc = [[IECamListViewController alloc] init];
        IECameraLocation *cl = [[IECameraLocation alloc] init];
        cl.RemoteLocation = CurrentCameraLocation.RemoteLocation;
        if(CurrentCameraLocation.LocationType == IE_Cam_Loc_Remote)
        {
            cl.LocationRoot = rl.LocationRoot;
            cl.LocationType = IE_Cam_Loc_Root;
            [clvc.navigationItem setTitle:cl.LocationRoot];
        }
        else if(CurrentCameraLocation.LocationType == IE_Cam_Loc_Root)
        {
            cl.LocationRoot = rl.LocationRoot;
            cl.LocationChild = rl.LocationChild;
            cl.LocationType = IE_Cam_Loc_Child;
            [clvc.navigationItem setTitle:cl.LocationChild];
        }
        clvc.CurrentCameraLocation = cl;
        [self.navigationController pushViewController:clvc animated:YES];
    }
}

- (void) finishedWithData:(NSData *)data forTag:(iEnduraRequestTypes)tag 
{
	if (tag == IE_Req_Auth) {
		NSLog(@"Ooops!");
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
        NSLog(@"Result: %@", result ? @"YES" : @"NO");
	}
    else {
        NSLog(@"We have a problem!");
    }
}

- (void) viewDidUnload 
{
    [self setCurrentCameraLocation:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Add items
    IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
    LocAndCamList = [dbOps GetItemsOfALocation:CurrentCameraLocation];
	self.navigationController.navigationBar.tintColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    CGRect theFrame = [self.view frame];
//    theFrame.origin.y = -290;
//    [self.view setNeedsDisplay];
//}

-(void)viewWillAppear:(BOOL)animated 
{ 
    //self.view.frame = CGRectMake(50, -290, 320, 200);
    CGRect theFrame = [self.view frame];
    theFrame.origin.y = -290;
    [super viewWillAppear:animated]; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

@end
