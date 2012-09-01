//
//  IEPelcoCameraClass.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 30 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEPelcoCameraClass.h"

@implementation IEPelcoCameraClass

@synthesize uuid, IP, Name, CameraType, UpnpModelNumber, RTSP_URL, RemoteLocation, LocationRoot, LocationChild, VLCTranscode, SMsIPAddress, NSMIPAddress, Port;


- (id) initWithDictionary:(NSDictionary *)jsDict
{
    self = [super init];
    
    uuid = [jsDict objectForKey:@"uuid"];
    IP = [jsDict objectForKey:@"IP"];
    Name = [jsDict objectForKey:@"Name"];
    CameraType = [jsDict objectForKey:@"CameraType"];
    UpnpModelNumber = [jsDict objectForKey:@"UpnpModelNumber"];
    RTSP_URL = [jsDict objectForKey:@"RTSP_URL"];
    RemoteLocation = [jsDict objectForKey:@"RemoteLocation"];
    LocationRoot = [jsDict objectForKey:@"LocationRoot"];
    LocationChild = [jsDict objectForKey:@"LocationChild"];
    VLCTranscode = [jsDict objectForKey:@"VLCTranscode"];
    SMsIPAddress = [jsDict objectForKey:@"SMsIPAddress"];
    NSMIPAddress = [jsDict objectForKey:@"NSMIPAddress"];
    Port = [jsDict objectForKey:@"Port"];
    
    return self;
}

- (NSString *) generateSQLInsertString
{
    NSString *sqlStr = @"INSERT INTO PelcoCameras (UUID, IP, Name, CameraType, UpnpModelNumber, RTSP_URL, RemoteLocation, LocationRoot, LocationChild, VLCTranscode, SMsIPAddress, NSMIPAddress, Port) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')";
    if(![IP isEqualToString:@""])
    {
        NSString *resultStr = [NSString stringWithFormat:sqlStr, uuid, IP, Name, CameraType, UpnpModelNumber, RTSP_URL, RemoteLocation, LocationRoot, LocationChild, VLCTranscode, SMsIPAddress, NSMIPAddress, Port];
        return resultStr;
    }
    else {
        return @"";
    }
}

@end
