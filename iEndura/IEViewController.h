//
//  IEViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 24 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEConnController.h"

@interface IEViewController : UIViewController <IEConnControllerDelegate>
{
    NSTimer *authTimer;
    int authTimerCounter;
}

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverResultLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *editServerButton;
@property (weak, nonatomic) IBOutlet UIButton *changeServer;

- (IBAction)submitButtonClicked:(UIButton *)sender;
- (BOOL) textFieldShouldReturn:(UITextField *)textField;

@property (weak, nonatomic) IBOutlet UITextField *serviceUrlTextField;
- (IBAction)saveButtonClicked:(UIButton *)sender;
- (IBAction)editServerButtonClicked:(id)sender;

@end
