//
//  IEConnController.h
//  iEndura
//
//  Created by Metehan Karabiber on 8/28/12.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

@protocol IEConnControllerDelegate <NSObject>
- (void) finishedWithData:(NSData *)data forTag:(iEnduraRequestTypes)tag withObject:(NSObject *)additionalParameters;
@end

@interface IEConnController : NSObject <NSURLConnectionDelegate> {
@private
	iEnduraRequestTypes connTag;
	NSMutableData *resultData;
	NSMutableURLRequest *request;
    NSObject *addParams;
}

@property (nonatomic, strong) id <IEConnControllerDelegate> delegate;
@property (nonatomic,retain) NSObject *addParams;

- (id) initWithURL:(NSURL *)url property:(iEnduraRequestTypes)tag;
- (void) startConnection;
+ (void) testEnumFunc:(iEnduraRequestTypes)requestType;

@end
