//
//  IEDatabaseOps.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 31 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEDatabaseOps.h"
#import "IEPelcoCameraClass.h"
#import "IERemoteLocations.h"

@implementation IEDatabaseOps

@synthesize fileMgr, homeDir, title;


-(NSString *)GetDocumentDirectory
{
    fileMgr = [NSFileManager defaultManager];
    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return homeDir;
}

-(void)CopyDbToDocumentsFolder
{
    NSError *err=nil;
    
    fileMgr = [NSFileManager defaultManager];
    
    NSString *dbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:IENDURA_DATABASE_FILE]; 
    
    NSString *copydbpath = [self.GetDocumentDirectory stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
    
    [fileMgr removeItemAtPath:copydbpath error:&err];
    if(![fileMgr copyItemAtPath:dbpath toPath:copydbpath error:&err])
    {
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to copy database." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [tellErr show];
        
    }
    
}

-(BOOL) ExecuteSqlStatementText:(NSString *)sqlTxt
{
    fileMgr = [NSFileManager defaultManager];
    BOOL result = NO;
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
   
    const char *query_stmt = [sqlTxt UTF8String];
    
    if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) 
    {
        char *err = NULL;
        if (sqlite3_exec(database, query_stmt, NULL, NULL, &err) == SQLITE_OK)
        {
            result = YES;
        } else 
        {
            NSLog(@"Error: %@", err);
            result = NO;
        }
        
        sqlite3_close(database); 
    }
    else 
    {
        NSLog(@"Error: Can not open DB.");
        result = NO;
    }
    
    return result;
}

-(BOOL) InsertBulkPelcoCameras:(NSArray *)pelcoCameras :(BOOL)overwrite
{
    fileMgr = [NSFileManager defaultManager];
    BOOL result = YES;
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
    
    if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) 
    {
        if(overwrite)
        {
            const char *query_stmt = [@"DELETE FROM PelcoCameras" UTF8String];
            char *err = NULL;
            if (sqlite3_exec(database, query_stmt, NULL, NULL, &err) == SQLITE_OK)
            {
                result = result & YES;
            } else 
            {
                NSLog(@"Error: %@", err);
                return NO;
            }
        }
        
        for (IEPelcoCameraClass *pcc in pelcoCameras) 
        {
            const char *query_stmt = [pcc.generateSQLInsertString UTF8String];
            char *err = NULL;
            if (sqlite3_exec(database, query_stmt, NULL, NULL, &err) == SQLITE_OK)
            {
                result = result & YES;
            } else 
            {
                NSLog(@"Error: %@", err);
                result = result & NO;
            }
        }
        sqlite3_close(database); 
    }
    else 
    {
        NSLog(@"Error: Can not open DB.");
        result = NO;
    }
    
    return result;
}

-(NSArray *) GetCameraList
{
    //Setup the database object
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
    
    //Init the restaurant array
    NSMutableArray *cameras = [[NSMutableArray alloc] init];
    
    //Open the database from the users filesystem
    if (sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) 
    {
        //setup the SQL statement and compile it for faster access
        const char *sqlStatement = "select * from PelcoCameras";
        sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
        {
            //loop through the results and add them to the feeds array
            while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                IEPelcoCameraClass *pcc = [[IEPelcoCameraClass alloc] init];
                
                //read the data from the result row
                pcc.uuid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                pcc.IP = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                pcc.Name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                pcc.CameraType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                pcc.UpnpModelNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                pcc.RTSP_URL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                pcc.RemoteLocation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                pcc.LocationRoot = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                pcc.LocationChild = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                pcc.VLCTranscode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                pcc.SMsIPAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                pcc.NSMIPAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                pcc.Port = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                
                //add the camera object to the cameras array
                [cameras addObject:pcc];
            }
        }
        
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    return cameras;
}

-(NSArray *) GetRemoteLocations
{
    //Setup the database object
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
    
    //Init the restaurant array
    NSMutableArray *remoteLocations = [[NSMutableArray alloc] init];
    
    //Open the database from the users filesystem
    if (sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) 
    {
        //setup the SQL statement and compile it for faster access
        const char *sqlStatement = "SELECT RemoteLocation, COUNT (*) as NumberOfCameras FROM PelcoCameras GROUP BY RemoteLocation ORDER BY RemoteLocation";
        sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
        {
            //loop through the results and add them to the feeds array
            while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                IERemoteLocations *rl = [[IERemoteLocations alloc] init];
                
                //read the data from the result row
                rl.RemoteLocationName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                rl.NumberOfCameras = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                //add the camera object to the cameras array
                [remoteLocations addObject:rl];
            }
        }
        
        sqlite3_finalize(compiledStatement);
        sqlite3_close(database);
    }
    return remoteLocations;
}

@end
