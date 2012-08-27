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
#define IENDURA_DISPATCH_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define IENDURA_AUTH_URL [NSURL URLWithString: @"http://service.iendura.com/iservice/i/auth/admin/admin"]
#define IENDURA_AUTH_URL_FORMAT @"http://service.iendura.com/iservice/i/auth/%@/%@"
#define IENDURA_ENC_URL_FORMAT @"https://service.iendura.com/iservice/i/e/%@"