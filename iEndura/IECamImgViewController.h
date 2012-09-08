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
    NSTimer *imageTimer;
}

@property (nonatomic,retain) IECameraClass *CurrentCamera;
@property (weak, nonatomic) IBOutlet UIImageView *screenshotImageView;

@property (weak, nonatomic) IBOutlet UIWebView *videoWebView;
@property (nonatomic, retain) NSTimer *imageTimer;

- (IBAction)imageViewTouchAction;
@end
