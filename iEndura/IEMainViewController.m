//
//  IEMainViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 28 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEMainViewController.h"
#import "IEViewController.h"

@interface IEMainViewController ()

@end

@implementation IEMainViewController
@synthesize testLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    // Do any additional setup after loading the view from its nib.
    if ([IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_STRING]) {
        testLabel.text = [IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_STRING];
    }
    else {
        testLabel.text = @"No iEndura Server found!";
        IEViewController *iev = [[IEViewController alloc] initWithNibName:@"IEViewController" bundle:nil];
        //iev.view.opaque = YES;
        //iev.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:iev animated:YES];
    }
	
}

- (void) viewDidUnload {
    [self setTestLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goButtonClicked:(UIButton *)sender 
{
    testLabel.text = @"No iEndura Server found! Go!";
    IEViewController *iev = [[IEViewController alloc] init];
    //iev.view.opaque = NO;
    //iev.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentModalViewController:iev animated:YES];
}
@end
