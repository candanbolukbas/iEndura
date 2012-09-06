//
//  IECamPlayViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 3 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IECamPlayViewController: IEBaseViewController <IEConnControllerDelegate>
{
    IECameraClass *CurrentCamera;
    NSTimer *imageTimer;
}
- (IBAction)playButtonClicked:(UIButton *)sender;

@property (nonatomic,retain) IECameraClass *CurrentCamera;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIImageView *screenshotImageView;
@property (weak, nonatomic) IBOutlet UIView *videoFrameView;
@property (weak, nonatomic) IBOutlet UIWebView *videoWebView;
@property (nonatomic, retain) NSTimer *imageTimer;

@end
