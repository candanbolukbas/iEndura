//
//  IEServiceManager.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 6 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEServiceManager.h"

@implementation IEServiceManager

+ (NSURL *)GetAuthenticationUrl:(NSString *)username :(NSString *)password
{
    NSString *authUrlFormat = @"https://%@/iservice/i/e/auth/%@"; //...SERVER_ADDRESS...ENCSTR and USERNAME|PASSWORD
    NSString *iEnduraServerAddress = [IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_ADDRESS_KEY];
                               
    NSString *usrPass = [NSString stringWithFormat:@"%@|%@", username, password];
    NSString *encStr = [StringEncryption EncryptString:usrPass];
    APP_DELEGATE.encryptedUsrPassString = encStr;
    
    NSString *urlStr = [NSString stringWithFormat:authUrlFormat, iEnduraServerAddress, encStr];
    NSURL *authUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];

    NSLog(@"Auth Url 1: %@", authUrl);
    return authUrl;
}

+ (NSURL *)GetAuthenticationUrlFromUsrPass
{
    NSString *authUrlFormat = @"https://%@/iservice/i/e/auth/%@"; //...SERVER_ADDRESS...ENCSTR and USR_PASS_ENC_STR
    NSString *iEnduraServerAddress = [IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_ADDRESS_KEY];
    NSString *usrPassEncStr = [IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_USRPASS_KEY];
    NSString *urlStr = [NSString stringWithFormat:authUrlFormat, iEnduraServerAddress, usrPassEncStr];
    NSURL *authUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    NSLog(@"Auth Url 2: %@", authUrl);
    return authUrl;
}

+ (NSURL *)GetCamListUrl
{
    NSString *camListUrlFormat = @"https://%@/iservice/i/e/cams/%@"; //...SERVER_ADDRESS...ENCSTR and SESSION_ID
    NSString *iEnduraServerAddress = [IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_ADDRESS_KEY];
    NSString *encStr = [StringEncryption EncryptString:APP_DELEGATE.userSeesionId];
    NSString *urlStr = [NSString stringWithFormat:camListUrlFormat, iEnduraServerAddress, encStr];
    NSURL *camsUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    NSLog(@"Cam List Url: %@", camsUrl);
    return camsUrl;
}

+ (NSURL *)GetCamImgUrl:(NSString *)IP
{
    NSString *camImgUrlFormat = @"https://%@/iservice/i/e/img/%@"; //...SERVER_ADDRESS...ENCSTR and USERNAME|SESSION_ID|CAMERA_IP
    NSString *userName = [IEHelperMethods getUserDefaultSettingsString:IENDURA_USERNAME_KEY];
    NSString *iEnduraServerAddress = [IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_ADDRESS_KEY];
    NSString *encStr = [StringEncryption EncryptString:[NSString stringWithFormat:@"%@|%@|%@", userName, APP_DELEGATE.userSeesionId, IP]];
    NSString *urlStr = [NSString stringWithFormat:camImgUrlFormat, iEnduraServerAddress, encStr];
    NSURL *camImgUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    return camImgUrl;
}

+ (NSURL *)GetCamHlsReqUrl:(NSString *)IP
{
    NSString *camHlsReqUrlFormat = @"https://%@/iservice/i/e/hls/%@"; //...SERVER_ADDRESS...ENCSTR and USERNAME|SESSION_ID|CAMERA_IP
    NSString *userName = [IEHelperMethods getUserDefaultSettingsString:IENDURA_USERNAME_KEY];
    NSString *iEnduraServerAddress = [IEHelperMethods getUserDefaultSettingsString:IENDURA_SERVER_ADDRESS_KEY];
    NSString *encStr = [StringEncryption EncryptString:[NSString stringWithFormat:@"%@|%@|%@", userName, APP_DELEGATE.userSeesionId, IP]];
    NSString *urlStr = [NSString stringWithFormat:camHlsReqUrlFormat, iEnduraServerAddress, encStr];
    NSURL *camHlsReqUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    return camHlsReqUrl;
}

@end
