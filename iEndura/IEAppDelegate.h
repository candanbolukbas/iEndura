//
//  IEAppDelegate.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 24 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

@class IEMainViewController;
@class IECameraClass;

@interface IEAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate>
{
    NSTimer *authTimer;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *viewController;
//@property (nonatomic, strong) NSString *encryptedUsrPassString;
@property (nonatomic, strong) NSString *userSeesionId;
@property (nonatomic, strong) NSString *navBarTitle;
@property (nonatomic, assign) BOOL dbRequiresUpdate;
@property (nonatomic, assign) BOOL favMenuOpened;
@property (nonatomic, strong) IECameraClass *currCam;

@end
