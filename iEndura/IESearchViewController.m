//
//  IESearchViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 9 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IESearchViewController.h"
#import "DDBadgeViewCell.h"
#import "IECamPlayViewController.h"

@interface IESearchViewController ()

@end

@implementation IESearchViewController
@synthesize camerasSearchBar;
@synthesize camerasListTableView;

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
    return [CamList count];
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
    
    IECameraClass *cc = [CamList objectAtIndex:indexPath.row];
    cell.summary = cc.Name;
    cell.detail = [NSString stringWithFormat:@"%@ - %@", cc.IP, cc.UpnpModelNumber];
    [cell HideBadge:YES];
    cell.imageView.image = [UIImage imageNamed:@"cctv.png"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IECameraClass *cc = [CamList objectAtIndex:indexPath.row];
    IECamPlayViewController *cpvc = [[IECamPlayViewController alloc] init];
    cpvc.CurrentCamera = cc;
    [cpvc.navigationItem setTitle:cc.Name];
    [self.navigationController pushViewController:cpvc animated:YES];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if(searchString.length == 0)
        CamList = [[NSArray alloc] initWithArray:AllCams];
    else
    {
        NSMutableArray *tempCamList = [[NSMutableArray alloc] init];
        for (IECameraClass *cc in AllCams) 
        {
            NSRange rangeValue = [cc.Name rangeOfString:searchString options:NSCaseInsensitiveSearch];
            NSRange rangeValueIP = [cc.IP rangeOfString:searchString options:NSCaseInsensitiveSearch];
            
            if(rangeValue.length > 0 || rangeValueIP.length > 0)
                [tempCamList addObject:cc];
        }
        CamList = [[NSArray alloc] initWithArray:tempCamList];
    }
    [camerasListTableView reloadData];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
    AllCams = [dbOps GetCameraList];
    CamList = [[NSArray alloc] initWithArray:AllCams];
	self.navigationController.navigationBar.tintColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setCamerasSearchBar:nil];
    [self setCamerasListTableView:nil];
    CamList = nil;
    AllCams = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
