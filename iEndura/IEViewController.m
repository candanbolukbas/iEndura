//
//  IEViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 24 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEViewController.h"
#import "IESettingsViewController.h"
#import <CommonCrypto/CommonCryptor.h>

@interface IEViewController ()

@end

@implementation IEViewController
@synthesize editServerButton;
@synthesize changeServer;
@synthesize serverResultLabel, submitButton;
@synthesize userNameTextField, passwordTextField, resultLabel, serviceUrlTextField;

- (void) viewDidLoad 
{
    [self.view setBackgroundColor:[IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_LIGHT_BLUE]];     
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
	if (![IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_ADDRESS_KEY]) 
    {
        [self showServerDefineView];
    }
    else if(![IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_USRPASS_KEY])
    {
        resultLabel.text = [NSString stringWithFormat:@"Enter user cridentials.\nServer: %@\nEnter demo/demo for demo server.", [IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_ADDRESS_KEY]];
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) finishedWithData:(NSData *)data forTag:(iEnduraRequestTypes)tag withObject:(NSObject *)additionalParameters
{
	if (tag == IE_Req_Auth) 
    {
		[self setUserCridentials:data];
	}
	else 
    {
	}
}

- (void) showServerDefineView
{
    UIView *overlayView = [self.view viewWithTag:22];
    [overlayView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6f]];
    [overlayView setAlpha:0.0f];
    [self.view addSubview:overlayView];
    
    [UIView animateWithDuration:1
                     animations:^{
                         [overlayView setAlpha:1.0f];
                     }completion:^(BOOL finished) 
                        {
                         if ([IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_ADDRESS_KEY]) 
                         {
                             [serviceUrlTextField setText:[IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_ADDRESS_KEY]]; 
                         }
                     }];
}

- (void) setUserCridentials:(NSData *)responseData 
{
    NSDictionary *jsDict = [IEHelperMethods getExtractedDataFromJSONItem:responseData];
    SimpleClass *sc = [[SimpleClass alloc] initWithDictionary:jsDict];
    if(sc == nil)
    {
        [self EnableInputFields:YES];
        [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [resultLabel setText:@"Can't connect to server. Please check server name."];
    }
    if ([sc.Id isEqualToString:POZITIVE_VALUE]) 
    {
        NSString *usrPass = [NSString stringWithFormat:@"%@|%@", userNameTextField.text, passwordTextField.text];
        NSString *encStr = [StringEncryption EncryptString:usrPass];
        
        if ([IEHelperMethods setUserDefaultSettingsString:encStr key:IENDURA_SERVER_USRPASS_KEY]) 
        {
            [IEHelperMethods setUserDefaultSettingsString:userNameTextField.text key:IENDURA_USERNAME_KEY];
            [IEHelperMethods setUserDefaultSettingsString:passwordTextField.text key:IENDURA_PASSWORD_KEY];
            APP_DELEGATE.userSeesionId = sc.Value;
            APP_DELEGATE.dbRequiresUpdate = YES;
            [self dismissModalViewControllerAnimated:YES];
        };
    }
    else 
    {
        [self EnableInputFields:YES];
        [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [resultLabel setText:sc.Value];
    }
}

- (void) viewDidUnload {
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setResultLabel:nil];
    [self setServerResultLabel:nil];
    [self setEditServerButton:nil];
    [self setChangeServer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)CheckAuthResult:(NSTimer *)theTimer
{
    if(authTimerCounter == 30)
    {
        [self EnableInputFields:YES];
        [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [resultLabel setText:@"Can't connect to server. Please check server name."];
        [authTimer invalidate];
    }
    else if(![IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_USRPASS_KEY])
    {
        authTimerCounter++;
    }
}

- (void) EnableInputFields:(BOOL)setEnable
{
    [submitButton setEnabled:setEnable];
    [changeServer setEnabled:setEnable];
    [userNameTextField setEnabled:setEnable];
    [passwordTextField setEnabled:setEnable];
}

- (IBAction) submitButtonClicked:(UIButton *)sender {
    [passwordTextField resignFirstResponder];
    [userNameTextField resignFirstResponder];
    [self EnableInputFields:NO];
    [submitButton setTitle:@"Submitting..." forState:UIControlStateDisabled];
    
    NSString *username = userNameTextField.text;
    NSString *password = passwordTextField.text;
    NSURL *authUrl = [IEServiceManager GetAuthenticationUrl:username :password];
	
    authTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CheckAuthResult:) userInfo:nil repeats:YES];
    authTimerCounter = 0;
    
	IEConnController *controller = [[IEConnController alloc] initWithURL:authUrl property:IE_Req_Auth];
	controller.delegate = self;
	[controller startConnection];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == userNameTextField) {
		[textField resignFirstResponder];
		[passwordTextField becomeFirstResponder];
	} 
	else if (textField == passwordTextField) {
		[textField resignFirstResponder];
	}
    else if (textField == serviceUrlTextField) {
        [textField resignFirstResponder];
    }
	return YES;
}

- (IBAction)saveButtonClicked:(UIButton *)sender 
{
    if ([serviceUrlTextField.text length] > 0 && [IEHelperMethods setUserDefaultSettingsString:serviceUrlTextField.text key:IENDURA_SERVER_ADDRESS_KEY]) 
    {
        UIView *overlayView = [self.view viewWithTag:22];
        [userNameTextField becomeFirstResponder];
        [userNameTextField resignFirstResponder];
        
        [UIView animateWithDuration:1
                         animations:^{
                             [overlayView setAlpha:0.0f];
                         }completion:^(BOOL finished) {
                             resultLabel.text = [NSString stringWithFormat:@"Enter user cridentials.\nServer: %@\nEnter demo/demo for demo server.", serviceUrlTextField.text];
                         }];
    }
    else
    {
        serverResultLabel.text = @"Please enter a valid server name.";
    }
}

- (IBAction)editServerButtonClicked:(id)sender 
{
    [self showServerDefineView];
}

- (void) doParse:(NSData *)data {
    //NSLog(@"doParse xmlData: %@",data);
    // create and init our delegate
	NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    IEXMLParser *parser = [[IEXMLParser alloc] initWithData:data];
    BOOL success = [parser.xmlParser parse];
    // set delegate
    
	NSArray *newArray = [[NSArray alloc] initWithArray:parser.scs];
    
    // test the result
    if (success) {
        NSLog(@"No errors - user count : %i\n %@", [parser.scs count], newArray);
        // get array of users here
        //  NSMutableArray *scs = [parser scs];
    } else {
        NSLog(@"Error parsing document!");
    }
    
}

@end






