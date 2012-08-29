//
//  SimpleClass.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 26 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleClass : NSObject
{
    NSString *Id;   
    NSString *Value;     
}

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Value;

- (id) initWithDictionary:(NSDictionary *)jsDict;

@end
