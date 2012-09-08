//
//  IEServiceManager.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 6 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IEServiceManager : NSObject

+ (NSURL *)GetAuthenticationUrl:(NSString *)username :(NSString *)password;
+ (NSURL *)GetAuthenticationUrlFromUsrPass;
+ (NSURL *)GetCamListUrl;
+ (NSURL *)GetCamImgUrl:(NSString *)IP;
+ (NSURL *)GetCamHlsReqUrl:(NSString *)IP;

@end
