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
@synthesize userNameTextField, passwordTextField, resultLabel;

- (void) viewDidLoad {
    [self.view setBackgroundColor:[IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_LIGHT_BLUE]]; 
    
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
	if (![IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_ADDRESS_KEY]) {
        IESettingsViewController *iesv = [[IESettingsViewController alloc] initWithNibName:@"IESettingsViewController" bundle:nil];
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:iesv animated:YES];
    }
    else if(![IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_USRPASS_KEY])
    {
        NSLog(@"No user cridentials found!");
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) finishedWithData:(NSData *)data forTag:(iEnduraRequestTypes)tag {
	if (tag == IE_Req_Auth) {
		[self setUserCridentials:data];
	}
	else {
		
	}
}

- (void) setUserCridentials:(NSData *)responseData 
{
    NSDictionary *jsDict = [IEHelperMethods getExtractedDataFromJSONItem:responseData];
    SimpleClass *sc = [[SimpleClass alloc] initWithDictionary:jsDict];
    if ([sc.Id isEqualToString:POZITIVE_VALUE]) 
    {
        if ([IEHelperMethods setUserDefaultSettingsString:APP_DELEGATE.encryptedUsrPassString key:IENDURA_SERVER_USRPASS_KEY]) 
        {
            [IEHelperMethods setUserDefaultSettingsString:userNameTextField.text key:IENDURA_USERNAME_KEY];
            APP_DELEGATE.userSeesionId = sc.Value;
            [self dismissModalViewControllerAnimated:YES];
        };
    }
    else 
    {
        [resultLabel setText:sc.Value];
    }
}

- (void) viewDidUnload {
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setResultLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction) submitButtonClicked:(UIButton *)sender {
    [passwordTextField resignFirstResponder];
    [userNameTextField resignFirstResponder];
    [resultLabel setText:@"Submitting"];
    
    /*dispatch_async(IENDURA_DISPATCH_QUEUE, ^{
        NSData* data = [NSData dataWithContentsOfURL: 
                        [NSURL URLWithString:[NSString stringWithFormat:IENDURA_AUTH_URL_FORMAT, 
                                              userNameTextField.text, passwordTextField.text]]];
        [self performSelectorOnMainThread:@selector(fetchedData:) 
                               withObject:data waitUntilDone:YES];
    });*/
    
    /*[NSURLConnection sendAsynchronousRequest:request 
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
     NSLog(@"Finished! data: %@", data);
     //[self fetchedData:data];
     }];
     NSURLResponse *response = nil;
     NSError *error = nil;
     NSData *data = [NSURLConnection sendSynchronousRequest:request
     returningResponse:&response
     error:&error];
     NSLog(@"Finished! data: %@", data);*/
    
    NSString *username = userNameTextField.text;
    NSString *password = passwordTextField.text;
    /*NSString *usrPass = [NSString stringWithFormat:@"%@|%@", username, password];
    NSString *encStr = [StringEncryption EncryptString:usrPass];
    APP_DELEGATE.encryptedUsrPassString = encStr;
    
    NSString *urlStr = [NSString stringWithFormat:IENDURA_AUTH_URL_FORMAT, encStr];
    NSURL *authUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];*/
    
    NSURL *authUrl = [IEServiceManager GetAuthenticationUrl:username :password];
	
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
	return YES;
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






