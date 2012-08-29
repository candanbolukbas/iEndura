//
//  IESettingsViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 28 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IESettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *serviceUrlTextField;
- (IBAction)saveButtonClicked:(UIButton *)sender;

@end
