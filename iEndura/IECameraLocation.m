//
//  IECameraLocation.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 1 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IECameraLocation.h"

@implementation IECameraLocation

@synthesize RemoteLocation, LocationRoot, LocationChild;

- (id) initWithArray:(NSArray *)locArray
{
    self = [super init];
    
    if([locArray count] == 3)
    {
        RemoteLocation = [locArray objectAtIndex:0];
        LocationRoot = [locArray objectAtIndex:1];
        LocationChild = [locArray objectAtIndex:2];
    }
    
    return self;
}



@end
