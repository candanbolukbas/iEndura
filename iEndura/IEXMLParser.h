//
//  IEXMLParser.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 26 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

@class SimpleClass;

@interface IEXMLParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) SimpleClass *sc;

@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSMutableArray *scs;
@property (nonatomic, copy) NSMutableString *currentElementValue;

- (id) initWithURL:(NSString *)urlString;
- (id) initWithData:(NSData *)data;


@end
