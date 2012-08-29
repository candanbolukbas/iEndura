//
//  IEAppDelegate.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 24 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IEMainViewController;

@interface IEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IEMainViewController *viewController;
@property (nonatomic, strong) NSString *encryptedUsrPassString;

@end
