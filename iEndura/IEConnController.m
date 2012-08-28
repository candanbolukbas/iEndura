//
//  IEConnController.m
//  iEndura
//
//  Created by Metehan Karabiber on 8/28/12.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEConnController.h"

@implementation IEConnController
@synthesize delegate;

- (id) initWithURL:(NSURL *)url property:(iEnduraRequestTypes)tag {
	self = [super init];
	connTag = tag;
	request = [[NSMutableURLRequest alloc] initWithURL:url];
	
	return self;
}

+ (void) testEnumFunc:(iEnduraRequestTypes)requestType
{
    if (requestType == IE_Req_Auth) {
        NSLog(@"Auth");
    }
    else if (requestType == IE_Req_CamList) {
        NSLog(@"CamList");
    }
    else if (requestType == IE_Req_CamImage)
    {
        NSLog(@"CamImage");
    }
    else {
        NSLog(@"Nothing");
    }
}

- (void) startConnection {
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

	if (conn)
		resultData = [NSMutableData data];
}

- (BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return YES;
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[resultData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[resultData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	[self.delegate finishedWithData:resultData forTag:connTag];
}



@end
