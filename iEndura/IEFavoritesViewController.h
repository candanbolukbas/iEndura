//
//  IEFavoritesViewController.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 8 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

@interface IEFavoritesViewController : UIViewController
{
    NSArray *currentFavorites;
}

@property (weak, nonatomic) IBOutlet UILabel *alertBoxDescLabel;

- (IBAction)favButtonClicked:(UIButton *)sender;

@end
