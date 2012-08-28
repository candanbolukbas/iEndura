//
//  IEViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 24 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEConnController.h"

@interface IEViewController : UIViewController <IEConnControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;


- (IBAction)submitButtonClicked:(UIButton *)sender;
- (BOOL) textFieldShouldReturn:(UITextField *)textField;

@end
