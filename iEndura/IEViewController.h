//
//  IEViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 24 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IEViewController : UIViewController {
	NSMutableData *enduraData;
}

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;


- (IBAction)submitButtonClicked:(UIButton *)sender;
- (BOOL) textFieldShouldReturn:(UITextField *)textField;

@end
