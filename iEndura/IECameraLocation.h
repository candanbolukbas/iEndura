//
//  IECameraLocation.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 1 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IECameraLocation : NSObject
{
    NSString *RemoteLocation;   
    NSString *LocationRoot;     
    NSString *LocationChild;     
}

@property (nonatomic, copy) NSString *RemoteLocation;
@property (nonatomic, copy) NSString *LocationRoot;
@property (nonatomic, copy) NSString *LocationChild;

- (id) initWithArray:(NSArray *)locArray;


@end
