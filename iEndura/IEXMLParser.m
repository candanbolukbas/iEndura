//
//  IEXMLParser.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 26 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEXMLParser.h"
#import "SimpleClass.h"

@implementation IEXMLParser

@synthesize sc, scs, xmlParser, currentElementValue;

- (id) initWithURL:(NSString *)urlString {
	self = [super init];

	scs = [NSMutableArray new];
	xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
	self.xmlParser.delegate = self;

	return self;
}

- (id) initWithData:(NSData *)data {
    self = [super init];
	
	scs = [NSMutableArray new];
	xmlParser = [[NSXMLParser alloc] initWithData:data];
    self.xmlParser.delegate = self;
	
	return self;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
                                     qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict 
{	
    if ([elementName isEqualToString:@"SimpleClass"]) {
        NSLog(@"simpleclass element found – create a new instance of SimpleClass class...");
        sc = [SimpleClass alloc];
        //We do not have any attributes in the user elements, but if
        // you do, you can extract them here: 
        // user.att = [[attributeDict objectForKey:@"<att name>"] ...];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentElementValue) {
        // init the ad hoc string with the value     
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        // append value to the ad hoc string    
        [currentElementValue appendString:string];
    }
    NSLog(@"Processing value for : %@", string);
} 

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
                                    namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{    
    
    if ([elementName isEqualToString:@"SimpleClass"]) {
        // We are done with SimpleClass entry – add the parsed SimpleClass 
        // object to our SimpleClass array
        [scs addObject:sc];
		sc = nil;
    }
	else if ([elementName isEqualToString:@"Id"]) {
		sc.Id = currentElementValue;
    }
	else if ([elementName isEqualToString:@"Value"]) {
		sc.Value = currentElementValue;
    }
    
	currentElementValue = nil;
}

@end
