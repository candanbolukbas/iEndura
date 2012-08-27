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
@synthesize userNameTextField;
@synthesize passwordTextField;
@synthesize resultLabel;

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_LIGHT_BLUE]]; 
    
//    NSURL *xmlUrl = [NSURL URLWithString:[NSString stringWithFormat:IENDURA_ENC_URL_FORMAT, @"someString"]];
//    NSData *xmlData = [NSData dataWithContentsOfURL:xmlUrl];
//    dispatch_async(IENDURA_DISPATCH_QUEUE, ^{
//        NSData* data = [NSData dataWithContentsOfURL: 
//                        [NSURL URLWithString:[NSString stringWithFormat:IENDURA_ENC_URL_FORMAT, @"someString"]]];
//        [self performSelectorOnMainThread:@selector(fetchedData::) 
//                               withObject:data waitUntilDone:YES];
//    });
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://service.iendura.com/iservice/i/e/0"]];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (conn) {
		enduraData = [NSMutableData data];
	}
}

- (BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return YES;
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[enduraData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[enduraData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	//[self doParse:enduraData];
    [self fetchedData:enduraData];
}






- (void)fetchedData:(NSData *)responseData 
{
    //parse out the json data
    NSError* error;
    NSArray *jsArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSDictionary *jsDict = [jsArray objectAtIndex:0];
    [resultLabel setText:[jsDict objectForKey:@"Value"]];
}

- (void)viewDidUnload
{
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setResultLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)submitButtonClicked:(UIButton *)sender 
{
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
    
    
    NSString * _secret = @"_+-*)(\\$%^#@,.;'[]/~=&ğüşiöçıĞÜŞİÖÇI<>?:;\"'{}|";
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
    });
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{    
    if (textField == userNameTextField) {
		[textField resignFirstResponder];
		[passwordTextField becomeFirstResponder];
	} 
	else if (textField == passwordTextField) {
		[textField resignFirstResponder];
	}
	return YES;
}


-(void) encrypTextTest
{
    
}

- (void) doParse:(NSData *)data 
{    
    //NSLog(@"doParse xmlData: %@",data);
    // create and init our delegate
	NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//	NSLog(@"%@", [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:IENDURA_ENC_URL_FORMAT, @"0"]]]);
    IEXMLParser *parser = [[IEXMLParser alloc] initWithData:data];
    BOOL success = [parser.xmlParser parse];
    // set delegate
    
	NSArray *newArray = [[NSArray alloc] initWithArray:parser.scs];
    
    // test the result
    if (success) {
        NSLog(@"No errors - user count : %i\n %@", [parser.scs count], newArray);
        // get array of users here
        //  NSMutableArray *users = [parser users];
    } else {
        NSLog(@"Error parsing document!");
    }
    
}

@end





