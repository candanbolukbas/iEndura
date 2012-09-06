//
//  IECameraClass.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 30 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IECameraClass : NSObject
{
    NSString *uuid; 
    NSString *IP; 
    NSString *Name; 
    NSString *CameraType; 
    NSString *UpnpModelNumber; 
    NSString *RTSP_URL; 
    NSString *RemoteLocation; 
    NSString *LocationRoot; 
    NSString *LocationChild; 
    NSString *VLCTranscode; 
    NSString *SMsIPAddress; 
    NSString *NSMIPAddress; 
    NSString *Port;
}

@property (nonatomic, copy) NSString *uuid; 
@property (nonatomic, copy) NSString *IP; 
@property (nonatomic, copy) NSString *Name; 
@property (nonatomic, copy) NSString *CameraType; 
@property (nonatomic, copy) NSString *UpnpModelNumber; 
@property (nonatomic, copy) NSString *RTSP_URL; 
@property (nonatomic, copy) NSString *RemoteLocation; 
@property (nonatomic, copy) NSString *LocationRoot; 
@property (nonatomic, copy) NSString *LocationChild; 
@property (nonatomic, copy) NSString *VLCTranscode; 
@property (nonatomic, copy) NSString *SMsIPAddress; 
@property (nonatomic, copy) NSString *NSMIPAddress; 
@property (nonatomic, copy) NSString *Port;

- (id) initWithDictionary:(NSDictionary *)jsDict;
- (NSString *) generateSQLInsertString;

@end
