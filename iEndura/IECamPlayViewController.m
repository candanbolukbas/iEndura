//
//  IECamPlayViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 3 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IECamPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface IECamPlayViewController ()

@end

@implementation IECamPlayViewController

@synthesize CurrentCamera;
@synthesize testLabel;
@synthesize screenshotImageView;
@synthesize videoFrameView;
@synthesize videoWebView;
@synthesize imageTimer;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    imageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(UpdateImage:) userInfo:nil repeats:YES];
}

- (void)viewDidUnload
{
    [self setTestLabel:nil];
    [self setScreenshotImageView:nil];
    [self setVideoFrameView:nil];
    [self setVideoWebView:nil];
    [self setImageTimer:nil];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)UpdateImage:(NSTimer *)theTimer 
{
    NSString *userName = [IEHelperMethods getUserDefaultSettingsString:IENDURA_USERNAME_KEY];
    NSString *encStr = [StringEncryption EncryptString:[NSString stringWithFormat:@"%@|%@|%@", userName, APP_DELEGATE.userSeesionId, CurrentCamera.IP]];
    NSString *urlStr = [NSString stringWithFormat:IENDURA_CAM_IMG_URL_FORMAT, encStr];
    NSURL *camImgUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
	IEConnController *controller = [[IEConnController alloc] initWithURL:camImgUrl property:IE_Req_CamImage];
	controller.delegate = self;
	[controller startConnection];
}

- (IBAction)playButtonClicked:(UIButton *)sender 
{
        NSURL *videoUrl = [[NSURL alloc] initWithString:@"http://www.iendura.com/stream/10.0.30.31.m3u8"];
//    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
//    
//    [player setControlStyle:MPMovieControlStyleFullscreen];
//    [player setMovieSourceType:MPMovieSourceTypeStreaming];
//    [player setFullscreen:YES];
//    
//    [self.view addSubview:[player view]];
//    
//    [player prepareToPlay];
//    [player play];
    
    [videoWebView loadRequest:[NSURLRequest requestWithURL:videoUrl]];
}
@end





