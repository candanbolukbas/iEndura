//
//  IECrudOp.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 30 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IECrudOp.h"
@implementation CrudOp
@synthesize  coldbl;
@synthesize colint;
@synthesize coltext;
@synthesize dataId;
@synthesize fileMgr;
@synthesize homeDir;
@synthesize title;


-(NSString *)GetDocumentDirectory{
    fileMgr = [NSFileManager defaultManager];
    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return homeDir;
}

-(void)CopyDbToDocumentsFolder{
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

-(void)InsertRecords:(NSString *) txt{
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt;
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
    
    if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) 
    {
        //insert
        const char *sql = "INSERT INTO PelcoCameras (UUID, IP, Name, CameraType, UpnpModelNumber, RTSP_URL, RemoteLocation, LocationRoot, LocationChild, VLCTranscode, SMsIPAddress, NSMIPAddress, Port) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        //Open db
        //NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
        //sqlite3_open([cruddatabase UTF8String], &database);
        sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
        sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 2, [txt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 3, [txt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 4, [txt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 5, [txt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 6, [txt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 7, [txt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 8, [txt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 9, [txt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 10, [txt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 11, [txt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 12, [txt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 13, [txt UTF8String], -1, SQLITE_TRANSIENT);
        
        if(sqlite3_step(stmt) != SQLITE_DONE ) {
            NSLog( @"Error: %s", sqlite3_errmsg(database) );
        } else {
            NSLog( @"Insert into SQL_DONE");
        }
        
        //sqlite3_step(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(database); 
        //NSLog(@"stmt: %@", stmt);
    }
}

-(void)UpdateRecords:(NSString *)txt :(NSMutableString *)utxt{
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    
    
    //insert
    const char *sql = "Update data set coltext=? where coltext=?";
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
    sqlite3_open([cruddatabase UTF8String], &cruddb);
    sqlite3_prepare_v2(cruddb, sql, 1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [utxt UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);  
    
}
-(void)DeleteRecords:(NSString *)txt{
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    
    //insert
    const char *sql = "Delete from data where coltext=?";
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
    sqlite3_open([cruddatabase UTF8String], &cruddb);
    sqlite3_prepare_v2(cruddb, sql, 1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);  
    
}


@end