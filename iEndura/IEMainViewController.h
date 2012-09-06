//
//  IEMainViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 28 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

@interface IEMainViewController : IEBaseViewController <IEConnControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSArray *remoteLocations;
}

@property (weak, nonatomic) IBOutlet UITableView *remoteLocationsTableView;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
- (IBAction)goButtonClicked:(UIButton *)sender;

@end
