//
//  IECamListViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 1 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

@interface IECamListViewController : IEBaseViewController <IEConnControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IECameraLocation *CurrentCameraLocation;
    NSArray *LocAndCamList;
}

@property (nonatomic,retain) IECameraLocation *CurrentCameraLocation;
- (IBAction)goButtonClicked:(UIButton *)sender;

@end
