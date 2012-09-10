//
//  IESearchViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 9 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

@interface IESearchViewController : IEBaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *CamList;
    NSArray *AllCams;
}

@property (weak, nonatomic) IBOutlet UISearchBar *camerasSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *camerasListTableView;

@end
