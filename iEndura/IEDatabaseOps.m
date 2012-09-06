//
//  IEDatabaseOps.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 31 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEDatabaseOps.h"
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

-(BOOL)DBExistsInDocumentsFolder
{
    fileMgr = [NSFileManager defaultManager];
    NSString *dbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:IENDURA_DATABASE_FILE]; 
    return [fileMgr fileExistsAtPath:dbpath];
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
//            NSLog(@"Error: %@", err);
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

-(BOOL) InsertBulkCameras:(NSArray *)Cameras :(BOOL)overwrite
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
            const char *query_stmt = [@"DELETE FROM Cameras" UTF8String];
            char *err = NULL;
            if (sqlite3_exec(database, query_stmt, NULL, NULL, &err) == SQLITE_OK)
            {
                result = result & YES;
            } else 
            {
                NSLog(@"Error deleting from Cameras table.");
                return NO;
            }
        }
        
        for (IECameraClass *cc in Cameras) 
        {
            const char *query_stmt = [cc.generateSQLInsertString UTF8String];
            char *err = NULL;
            if (sqlite3_exec(database, query_stmt, NULL, NULL, &err) == SQLITE_OK)
            {
                result = result & YES;
            } else 
            {
//                NSLog(@"Error: %@", err);
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

- (IECameraClass *)ParseSQLiteRowToCameraClass:(sqlite3_stmt *)compiledStatement
{
    IECameraClass *cc = [[IECameraClass alloc] init];
    
    //read the data from the result row
    cc.uuid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
    cc.IP = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
    cc.Name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
    cc.CameraType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
    cc.UpnpModelNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
    cc.RTSP_URL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
    cc.RemoteLocation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
    cc.LocationRoot = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
    cc.LocationChild = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
    cc.VLCTranscode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
    cc.SMsIPAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
    cc.NSMIPAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
    cc.Port = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
    
    return cc;
}

-(NSArray *) GetCameraList
{
    //Setup the database object
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
    
    NSMutableArray *cameras = [[NSMutableArray alloc] init];
    
    //Open the database from the users filesystem
    if (sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) 
    {
        //setup the SQL statement and compile it for faster access
        const char *sqlStatement = "select * from Cameras";
        sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
        {
            //loop through the results and add them to the feeds array
            while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                IECameraClass *cc = [self ParseSQLiteRowToCameraClass:compiledStatement];
                [cameras addObject:cc];
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
        const char *sqlStatement = "SELECT RemoteLocation, COUNT (*) as NumberOfCameras FROM Cameras GROUP BY RemoteLocation ORDER BY RemoteLocation";
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


-(NSArray *) GetItemsOfALocation:(IECameraLocation *)location
{
    //Setup the database object
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
    
    //Init the restaurant array
    NSMutableArray *LocOrCamItems = [[NSMutableArray alloc] init];
    
    //Open the database from the users filesystem
    if (sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) 
    {
        if (location.LocationType == IE_Cam_Loc_Child)
        {
            NSString *sqlStrFormat = @"SELECT * FROM Cameras WHERE RemoteLocation = '%@' AND LocationRoot = '%@' AND LocationChild = '%@'";
            NSString *sqlStr = [NSString stringWithFormat:sqlStrFormat, location.RemoteLocation, location.LocationRoot, location.LocationChild];
            
            const char *sqlStatement = [sqlStr UTF8String];
            sqlite3_stmt *compiledStatement;
            
            //NSMutableArray *cameras = [[NSMutableArray alloc] init];
            
            if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
            {
                //loop through the results and add them to the feeds array
                while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
                {
                    IECameraClass *cc = [self ParseSQLiteRowToCameraClass:compiledStatement];
                    [LocOrCamItems addObject:cc];
                }
            }
            sqlite3_finalize(compiledStatement);
        }
        else //Either RemoteLocation or root Location. Both may have Location items an camera items.
        {
            if(location.LocationType == IE_Cam_Loc_Remote) //get root locations and cams of this remote location
            {
                {
                    NSString *sqlStrFormatRootLocs = @"SELECT LocationRoot, COUNT (*) as NumberOfCameras FROM Cameras WHERE RemoteLocation = '%@' AND LocationRoot <> '' GROUP BY LocationRoot ORDER BY LocationRoot";
                    NSString *sqlStr = [NSString stringWithFormat:sqlStrFormatRootLocs, location.RemoteLocation];
                    
                    const char *sqlStatement = [sqlStr UTF8String];
                    sqlite3_stmt *compiledStatement;
                    
                    //NSMutableArray *cameras = [[NSMutableArray alloc] init];
                    
                    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
                    {
                        //loop through the results and add them to the feeds array
                        while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
                        {
                            IECameraLocation *cl = [[IECameraLocation alloc] init];
                            
                            cl.LocationType = IE_Cam_Loc_Root;
                            
                            //read the data from the result row
                            cl.LocationRoot = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                            cl.NumberOfCameras = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                            
                            //add the camera object to the cameras array
                            [LocOrCamItems addObject:cl];
                        }
                    }
                    sqlite3_finalize(compiledStatement);
                }
                {
                    NSString *sqlStrFormat = @"SELECT * FROM Cameras WHERE RemoteLocation = '%@' AND LocationRoot = '' AND LocationChild = '';";
                    NSString *sqlStr = [NSString stringWithFormat:sqlStrFormat, location.RemoteLocation];
                    
                    const char *sqlStatement = [sqlStr UTF8String];
                    sqlite3_stmt *compiledStatement;
                    
                    //NSMutableArray *cameras = [[NSMutableArray alloc] init];
                    
                    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
                    {
                        //loop through the results and add them to the feeds array
                        while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
                        {
                            IECameraClass *cc = [self ParseSQLiteRowToCameraClass:compiledStatement];
                            [LocOrCamItems addObject:cc];
                        }
                    }
                    sqlite3_finalize(compiledStatement);
                }
                
            }
            else if(location.LocationType == IE_Cam_Loc_Root) //get root locations and cams of this remote location
            {
                {
                    NSString *sqlStrFormatRootLocs = @"SELECT LocationChild, COUNT (*) as NumberOfCameras FROM Cameras WHERE RemoteLocation = '%@' AND LocationRoot = '%@' AND LocationChild <> '' GROUP BY LocationChild ORDER BY LocationChild";
                    NSString *sqlStr = [NSString stringWithFormat:sqlStrFormatRootLocs, location.RemoteLocation, location.LocationRoot];
                    
                    const char *sqlStatement = [sqlStr UTF8String];
                    sqlite3_stmt *compiledStatement;
                    
                    //NSMutableArray *cameras = [[NSMutableArray alloc] init];
                    
                    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
                    {
                        //loop through the results and add them to the feeds array
                        while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
                        {
                            IECameraLocation *cl = [[IECameraLocation alloc] init];
                            cl.LocationRoot = location.LocationRoot;
                            cl.LocationType = IE_Cam_Loc_Child;
                            
                            //read the data from the result row
                            cl.LocationChild = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                            cl.NumberOfCameras = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                            
                            //add the camera object to the cameras array
                            [LocOrCamItems addObject:cl];
                        }
                    }
                    sqlite3_finalize(compiledStatement);
                }
                {
                    NSString *sqlStrFormat = @"SELECT * FROM Cameras WHERE RemoteLocation = '%@' AND LocationRoot = '%@' AND LocationChild = ''";
                    NSString *sqlStr = [NSString stringWithFormat:sqlStrFormat, location.RemoteLocation, location.LocationRoot];
                    
                    const char *sqlStatement = [sqlStr UTF8String];
                    sqlite3_stmt *compiledStatement;
                    
                    //NSMutableArray *cameras = [[NSMutableArray alloc] init];
                    
                    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
                    {
                        //loop through the results and add them to the feeds array
                        while (sqlite3_step(compiledStatement) == SQLITE_ROW) 
                        {
                            IECameraClass *cc = [self ParseSQLiteRowToCameraClass:compiledStatement];
                            [LocOrCamItems addObject:cc];
                        }
                    }
                    sqlite3_finalize(compiledStatement);
                }
            }
        }
        sqlite3_close(database);
        return LocOrCamItems;
    }
    return nil;
}

@end










