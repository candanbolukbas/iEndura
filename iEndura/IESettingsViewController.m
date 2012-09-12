//
//  IESettingsViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 28 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IESettingsViewController.h"
#import "IEMainViewController.h"

@interface IESettingsViewController ()

@end

@implementation IESettingsViewController
@synthesize settingsScrollView;
@synthesize autoUpdateSwitch;
@synthesize logoutButton;
@synthesize serviceUrlTextField;
@synthesize userNameTextField;
@synthesize passwordTestField;
@synthesize resultLabel;
@synthesize saveButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    serviceUrlTextField.text = [IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_ADDRESS_KEY];
    userNameTextField.text = [IEHelperMethods getUserDefaultSettingsString:IENDURA_USERNAME_KEY];
    passwordTestField.text = [IEHelperMethods getUserDefaultSettingsString:IENDURA_PASSWORD_KEY];
    NSString *autoUpdate = [IEHelperMethods getUserDefaultSettingsString:AUTO_UPDATE_CAMERA_DB_KEY];
    
    if([autoUpdate isEqualToString:POZITIVE_VALUE])
    {
        [autoUpdateSwitch setOn:YES];
    }
    else {
        [autoUpdateSwitch setOn:NO];
    }
    
	self.navigationController.navigationBar.tintColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
    //CrudOp *dbCrud = [[CrudOp alloc] init];
    //[dbCrud CopyDbToDocumentsFolder];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setServiceUrlTextField:nil];
    [self setResultLabel:nil];
    [self setSettingsScrollView:nil];
    [self setUserNameTextField:nil];
    [self setPasswordTestField:nil];
    [self setSaveButton:nil];
    [self setLogoutButton:nil];
    [self setAutoUpdateSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        settingsScrollView.contentSize = CGSizeMake(320, 380);
    }
    else 
    {
        settingsScrollView.contentSize = CGSizeMake(480, 380);
    }
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == userNameTextField) {
		[textField resignFirstResponder];
		[passwordTestField becomeFirstResponder];
	} 
	else if (textField == passwordTestField) {
		[textField resignFirstResponder];
	}
    else if (textField == serviceUrlTextField) {
        [textField resignFirstResponder];
    }
	return YES;
}

- (void)DisableFields:(BOOL)setValue
{
    [saveButton setEnabled:setValue];
    [passwordTestField setEnabled:setValue];
    [userNameTextField setEnabled:setValue];
    [logoutButton setEnabled:setValue];
}

- (IBAction)saveButtonClicked:(UIButton *)sender 
{
    [passwordTestField resignFirstResponder];
    if (serviceUrlTextField.text.length > 0 && userNameTextField.text.length > 0 && passwordTestField.text.length > 0) 
    {
        [IEHelperMethods setUserDefaultSettingsString:serviceUrlTextField.text key:IENDURA_SERVER_ADDRESS_KEY];
        
        NSString *usrPass = [NSString stringWithFormat:@"%@|%@", userNameTextField.text, passwordTestField.text];
        NSString *encStr = [StringEncryption EncryptString:usrPass];
        
        [self DisableFields:NO];
    
        authTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CheckAuthResult:) userInfo:nil repeats:YES];
        authTimerCounter = 0;
        [saveButton setTitle:@"Submitting..." forState:UIControlStateDisabled];
        NSURL *authUrl = [IEServiceManager GetAuthenticationUrlFromEncStr:encStr];
        IEConnController *controller = [[IEConnController alloc] initWithURL:authUrl property:IE_Req_Auth];
        controller.delegate = self;
        [controller startConnection];
    };
}

- (void)CheckAuthResult:(NSTimer *)theTimer
{
    if(authTimerCounter == 30)
    {
        [self DisableFields:YES];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [resultLabel setText:@"Can't connect to server. Please check server name."];
        [authTimer invalidate];
    }
    else if(authTimerCounter > 30)
    {
        [self DisableFields:YES];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [authTimer invalidate];
    }
    else {
        authTimerCounter++;
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

- (void) setUserCridentials:(NSData *)responseData 
{
    authTimerCounter = 80; //80 > 30
    NSDictionary *jsDict = [IEHelperMethods getExtractedDataFromJSONItem:responseData];
    SimpleClass *sc = [[SimpleClass alloc] initWithDictionary:jsDict];
    if(sc == nil)
    {
        [self DisableFields:YES];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [resultLabel setText:@"Can't connect to server. Please check server name."];
    }
    if ([sc.Id isEqualToString:POZITIVE_VALUE]) 
    {
        NSString *usrPass = [NSString stringWithFormat:@"%@|%@", userNameTextField.text, passwordTestField.text];
        NSString *encStr = [StringEncryption EncryptString:usrPass];
        
        if ([IEHelperMethods setUserDefaultSettingsString:encStr key:IENDURA_SERVER_USRPASS_KEY]) 
        {
            [IEHelperMethods setUserDefaultSettingsString:userNameTextField.text key:IENDURA_USERNAME_KEY];
            [IEHelperMethods setUserDefaultSettingsString:passwordTestField.text key:IENDURA_PASSWORD_KEY];
            APP_DELEGATE.userSeesionId = sc.Value;
        };
    }
    else 
    {
        [self DisableFields:YES];
        [saveButton setTitle:@"Submit" forState:UIControlStateNormal];
        [resultLabel setText:sc.Value];
    }
}

- (IBAction)locoutButtonClicked:(id)sender 
{
    [IEHelperMethods resetUserDefaultSettings];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)changeAutoDBUpdate:(UISwitch *)sender 
{
    [IEHelperMethods setUserDefaultSettingsString:(autoUpdateSwitch.on ? POZITIVE_VALUE : NEGATIVE_VALUE) key:AUTO_UPDATE_CAMERA_DB_KEY];
}


@end






