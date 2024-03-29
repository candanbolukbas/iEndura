//
//  IECamListViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 1 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

@interface IECamListViewController : IEBaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    IECameraLocation *CurrentCameraLocation;
    NSArray *LocAndCamList;
}

@property (weak, nonatomic) IBOutlet UITableView *camListTableView;
@property (nonatomic,retain) IECameraLocation *CurrentCameraLocation;

@end
