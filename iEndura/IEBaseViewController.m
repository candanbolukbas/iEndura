//
//  IEBaseViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 31 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEBaseViewController.h"
#import "IEFavoritesViewController.h"

@interface IEBaseViewController ()

@end

@implementation IEBaseViewController

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
    UITapGestureRecognizer *twoFingersTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerTouchAction)];
	[twoFingersTap setNumberOfTapsRequired:1];
	[twoFingersTap setNumberOfTouchesRequired:2];
	[self.view addGestureRecognizer:twoFingersTap];
    self.view.multipleTouchEnabled = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)twoFingerTouchAction
{
    if(!APP_DELEGATE.favMenuOpened)
    {
        IEFavoritesViewController *mv = [[IEFavoritesViewController alloc] init];
        mv.view.opaque = NO;
        mv.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentModalViewController:mv animated:NO];
    }
}

@end
