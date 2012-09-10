//
//  IEGlobals.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 24 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEAppDelegate.h"

#define APP_DELEGATE ((IEAppDelegate *) [[UIApplication sharedApplication] delegate])

#define BACKGROUNG_COLOR_LIGHT_BLUE @"CEE7EF"
#define BACKGROUNG_COLOR_DARK_BLUE @"243960"
#define BACKGROUNG_COLOR_DARKER_BLUE @"1A2844"
#define IENDURA_DISPATCH_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

//#define IENDURA_AUTH_URL_FORMAT @"https://service.iendura.com/iservice/i/e/auth/%@" //USERNAME|PASSWORD
//#define IENDURA_CAM_LIST_URL_FORMAT @"https://service.iendura.com/iservice/i/e/cams/%@" //SESSION_ID
//#define IENDURA_CAM_IMG_URL_FORMAT @"https://service.iendura.com/iservice/i/e/img/%@" //USERNAME|SESSION_ID|CAMERA_IP
//#define IENDURA_CAM_HLS_START_URL_FORMAT @"https://service.iendura.com/iservice/i/e/hls/%@" //USERNAME|SESSION_ID|CAMERA_IP

#define ENC_KEY @"ju4ev@D++agatuc4"
#define IENDURA_DATABASE_FILE @"iEnduraDB.sqlite"

#define IENDURA_SERVER_ADDRESS_KEY @"IENDURA_SERVER"
#define IENDURA_SERVER_USRPASS_KEY @"IENDURA_SERVER_USRPASS"
#define IENDURA_USERNAME_KEY @"IENDURA_USERNAME"
#define IENDURA_PASSWORD_KEY @"IENDURA_PASSWORD"
#define APP_REQUIRES_INIT_KEY @"APP_REQUIRES_INIT" 
#define FAVORITE_CAMERAS_KEY @"FAVORITE_CAMERAS"
#define FAVORITE_CAMERAS_TITLE @"Favorite Cameras"

#define allTrim(object) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

#define POZITIVE_VALUE @"1"
#define NEGATIVE_VALUE @"0"
