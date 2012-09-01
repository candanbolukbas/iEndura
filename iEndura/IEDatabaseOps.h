//
//  IEDatabaseOps.h
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 31 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IEDatabaseOps  : NSObject
{
    NSFileManager *fileMgr;
    NSString *homeDir;
    NSString *title;
}

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *homeDir;
@property (nonatomic,retain) NSFileManager *fileMgr;

-(void)CopyDbToDocumentsFolder;
-(NSString *) GetDocumentDirectory;

-(BOOL) ExecuteSqlStatementText:(NSString *)sqlTxt;
-(BOOL) InsertBulkPelcoCameras:(NSArray *)pelcoCameras :(BOOL)overwrite;
-(NSArray *) GetCameraList;
-(NSArray *) GetRemoteLocations;

@end
