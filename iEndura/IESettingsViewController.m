//
//  IESettingsViewController.m
//  iEndura
//
//  Created by Candan BÖLÜKBAŞ on 28 Aug.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IESettingsViewController.h"

@interface IESettingsViewController ()

@end

@implementation IESettingsViewController
@synthesize serviceUrlTextField;
@synthesize resultLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //CrudOp *dbCrud = [[CrudOp alloc] init];
    //[dbCrud CopyDbToDocumentsFolder];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setServiceUrlTextField:nil];
    [self setResultLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)saveButtonClicked:(UIButton *)sender 
{
    if ([IEHelperMethods setUserDefaultSettingsString:serviceUrlTextField.text key:IENDURA_SERVER_ADDRESS_KEY]) 
    {
        [self dismissModalViewControllerAnimated:YES];
    };
    
    //CrudOp *dbCrud = [[CrudOp alloc] init];
    //[dbCrud InsertRecords:@"test2"];
    
    /*NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
    BOOL success = [fileMgr fileExistsAtPath:dbPath];*/
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0];
//    NSString *dbPath = [documentsPath stringByAppendingPathComponent:IENDURA_DATABASE_FILE];
//    BOOL success = [fileMgr fileExistsAtPath:dbPath];
//    
//    if(!success)
//    {
//        NSLog(@"Cannot locate database file '%@'.", dbPath);
//    }
//
//    if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
//    {
//        NSLog(@"An error has occured.");
//    }
//    const char *sql = "SELECT * FROM Cameras";
//    sqlite3_stmt *sqlStatement;
//    if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
//    {
//        NSLog(@"Problem with prepare statement");
//    }
//    
//    while (sqlite3_step(sqlStatement)==SQLITE_ROW) 
//    {
//        //NSString *sampleStr = sqlite3_column_int(sqlStatement, 0);
//        NSString *ipAddress = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
//        NSLog(@"IP address: %@", ipAddress);
//    }
    
        
    
    /*//insert
     sqlite3_stmt *stmt = nil;
    const char *sqlInsert = "INSERT INTO todo VALUES('2', 'asdf', '2', 'false')";
    
    //Open db
    sqlite3_open([dbPath UTF8String], &db);
    sqlite3_prepare_v2(db, sqlInsert, 1, &stmt, NULL);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(db); */
    
}

@end






