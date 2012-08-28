//
//  IEViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 24 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEViewController.h"
#import <CommonCrypto/CommonCryptor.h>

@interface IEViewController ()

@end

@implementation IEViewController
@synthesize userNameTextField, passwordTextField, resultLabel;

- (void) viewDidLoad {
    [self.view setBackgroundColor:[IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_LIGHT_BLUE]]; 
    
    [super viewDidLoad];
}

- (void) finishedWithData:(NSData *)data forTag:(iEnduraRequestTypes)tag {
	if (tag == IE_Req_Auth) {
		[self fetchedData:data];
	}
	else {
		
	}
}

- (void) fetchedData:(NSData *)responseData {
    NSLog(@"%@", responseData);
    NSDictionary *jsDict = [IEHelperMethods getExtractedDataFromJSONItem:responseData];
    NSLog(@"%@", jsDict);
    [resultLabel setText:[jsDict objectForKey:@"Value"]];
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
    
    
    /*NSString * _secret = @"_+-*)(\\$%^#@,.;'[]/~=&ğüşiöçıĞÜŞİÖÇI<>?:;\"'{}|";
	NSString * _key = @"ju4ev@D++agatuc4";
	StringEncryption *crypto = [[StringEncryption alloc] init];
	NSData *_secretData = [_secret dataUsingEncoding:NSUTF8StringEncoding];
	CCOptions padding = kCCOptionPKCS7Padding;
	NSData *encryptedData = [crypto encrypt:_secretData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
    NSString *encStr = [NSString stringWithFormat:@"%@", [encryptedData base64EncodingWithLineLength:0]];
    NSLog(@"encrypted data string for export: %@",encStr);
    
    dispatch_async(IENDURA_DISPATCH_QUEUE, ^{
        NSData* data = [NSData dataWithContentsOfURL: 
                        [NSURL URLWithString:[NSString stringWithFormat:IENDURA_ENC_URL_FORMAT, encStr]]];
        [self performSelectorOnMainThread:@selector(fetchedData:) 
                               withObject:data waitUntilDone:YES];
    });*/
    
    NSString *username = userNameTextField.text;
    NSString *password = passwordTextField.text;
    NSString *usrPass = [NSString stringWithFormat:@"%@|%@", username, password];
    NSString *encStr = [StringEncryption EncryptString:usrPass];
    
    NSURL *authUrl = [NSURL URLWithString:[NSString stringWithFormat:IENDURA_AUTH_URL_FORMAT, encStr]];
    NSLog(@"%@", authUrl);
    
//  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:authUrl];
//	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	IEConnController *controller = [[IEConnController alloc] initWithURL:authUrl property:0];
	controller.delegate = self;
	[controller startConnection];
	
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

- (void) encrypTextTest {
    
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






