//
//  IEEnums.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 28 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

@interface IEEnums : NSObject

typedef enum IEReqTypes { IE_Req_Auth, IE_Req_CamImage, IE_Req_CamList } iEnduraRequestTypes;
typedef enum IECamLocTypes { IE_Cam_Loc_Remote, IE_Cam_Loc_Root, IE_Cam_Loc_Child} iEnduraCameraLocationTypes;

@end
