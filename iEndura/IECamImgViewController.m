//
//  IECamImgViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 8 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IECamImgViewController.h"
#import "IECamPlayViewController.h"

@interface IECamImgViewController ()

@end

@implementation IECamImgViewController
@synthesize overlayView;

@synthesize CurrentCamera, screenshotImageView, imageTimer, neighborCameras;

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    connectionReady = YES;
}

- (void)viewDidUnload
{
    [self setScreenshotImageView:nil];
    [self setImageTimer:nil];
    CurrentCamera = nil;
    [self setOverlayView:nil];
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)UpdateImage:(NSTimer *)theTimer 
{
    NSURL *camImgUrl = [IEServiceManager GetCamImgUrl:CurrentCamera.IP];
	IEConnController *controller = [[IEConnController alloc] initWithURL:camImgUrl property:IE_Req_CamImage];
    controller.addParams = CurrentCamera;
	controller.delegate = self;
    if(connectionReady)
    {
        connectionReady = NO;
        [controller startConnection];
    }
}

- (void) finishedWithData:(NSData *)data forTag:(iEnduraRequestTypes)tag withObject:(NSObject *)additionalParameters
{
	if (tag == IE_Req_CamImage)  
    {
        IECameraClass *cc = [[IECameraClass alloc] init];
        cc = (IECameraClass *)additionalParameters;
        if([cc.Name isEqualToString:CurrentCamera.Name] && [cc.IP isEqualToString:CurrentCamera.IP])
        {
            NSString *base64EncodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *imgData = [[NSData alloc] initWithBase64EncodedString:base64EncodedString];
            UIImage *ret = [UIImage imageWithData:imgData];
            [UIView transitionWithView:self.view
                              duration:0.2f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                screenshotImageView.image = ret;
                            } completion:NULL];
        }
        connectionReady = YES;
    }
}

- (IBAction)imageViewTouchAction 
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)imageSwipeLeftAction
{//next
    [self showUpdateView];
    int camIndex = [self FindIndexOfCamera:CurrentCamera InArray:neighborCameras];
    
    if (camIndex != -1 && camIndex != neighborCameras.count-1) 
    {
        IECameraClass *nextCam = [[IECameraClass alloc] init];
        nextCam = [neighborCameras objectAtIndex:camIndex+1];
        CurrentCamera = nextCam;
        
        [self ResetObjects];
    }
    [self hideUpdateView];
}

- (IBAction)imageSwipeRightAction
{//previous
    [self showUpdateView];
    int camIndex = [self FindIndexOfCamera:CurrentCamera InArray:neighborCameras];
    
    if (camIndex != -1 && camIndex != 0) 
    {
        IECameraClass *prevCam = [[IECameraClass alloc] init];
        prevCam = [neighborCameras objectAtIndex:camIndex-1];
        CurrentCamera = prevCam;
        
        [self ResetObjects];
    }
    [self hideUpdateView];
}

- (void) ResetObjects
{        
    [imageTimer invalidate];
    [self setImageTimer:nil];
    screenshotImageView.image = [UIImage imageNamed:@"connecting.png"];
    APP_DELEGATE.currCam = CurrentCamera;
    [self SetScreenShotImage];
}

- (void)SetScreenShotImage
{
    if(CurrentCamera.uuid.length > 0)
    {
        connectionReady = YES;
        imageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(UpdateImage:) userInfo:nil repeats:YES];
    }
    else 
    {
        screenshotImageView.image = [UIImage imageNamed:@"no_preview.png"];
    }
}

- (void) showUpdateView
{
    [overlayView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3f]];
    [overlayView setAlpha:0.0f];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [overlayView setAlpha:1.0f];
                     }];
}

- (void) hideUpdateView
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         [overlayView setAlpha:0.0f];
                     }];
}


- (int) FindIndexOfCamera:(IECameraClass *)cam InArray:(NSArray *)camArray
{
    for (int i=0; i < camArray.count; i++) 
    {
        IECameraClass *cc = [[IECameraClass alloc] init];
        cc = [camArray objectAtIndex:i];
        if([cc.Name isEqualToString:cam.Name] && [cc.IP isEqualToString:cam.IP ])
        {
            return i;
        }
    }
    return -1;
}

@end




