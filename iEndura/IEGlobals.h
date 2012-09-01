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
#define IENDURA_DISPATCH_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define IENDURA_AUTH_URL_FORMAT @"https://service.iendura.com/iservice/i/e/auth/%@"
#define IENDURA_CAM_LIST_URL_FORMAT @"https://service.iendura.com/iservice/i/e/cams/%@"
#define IENDURA_ENC_URL_FORMAT @"https://service.iendura.com/iservice/i/e/%@"

#define ENC_KEY @"ju4ev@D++agatuc4"
#define IENDURA_DATABASE_FILE @"iEnduraDB.sqlite"

#define IENDURA_SERVER_ADDRESS_KEY @"IENDURA_SERVER"
#define IENDURA_SERVER_USRPASS_KEY @"IENDURA_SERVER_USRPASS"

#define allTrim(object) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

#define SUCCESS_VALUE @"1"
