//
//  IEFavoritesViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 8 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEFavoritesViewController.h"
#import "IECamPlayViewController.h"

@interface IEFavoritesViewController ()

@end

@implementation IEFavoritesViewController

@synthesize alertBoxDescLabel;

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
    IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
    currentFavorites = [dbOps GetFavoriteCameras];
    for(int i=1; i<=12; i++)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        
        if([currentFavorites count] > i-1)
        { 
            IECameraClass *cc = [currentFavorites objectAtIndex:i-1];
            UIImage *btnImage = [UIImage imageNamed:@"button_circular_fav.png"];
            [button setImage:btnImage forState:UIControlStateNormal];
            [button setTitle:cc.Name forState:UIControlStateNormal];
        }
        else 
        {
            [button setTitle:@"Empty Slot" forState:UIControlStateNormal];
        }
        
        [self animateButton:button angle:120-(i*30)];
    }
}

- (IBAction)animateButton:(UIButton *)sender angle:(CGFloat)angle
{
    //sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [self.view addSubview:sender];
    float radius = 125.0;
    double angleRadius = (angle / 180) * M_PI;
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        //int distance = self.view.center.x > self.view.center.y ? self.view.center.y : self.view.center.x;
        sender.center = CGPointMake(self.view.center.x + radius * cos(angleRadius), self.view.center.y - radius * sin(angleRadius));
        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            //sender.center = CGPointMake(sender.center.x, sender.center.y);
            sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                //sender.center = CGPointMake(sender.center.x, sender.center.y + 10);
                sender.transform = CGAffineTransformIdentity;                            
            }];
        }];
    }];
    
    UILabel *name = [[UILabel alloc] init];
    name.text = sender.currentTitle;
    name.textColor = [UIColor whiteColor];
    name.font = [UIFont boldSystemFontOfSize:10];
    //name.center = CGPointMake(self.view.center.x + radius * cos(angleRadius) * 0.3, self.view.center.y - radius * sin(angleRadius) * 0.3);
    //[name sizeToFit];
    name.frame = CGRectMake(self.view.center.x -50 + radius * cos(angleRadius) * 0.64, self.view.center.y - 10 - radius *sin(angleRadius) * 0.64, 100, 20);
    /*if(sender.center.y < 220)
     name.frame = CGRectMake(sender.center.x-40, sender.center.y - 35, 80, 20);
     else
     name.frame = CGRectMake(sender.center.x-40, sender.center.y + 12, 80, 20);*/
    name.backgroundColor = [UIColor clearColor];
    name.opaque = NO;
    
    if(sender.tag > 6)
    {
        name.textAlignment = UITextAlignmentRight;
        name.transform = CGAffineTransformMakeRotation(M_PI-angleRadius);
    }
    else 
    {
        
        name.textAlignment = UITextAlignmentLeft;
        name.transform = CGAffineTransformMakeRotation(-angleRadius);
    }
    name.tag = sender.tag + 20;
    [self.view addSubview:name];
    
}

- (IBAction)animateButtonSwap:(UIButton *)sender isFinished:(BOOL)finished
{
    [UIView animateWithDuration:0.3/1.5 animations:^{
        sender.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{                
            if(finished)
                [self dismissModalViewControllerAnimated:YES];                          
        }];
    }];
}

- (IBAction) dismissButtonClicked:(id)sender 
{    
    for(int i=1; i<=12; i++)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        UILabel *label = (UILabel *)[self.view viewWithTag:i+20];
        [label removeFromSuperview];
        [self animateButtonSwap:button isFinished:i==12];
    }
    
	[self dismissModalViewControllerAnimated:NO];
}

- (void)viewDidUnload
{
    [self setAlertBoxDescLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dismissAlertWindow
{
    alertBoxDescLabel.alpha = 0.0;
}

- (void)showAlertWindow
{
    alertBoxDescLabel.alpha = 1.0;
}

- (void)animateAlertBox:(NSString *)alertDesc 
{
    alertBoxDescLabel.text = alertDesc;
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        [self showAlertWindow];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8/2 animations:^{
            alertBoxDescLabel.alpha = 0.99;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2/2 animations:^{
                [self dismissAlertWindow];
            }];
        }];
    }];
}

- (IBAction)favButtonClicked:(UIButton *)sender 
{
    if(sender.tag == 0)
    {
        for(int i=1; i<=12; i++)
        {
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            UILabel *label = (UILabel *)[self.view viewWithTag:i+20];
            [label removeFromSuperview];
            [self animateButtonSwap:button isFinished:i==12];
        }
        [self dismissModalViewControllerAnimated:YES];
    }
    else if(sender.tag-1 < [currentFavorites count])
    {
        IECameraClass *currentCamera = [currentFavorites objectAtIndex:sender.tag-1];
        IECamPlayViewController *cpvc = [[IECamPlayViewController alloc] init];
        cpvc.CurrentCamera = currentCamera;
        [cpvc.dismissButton setHidden:NO];
        cpvc.showDismissButton = YES;
        [self presentModalViewController:cpvc animated:YES];
    }
    else 
    {
        [self animateAlertBox:@"No favorite in this slot!"];
    }
}
@end
