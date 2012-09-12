//
//  IESettingsViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 28 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

@interface IESettingsViewController : IEBaseViewController <IEConnControllerDelegate>
{
    NSTimer *authTimer;
    int authTimerCounter;
}

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITextField *serviceUrlTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTestField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIScrollView *settingsScrollView;
@property (weak, nonatomic) IBOutlet UISwitch *autoUpdateSwitch;

- (IBAction)saveButtonClicked:(UIButton *)sender;
- (IBAction)locoutButtonClicked:(id)sender;
- (IBAction)changeAutoDBUpdate:(UISwitch *)sender;

@end
