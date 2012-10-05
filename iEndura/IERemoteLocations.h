//
//  IERemoteLocations.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 1 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IERemoteLocations : NSObject
{
    NSString *RemoteLocationName;   
    NSNumber *NumberOfCameras; 
    NSString *SMsIPAddress;
}

@property (nonatomic, copy) NSString *RemoteLocationName;
@property (nonatomic, copy) NSNumber *NumberOfCameras;
@property (nonatomic, copy) NSString *SMsIPAddress;

@end
