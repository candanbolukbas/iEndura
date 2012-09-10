//
//  IEHelperMethods.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 24 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEAppDelegate.h"

@interface IEHelperMethods : NSObject


+ (UIColor *)getColorFromRGB:(unsigned int)r blue:(unsigned int)b green:(unsigned int)g;
+ (UIColor *)getColorFromRGBColorCode:(NSString *)colorCode;
+ (void)setUserDefaultSettings;
+ (BOOL)setUserDefaultSettingsString:(NSString *)objectValue key:(NSString *)objectKey;
+ (NSString *)getUserDefaultSettingsString:(NSString *)objectKey;
+ (NSArray *)getExtractedDataFromJSONArray:(NSData *)data;
+ (NSDictionary *)getExtractedDataFromJSONItem:(NSData *)data;
+ (NSString *)GetUUID;
+ (NSString *)ConvertJsonStringToNormalString:(NSString *)jsonString;
+ (BOOL)setUserDefaultSettingsObject:(NSObject *)objectValue key:(NSString *)objectKey;
+ (NSArray *)getUserDefaultSettingsArray:(NSString *)objectKey;
+ (void)resetUserDefaultSettings;
@end
 