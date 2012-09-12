//
//  IECamImgViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 8 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IECamImgViewController : UIViewController <IEConnControllerDelegate>
{
    IECameraClass *CurrentCamera;
    NSArray *neighborCameras;
    NSTimer *imageTimer;
    BOOL connectionReady;
}

@property (nonatomic,retain) IECameraClass *CurrentCamera;
@property (weak, nonatomic) IBOutlet UIImageView *screenshotImageView;
@property (nonatomic,retain) NSArray *neighborCameras;
@property (weak, nonatomic) IBOutlet UIWebView *videoWebView;
@property (nonatomic, retain) NSTimer *imageTimer;
@property (weak, nonatomic) IBOutlet UIView *overlayView;

- (IBAction)imageViewTouchAction;
- (IBAction)imageSwipeLeftAction;
- (IBAction)imageSwipeRightAction;

@end
