//
//  IEAppDelegate.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 24 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEAppDelegate.h"
#import "IEHelperMethods.h"
#import "IEMainViewController.h"

@implementation IEAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize encryptedUsrPassString, userSeesionId, navBarTitle;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	
	IEMainViewController *mainVC = [[IEMainViewController alloc] initWithNibName:@"IEMainViewController" bundle:nil];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainVC];
	//navController.delegate = self;
	navController.navigationBar.tintColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
    
    
    self.viewController = navController;
    APP_DELEGATE.encryptedUsrPassString = [IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_USRPASS_KEY];
    APP_DELEGATE.userSeesionId = @"";
    //APP_DELEGATE.navBarTitle = @"iEnduraa";
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    NSString *app_requires_init = [IEHelperMethods getUserDefaultSettingsString:APP_REQUIRES_INIT_KEY];
    
    if(app_requires_init == nil || [app_requires_init isEqualToString:POZITIVE_VALUE])
    {
        IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
        [dbOps CopyDbToDocumentsFolder];
        [IEHelperMethods setUserDefaultSettingsString:NEGATIVE_VALUE key:APP_REQUIRES_INIT_KEY];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //CGRect frame = CGRectMake(0, 0, 320, 44);//TODO: Can we get the size of the text?
    //UILabel* label = [[UILabel alloc] initWithFrame:frame];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = APP_DELEGATE.navBarTitle;
    //[self.navigationController.navigationBar.topItem setTitleView:label];
    viewController.navigationItem.titleView = label;
}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.font = [UIFont fontWithName:@"Helvetica" size: 15.0];
//    titleLabel.text = @"iEnduraa";
//    viewController.navigationItem.titleView = titleLabel;
//}

@end
