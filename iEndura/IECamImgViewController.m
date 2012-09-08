//
//  IECamImgViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 8 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IECamImgViewController.h"

@interface IECamImgViewController ()

@end

@implementation IECamImgViewController

@synthesize CurrentCamera;
@synthesize screenshotImageView;
@synthesize videoWebView;
@synthesize imageTimer;

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
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *oneFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouchAction)];
	[oneFingerDoubleTap setNumberOfTapsRequired:1];
	[oneFingerDoubleTap setNumberOfTouchesRequired:1];
    [screenshotImageView addGestureRecognizer:oneFingerDoubleTap];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [UIApplication sharedApplication].keyWindow.frame=CGRectMake(0, 0, 320, 480);
}

- (void)viewDidUnload
{
    [self setScreenshotImageView:nil];
    [self setVideoWebView:nil];
    [self setImageTimer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    imageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(UpdateImage:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated 
{
    [imageTimer invalidate];
    [self setImageTimer:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)UpdateImage:(NSTimer *)theTimer 
{
    NSURL *camImgUrl = [IEServiceManager GetCamImgUrl:CurrentCamera.IP];
	IEConnController *controller = [[IEConnController alloc] initWithURL:camImgUrl property:IE_Req_CamImage];
	controller.delegate = self;
	[controller startConnection];
}

- (void) finishedWithData:(NSData *)data forTag:(iEnduraRequestTypes)tag 
{
	if (tag == IE_Req_CamImage)  
    {
        NSString *base64EncodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *imgData = [[NSData alloc] initWithBase64EncodedString:base64EncodedString];
        UIImage *ret = [UIImage imageWithData:imgData];
        screenshotImageView.image = ret;
    }
	else 
    {
        NSLog(@"What is this: %@", tag);
    }
}

- (IBAction)imageViewTouchAction 
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    //[UIApplication sharedApplication].keyWindow.frame=CGRectMake(0, 0, 320, 480);
    [self dismissModalViewControllerAnimated:YES];
}

@end
