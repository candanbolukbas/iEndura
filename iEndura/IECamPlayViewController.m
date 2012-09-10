//
//  IECamPlayViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 3 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IECamPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "IECamImgViewController.h"

@interface IECamPlayViewController ()

@end

@implementation IECamPlayViewController

@synthesize CurrentCamera, testLabel, screenshotImageView, addToFavoritesButton, playScrollView;
@synthesize alertBoxBGImageView, alertBoxIconImageView, alertBoxDescLabel, videoWebView;
@synthesize imageTimer, dismissButton, playSmoothButton, playSmoothTimer, serverDefineView, showDismissButton;

- (void) finishedWithData:(NSData *)data forTag:(iEnduraRequestTypes)tag 
{
	if (tag == IE_Req_CamImage)  
    {
        NSString *base64EncodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *imgData = [[NSData alloc] initWithBase64EncodedString:base64EncodedString];
        UIImage *ret = [UIImage imageWithData:imgData];
        screenshotImageView.image = ret;
    }
    else if (tag == IE_Req_CamHls) 
    {
        NSDictionary *jsDict = [IEHelperMethods getExtractedDataFromJSONItem:data];
        SimpleClass *sc = [[SimpleClass alloc] initWithDictionary:jsDict];
        
        if([sc.Id isEqualToString:POZITIVE_VALUE])
        {
            if(civc && civc != nil)
                [civc dismissModalViewControllerAnimated:YES];
            NSURL *streamUrl = [[NSURL alloc] initWithString:sc.Value];
            [playSmoothTimer invalidate];
            [playSmoothButton setEnabled:YES];
            playSmoothCounter = 20;
            [videoWebView loadRequest:[NSURLRequest requestWithURL:streamUrl]];
        }
        else {
            testLabel.text = sc.Value;
        }
    }
	else 
    {
    }
}

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
    testLabel.text = CurrentCamera.Name;
    NSArray *currentFovorites = [IEHelperMethods getUserDefaultSettingsArray:FAVORITE_CAMERAS_KEY];
    if([currentFovorites containsObject:CurrentCamera.IP])
    {
        UIImage *btnImage = [UIImage imageNamed:@"button_circular_fav.png"];
        [addToFavoritesButton setImage:btnImage forState:UIControlStateNormal];
    }
    else
    {
        UIImage *btnImage = [UIImage imageNamed:@"button_circular_fav_disabled.png"];
        [addToFavoritesButton setImage:btnImage forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *oneFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouchAction)];
	[oneFingerDoubleTap setNumberOfTapsRequired:1];
	[oneFingerDoubleTap setNumberOfTouchesRequired:1];
    [screenshotImageView addGestureRecognizer:oneFingerDoubleTap];
	//[self.view addGestureRecognizer:oneFingerDoubleTap];
    if (showDismissButton) 
    {
        [self.dismissButton setHidden:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if(CurrentCamera.uuid.length > 0)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        imageTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(UpdateImage:) userInfo:nil repeats:YES];
    }
    else 
    {
        screenshotImageView.image = [UIImage imageNamed:@"no_preview.png"];
    }
}

- (void)viewDidUnload
{
    [self setTestLabel:nil];
    [self setScreenshotImageView:nil];
    [self setVideoWebView:nil];
    [self setImageTimer:nil];
    [self setAddToFavoritesButton:nil];
    [self setPlayScrollView:nil];
    [self setAlertBoxBGImageView:nil];
    [self setAlertBoxIconImageView:nil];
    [self setAlertBoxDescLabel:nil];
    [self setDismissButton:nil];
    CurrentCamera = nil;
    civc = nil;
    [self setPlaySmoothButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated 
{
    [imageTimer invalidate];
    [self setImageTimer:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        playScrollView.contentSize = CGSizeMake(320, 370);
    }
    else 
    {
        playScrollView.contentSize = CGSizeMake(480, 400);
    }
    return YES;
}

- (void)UpdateImage:(NSTimer *)theTimer 
{
    NSURL *camImgUrl = [IEServiceManager GetCamImgUrl:CurrentCamera.IP];
	IEConnController *controller = [[IEConnController alloc] initWithURL:camImgUrl property:IE_Req_CamImage];
	controller.delegate = self;
	[controller startConnection];
}

- (void)UpdatePlaySmoothCounter:(NSTimer *)theTimer
{
    if(playSmoothCounter < 0)
    {
        [playSmoothButton setEnabled:YES];
        testLabel.text = @"Can't connect to iEndura server.";
    }
    else
    {
        [playSmoothButton setTitle:[NSString stringWithFormat:@"The stream will be ready in %d secs.", playSmoothCounter--] forState:UIControlStateDisabled];
    }
}

- (IBAction)playButtonClicked:(UIButton *)sender 
{
    NSURL *camHlsReqUrl = [IEServiceManager GetCamHlsReqUrl:CurrentCamera.IP];
	IEConnController *controller = [[IEConnController alloc] initWithURL:camHlsReqUrl property:IE_Req_CamHls];
	controller.delegate = self;
	[controller startConnection];
    
    playSmoothCounter = 20;
    [playSmoothButton setEnabled:NO];
    [playSmoothButton setTitle:[NSString stringWithFormat:@"The stream will be ready in %d secs.", playSmoothCounter] forState:UIControlStateDisabled];
    playSmoothTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(UpdatePlaySmoothCounter:) userInfo:nil repeats:YES];
}

- (void)dismissAlertWindow
{
    alertBoxBGImageView.alpha = 0.0;
    alertBoxDescLabel.alpha = 0.0;
    alertBoxIconImageView.alpha = 0.0;
}

- (void)showAlertWindow
{
    alertBoxBGImageView.alpha = 0.6;
    alertBoxDescLabel.alpha = 1.0;
    alertBoxIconImageView.alpha = 1.0;
}

- (void)animateAlertBox:(UIImage *)alertIconImage :(NSString *)alertDesc 
{
    alertBoxIconImageView.image = alertIconImage;
    alertBoxDescLabel.text = alertDesc;
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        [self showAlertWindow];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8/2 animations:^{
            alertBoxBGImageView.alpha = 0.61;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2/2 animations:^{
                [self dismissAlertWindow];
            }];
        }];
    }];
}

- (IBAction)addToFavoritesButtonClicked:(UIButton *)sender 
{
    NSMutableArray *currentFovorites = [[NSMutableArray alloc] initWithArray:[IEHelperMethods getUserDefaultSettingsArray:FAVORITE_CAMERAS_KEY] copyItems:YES];
    if(currentFovorites)
    {
        if([currentFovorites containsObject:CurrentCamera.IP])
        {
            [currentFovorites removeObject:CurrentCamera.IP];
            if ([IEHelperMethods setUserDefaultSettingsObject:currentFovorites key:FAVORITE_CAMERAS_KEY])
            {
                UIImage *alertIconImage = [UIImage imageNamed:@"balloon_fav_disabled.png"];
                [self animateAlertBox:alertIconImage :@"Removed from your favorites"];
                UIImage *btnImage = [UIImage imageNamed:@"button_circular_fav_disabled.png"];
                [sender setImage:btnImage forState:UIControlStateNormal];
            }
            else {
                NSLog(@"Can not remove from favorites.");
            }
        }
        else 
        {
            [currentFovorites addObject:CurrentCamera.IP];
            if ([IEHelperMethods setUserDefaultSettingsObject:currentFovorites key:FAVORITE_CAMERAS_KEY])
            {
                UIImage *alertIconImage = [UIImage imageNamed:@"balloon_fav_enabled.png"];
                [self animateAlertBox:alertIconImage :@"Added to your favorites"];
                UIImage *btnImage = [UIImage imageNamed:@"button_circular_fav.png"];
                [sender setImage:btnImage forState:UIControlStateNormal];
            }
            else {
                NSLog(@"Can not added to favorites.");
            }
        }
    }
    else {
        NSLog(@"Cant get current favorite cams");
    }
}

- (IBAction)dismissButtonClicked:(id)sender 
{
    [dismissButton setHidden:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)imageViewTouchAction 
{
    civc = [[IECamImgViewController alloc] init];
    civc.CurrentCamera = CurrentCamera;
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:civc animated:YES];
}


@end










