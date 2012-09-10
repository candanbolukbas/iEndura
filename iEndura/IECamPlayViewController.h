//
//  IECamPlayViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 3 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IECamImgViewController.h"

@interface IECamPlayViewController: IEBaseViewController <IEConnControllerDelegate>
{
    IECameraClass *CurrentCamera;
    NSTimer *imageTimer;
    NSTimer *playSmoothTimer;
    int playSmoothCounter;
    int frameCount;
    IECamImgViewController *civc;
    BOOL showDismissButton;
}

@property (nonatomic, weak) UIView *serverDefineView;
@property (nonatomic,retain) IECameraClass *CurrentCamera;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIImageView *screenshotImageView;
@property (weak, nonatomic) IBOutlet UIButton *addToFavoritesButton;
@property (weak, nonatomic) IBOutlet UIScrollView *playScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *alertBoxBGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alertBoxIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *alertBoxDescLabel;
@property (weak, nonatomic) IBOutlet UIWebView *videoWebView;
@property (nonatomic, retain) NSTimer *imageTimer;
@property (nonatomic, retain) NSTimer *playSmoothTimer;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *playSmoothButton;
@property (nonatomic, assign) BOOL showDismissButton;

- (IBAction)addToFavoritesButtonClicked:(UIButton *)sender;
- (IBAction)dismissButtonClicked:(id)sender;
- (IBAction)imageViewTouchAction;
- (IBAction)playButtonClicked:(UIButton *)sender;

@end
