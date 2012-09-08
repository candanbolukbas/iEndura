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

@synthesize CurrentCamera;
@synthesize testLabel;
@synthesize screenshotImageView;
@synthesize addToFavoritesButton;
@synthesize playScrollView;
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
        //double ratio = ret.size.height / ret.size.width;
        //screenshotImageView.frame = CGRectMake(12, 12, 296, 296*ratio);
    }
    else if (tag == IE_Req_CamHls) 
    {
        NSString *streamUrlStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSURL *streamUrl = [[NSURL alloc] initWithString:[IEHelperMethods ConvertJsonStringToNormalString:streamUrlStr]];
        NSLog(@"%@", streamUrlStr);
        [videoWebView loadRequest:[NSURLRequest requestWithURL:streamUrl]];
        NSLog(@"Stream: %@", streamUrl);
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
    NSArray *currentFovorites = [IEHelperMethods getUserDefaultSettingsArray:FAVORITE_CAMERAS_KEY];
    if([currentFovorites containsObject:CurrentCamera.IP])
        addToFavoritesButton.titleLabel.text = @"Remove from Favorites";
    else
        addToFavoritesButton.titleLabel.text = @"Add to Favorites";
    
    UITapGestureRecognizer *oneFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouchAction)];
	[oneFingerDoubleTap setNumberOfTapsRequired:1];
	[oneFingerDoubleTap setNumberOfTouchesRequired:1];
    [screenshotImageView addGestureRecognizer:oneFingerDoubleTap];
	//[self.view addGestureRecognizer:oneFingerDoubleTap];
}

- (void)viewDidAppear:(BOOL)animated
{
    imageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(UpdateImage:) userInfo:nil repeats:YES];
}

- (void)viewDidUnload
{
    [self setTestLabel:nil];
    [self setScreenshotImageView:nil];
    [self setVideoWebView:nil];
    [self setImageTimer:nil];
    [self setAddToFavoritesButton:nil];
    [self setPlayScrollView:nil];
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
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        //screenshotImageView.frame = CGRectMake(12, 12, 296, 222);
        //self.hidesBottomBarWhenPushed = NO;
        playScrollView.contentSize = CGSizeMake(320, 370);
    }
    else 
    {
        //screenshotImageView.frame = CGRectMake(12, 12, 456, 222);
        
        //[self.tabBarController.tabBar setHidden:TRUE];
        //self.tabBarController.selectedViewController.view.frame = CGRectMake(0, 0, 480, 320);
        //[UIApplication sharedApplication].keyWindow.frame=CGRectMake(0, 0, 320, 480);
        playScrollView.contentSize = CGSizeMake(480, 370);
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

- (IBAction)playButtonClicked:(UIButton *)sender 
{
    NSURL *camHlsReqUrl = [IEServiceManager GetCamHlsReqUrl:CurrentCamera.IP];
    NSLog(@"%@", camHlsReqUrl);
	IEConnController *controller = [[IEConnController alloc] initWithURL:camHlsReqUrl property:IE_Req_CamHls];
	controller.delegate = self;
	[controller startConnection];
}
- (IBAction)addToFavoritesButtonClicked:(UIButton *)sender 
{
    NSMutableArray *currentFovorites = [[NSMutableArray alloc] initWithArray:[IEHelperMethods getUserDefaultSettingsArray:FAVORITE_CAMERAS_KEY] copyItems:YES];
    if(currentFovorites)
    {
        NSLog(@"Current Favorites before: %@", currentFovorites);
        if([currentFovorites containsObject:CurrentCamera.IP])
        {
            [currentFovorites removeObject:CurrentCamera.IP];
            if ([IEHelperMethods setUserDefaultSettingsObject:currentFovorites key:FAVORITE_CAMERAS_KEY])
            {
                addToFavoritesButton.titleLabel.text = @"Add to Favorites";
                UIImage *btnImage = [UIImage imageNamed:@"iendura_app_icon_57.png"];
                [sender setImage:btnImage forState:UIControlStateNormal];
            }
            else {
                NSLog(@"Can not added to favorites.");
            }
        }
        else 
        {
            [currentFovorites addObject:CurrentCamera.IP];
            if ([IEHelperMethods setUserDefaultSettingsObject:currentFovorites key:FAVORITE_CAMERAS_KEY])
            {
                addToFavoritesButton.titleLabel.text = @"Remove from Favorites";
                UIImage *btnImage = [UIImage imageNamed:@"iendura_top.png"];
                [sender setImage:btnImage forState:UIControlStateNormal];
            }
            else {
                NSLog(@"Can not added to favorites.");
            }
        }
        NSLog(@"Current Favorites After: %@", currentFovorites);
    }
    else {
        NSLog(@"Cant get current favorite cams");
    }
}

- (IBAction)imageViewTouchAction 
{
    NSLog(@"touch");
    IECamImgViewController *civc = [[IECamImgViewController alloc] init];
    civc.CurrentCamera = CurrentCamera;
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:civc animated:YES];
    //screenshotImageView.frame = CGRectMake(0, -240, 320, 480);
}
@end










