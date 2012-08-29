//
//  SimpleClass.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 26 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "SimpleClass.h"

@implementation SimpleClass

@synthesize Id, Value;

- (id) initWithDictionary:(NSDictionary *)jsDict
{
    self = [super init];
    
    Id = [jsDict objectForKey:@"Id"];
    Value = [jsDict objectForKey:@"Value"];
    
    return self;
}

@end
