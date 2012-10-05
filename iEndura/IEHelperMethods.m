//
//  IEHelperMethods.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 24 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEHelperMethods.h"

@implementation IEHelperMethods

+ (void)setUserDefaultSettings
{
    //NSString *selectedTheme = APP_DELEGATE.self;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //[prefs setObject:selectedTheme forKey:@"objectKey"];
    [prefs synchronize];
}

+ (NSString *)getUserDefaultSettingsString:(NSString *)objectKey
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    return [prefs objectForKey:objectKey];
}

+ (BOOL)setUserDefaultSettingsString:(NSString *)objectValue key:(NSString *)objectKey
{
    if([objectValue isEqualToString:@""] || [allTrim( objectValue ) length] == 0
       || [objectKey isEqualToString:@""] || [allTrim( objectKey ) length] == 0)
    {
        return NO;
    }
    else
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:objectValue forKey:objectKey];
        return [prefs synchronize];
    }
}

+ (void)resetUserDefaultSettings
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:IENDURA_SERVER_ADDRESS_KEY];
    [prefs removeObjectForKey:IENDURA_USERNAME_KEY];
    [prefs removeObjectForKey:IENDURA_PASSWORD_KEY];
    [prefs removeObjectForKey:IENDURA_SERVER_USRPASS_KEY];
    [prefs removeObjectForKey:APP_REQUIRES_INIT_KEY];
    APP_DELEGATE.userSeesionId = @"";
    [prefs synchronize];
}

+ (BOOL)setUserDefaultSettingsObject:(NSObject *)objectValue key:(NSString *)objectKey
{
    if(objectValue == nil)
    {
        return NO;
    }
    else
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:objectValue forKey:objectKey];
        return [prefs synchronize];
    }
}

+ (NSArray *)getUserDefaultSettingsArray:(NSString *)objectKey
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:objectKey];
}

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *retStr = [NSString stringWithFormat:@"%@", string];
    return retStr;
}

+ (NSString *)ConvertJsonStringToNormalString:(NSString *)jsonString
{
    if(jsonString == nil)
        return nil;
    jsonString = [jsonString substringWithRange:NSMakeRange(1, jsonString.length - 2)];
    return  [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""]; //url friendly
}

+ (NSArray *)getExtractedDataFromJSONArray:(NSData *)data
{
    if(data == nil)
        return nil;
    NSError* error;
    NSArray *jsArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return jsArray;
}

+ (NSDictionary *)getExtractedDataFromJSONItem:(NSData *)data
{
    if(data == nil)
        return nil;
    NSError* error;
    NSDictionary *jsDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return jsDict;
}

+ (UIColor *)getColorFromRGB:(unsigned int)r blue:(unsigned int)b green:(unsigned int)g {
    return [UIColor colorWithRed:((float)r)/255.0
                           green:((float)g)/255.0
                            blue:((float)b)/255.0
                           alpha:1.0];
}


+ (UIColor *)getColorFromRGBColorCode:(NSString *)colorCode
{
    NSString *r_s = [colorCode substringWithRange:NSMakeRange(0,2)];
    NSString *g_s = [colorCode substringWithRange:NSMakeRange(2,2)];
    NSString *b_s = [colorCode substringWithRange:NSMakeRange(4,2)];
    
    unsigned r= 0;
    unsigned g= 0;
    unsigned b= 0;
    
    NSScanner *s_r = [NSScanner scannerWithString:r_s];
    NSScanner *s_g = [NSScanner scannerWithString:g_s];
    NSScanner *s_b = [NSScanner scannerWithString:b_s];
    
    [s_r scanHexInt:&r];
    [s_g scanHexInt:&g];
    [s_b scanHexInt:&b];
    
    return [UIColor colorWithRed:(r)/255.0
                           green:(g)/255.0
                            blue:(b)/255.0
                           alpha:1.0];
}

@end
