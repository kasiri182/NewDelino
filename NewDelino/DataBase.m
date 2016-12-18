//
//  DataBase.m
//  Karbin
//
//  Created by Sohail on 5/14/16.
//  Copyright © 2016 Sohail. All rights reserved.
//

#import "DataBase.h"
#import "PublicMethods.h"


#define DataName @"RahnoDB.db"
@implementation DataBase
//inintial
- (id)init {
    self = [super init];
    if (self)
    {
        self.object = [[Items alloc]init];
        self.user = [[User alloc]init];
    }
    return self;
}
#pragma mark Check Database

- (NSString*)DatabasePath {
    NSArray *Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *DocumentDir = [Paths objectAtIndex:0];
    NSLog(@"%@",DocumentDir);
    return [DocumentDir stringByAppendingPathComponent:DataName];
}
- (void)checkDataBase {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // [fileManager removeItemAtPath:[self DatabasePath] error:nil];
    success = [fileManager fileExistsAtPath:[self DatabasePath]];
    NSString *FileDB = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:DataName];
    if (success) {
        NSLog(@"File Exist");
        return;
    } else {
        [fileManager copyItemAtPath:FileDB toPath:[self DatabasePath] error:nil];
        
        NSLog(@"Data Base Copied!!!");
    }
}

-(BOOL) UserExistOrNot {
    BOOL recordExist=NO;
    if(sqlite3_open([[self DatabasePath] UTF8String], &myDataBase) == SQLITE_OK)
    {
        NSString *existQuery =[NSString stringWithFormat:@"SELECT * FROM Profile"];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(myDataBase, [existQuery UTF8String], -1, &statement, nil)==SQLITE_OK)
        {
            if (sqlite3_step(statement)==SQLITE_ROW)
            {
                recordExist=YES;
            }
            else
            {
                //////NSLog(@"%s,",sqlite3_errmsg(database));
            }
            sqlite3_finalize(statement);
            sqlite3_close(myDataBase);
        }
    }
    return recordExist;
}
-(BOOL)ItemExistOrNot:(NSInteger)ID{
    BOOL recordExist=NO;
    if(sqlite3_open([[self DatabasePath] UTF8String], &myDataBase) == SQLITE_OK)
    {
        NSString *existQuery =[NSString stringWithFormat:@"SELECT * FROM Cart WHERE itemId = %ld",(long)ID];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(myDataBase, [existQuery UTF8String], -1, &statement, nil)==SQLITE_OK)
        {
            if (sqlite3_step(statement)==SQLITE_ROW)
            {
                recordExist=YES;
            }
            else
            {
                //////NSLog(@"%s,",sqlite3_errmsg(database));
            }
            sqlite3_finalize(statement);
            sqlite3_close(myDataBase);
        }
    }
    return recordExist;
}


#pragma mark - Get
-(NSMutableArray*)getCategoryByParent:(NSString*)parentId
{
    NSMutableArray *data = [[NSMutableArray alloc]init];
    if (sqlite3_open([[self DatabasePath] UTF8String], &myDataBase) == SQLITE_OK) {
        NSString *sqlStatement =[NSString stringWithFormat:@"SELECT * FROM 'Category' WHERE parent = '%@'",parentId];
        NSLog(@"%@",sqlStatement);
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(myDataBase, [sqlStatement UTF8String], -1, &statement, NULL) == SQLITE_OK ) {
            
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                NSString *idd = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString *title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *parent = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:idd,@"id",title,@"title",parent,@"parent", nil];
                [data addObject:dict];
                
            }
        }
        else {
            //NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(Database) );
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(myDataBase);
    return data;
}
-(NSMutableArray*)searchFilterJob:(NSString*)text {
    
    NSMutableArray *data = [[NSMutableArray alloc]init];
    // Setup the database object
    sqlite3 *database;
    // Open the database from the users filessytem
    if(sqlite3_open([[self DatabasePath] UTF8String], &database) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"SELECT Item.id,Item.name,Item.price,Item.categoryParent,Item.image,Cart.num,Cart.comment FROM Item LEFT OUTER JOIN Cart ON Item.id = Cart.itemId WHERE name LIKE '%%%@%%' ",text];
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                self.object = [[Items alloc]init];
                self.object.id_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                self.object.name_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                self.object.price_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                self.object.catParent_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                self.object.image_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                if((char*)sqlite3_column_text(statement, 5) != NULL) {
                    self.object.number_item = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] integerValue];
                } else {
                    self.object.number_item = 0;
                }
                if((char*)sqlite3_column_text(statement, 6) != NULL) {
                    self.object.comment_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                } else {
                    self.object.comment_item = @"";
                }
                
                [data addObject:self.object];
            }
        }
        else
        {
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return data;
    
    
}
-(NSMutableArray*)getCategoryByCategoryID:(NSString*)parentId
{
    NSMutableArray *data = [[NSMutableArray alloc]init];
    if (sqlite3_open([[self DatabasePath] UTF8String], &myDataBase) == SQLITE_OK) {
        NSString *sqlStatement =[NSString stringWithFormat:@"SELECT Item.id,Item.name,Item.price,Item.categoryParent,Item.image,Cart.num,Cart.comment FROM Item LEFT OUTER JOIN Cart ON Item.id = Cart.itemId WHERE categoryParent = '%@' ",parentId];
        NSLog(@"%@",sqlStatement);
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(myDataBase, [sqlStatement UTF8String], -1, &statement, NULL) == SQLITE_OK ) {
            
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                self.object = [[Items alloc]init];
                self.object.id_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                self.object.name_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                self.object.price_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                self.object.catParent_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                self.object.image_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                if((char*)sqlite3_column_text(statement, 5) != NULL) {
                    self.object.number_item = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] integerValue];
                } else {
                    self.object.number_item = 0;
                }
                if((char*)sqlite3_column_text(statement, 6) != NULL) {
                    self.object.comment_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                } else {
                    self.object.comment_item = @"";
                }

                [data addObject:self.object];
                
            }
        }
        else {
            //NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(Database) );
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(myDataBase);
    return data;
}

-(NSInteger)getCountItems:(NSInteger)itemId
{
    NSInteger Count;
    if (sqlite3_open([[self DatabasePath] UTF8String], &myDataBase) == SQLITE_OK) {
        NSString *sqlStatement =[NSString stringWithFormat:@"SELECT num FROM 'Cart' WHERE itemId = '%ld'",(long)itemId];
        NSLog(@"%@",sqlStatement);
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(myDataBase, [sqlStatement UTF8String], -1, &statement, NULL) == SQLITE_OK ) {
            
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                Count = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] integerValue];
            }
        }
        else {
            //NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(Database) );
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(myDataBase);
    return Count;
}

-(NSMutableArray*)getCartItems
{
    NSMutableArray *data = [[NSMutableArray alloc]init];
    if (sqlite3_open([[self DatabasePath] UTF8String], &myDataBase) == SQLITE_OK) {
        NSString *sqlStatement =[NSString stringWithFormat:@"SELECT Cart.itemId,Item.name,Item.price,Item.categoryParent,Item.image,Cart.num,Cart.comment FROM Item INNER JOIN Cart ON Item.id = Cart.itemId"];
        NSLog(@"%@",sqlStatement);
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(myDataBase, [sqlStatement UTF8String], -1, &statement, NULL) == SQLITE_OK ) {
            
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                self.object = [[Items alloc]init];
                self.object.id_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                self.object.name_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                self.object.price_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                self.object.catParent_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                self.object.image_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                if((char*)sqlite3_column_text(statement, 5) != NULL) {
                    self.object.number_item = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] integerValue];
                } else {
                    self.object.number_item = 0;
                }
                if((char*)sqlite3_column_text(statement, 6) != NULL) {
                    self.object.comment_item = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                } else {
                    self.object.comment_item = @"";
                }
                
                [data addObject:self.object];
                
            }
        }
        else {
            //NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(Database) );
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(myDataBase);
    return data;
}


- (User*)getProfileInfo
{
    User *user = [[User alloc]init];

    if (sqlite3_open([[self DatabasePath] UTF8String], &myDataBase) == SQLITE_OK) {
        NSString *sqlStatement =[NSString stringWithFormat:@"SELECT * FROM Profile"];
        NSLog(@"%@",sqlStatement);
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(myDataBase, [sqlStatement UTF8String], -1, &statement, NULL) == SQLITE_OK ) {
            
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                
                if((char*)sqlite3_column_text(statement, 1) != NULL) {
                    user.username = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                }
                if((char*)sqlite3_column_text(statement, 2) != NULL) {
                    user.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                }
                if((char*)sqlite3_column_text(statement, 3) != NULL) {
                    user.lastname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                }
                if((char*)sqlite3_column_text(statement, 4) != NULL) {
                    user.token = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                }
                
            }
        }
        else {
            //NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(Database) );
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(myDataBase);
    return user;
}



#pragma mark - Insert
- (void)insertItemToOrderList:(Items*)item {
    
    sqlite3_stmt *statement;
    if(sqlite3_open([[self DatabasePath] UTF8String], &myDataBase) == SQLITE_OK) {
        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO Cart ('itemId','num','comment') values ('%@','%ld','%@')",item.id_item,(long)item.number_item,item.comment_item];
        NSLog(@"%@",query);
        if (sqlite3_prepare_v2(myDataBase, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) != SQLITE_DONE)
            {
                sqlite3_finalize(statement);
            }
        }
        else{
            NSLog(@"query Statement Not Compiled");
            NSLog(@"Prepare-error: %s", sqlite3_errmsg(myDataBase));
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(myDataBase);
    
}


- (void)insertUser:(User*)user {
    
    sqlite3_stmt *statement;
    if(sqlite3_open([[self DatabasePath] UTF8String], &myDataBase) == SQLITE_OK) {
        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO Profile ('username','name','lastname','token') values ('%@','%@','%@','%@')",user.username,user.name,user.lastname,user.token];
        NSLog(@"%@",query);
        if (sqlite3_prepare_v2(myDataBase, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) != SQLITE_DONE)
            {
                sqlite3_finalize(statement);
            }
        }
        else{
            NSLog(@"query Statement Not Compiled");
            NSLog(@"Prepare-error: %s", sqlite3_errmsg(myDataBase));
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(myDataBase);
    
}



#pragma mark Update
-(void)updateItemsNumber:(Items*)item
{
    sqlite3_stmt *statement;
    if(sqlite3_open([[self DatabasePath] UTF8String], &myDataBase) == SQLITE_OK) {
        NSString *query = [NSString stringWithFormat:@"UPDATE Cart SET num = '%ld' WHERE itemId = '%@'" ,(long)item.number_item,item.id_item];
        
        NSLog(@"%@",query);
        if (sqlite3_prepare_v2(myDataBase, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) != SQLITE_DONE)
            {
                sqlite3_finalize(statement);
            }
        }
        else{
            NSLog(@"%@" , statement);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(myDataBase);
    
}

#pragma mark Delete
- (void)deleteItems:(Items*)item{
    NSString *query = [NSString stringWithFormat:@"DELETE FROM 'Cart' WHERE itemId = %@",item.id_item];
    const char *sql = [query UTF8String];
    sqlite3 *database;
    if(sqlite3_open([[self DatabasePath] UTF8String], &database) == SQLITE_OK)
    {
        sqlite3_stmt *deleteStmt;
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(deleteStmt) != SQLITE_DONE )
            {
                NSLog( @"Error: %s", sqlite3_errmsg(database) );
            }
            else
            {
                NSLog(@"No Error");
            }
        }
        sqlite3_finalize(deleteStmt);
    }
    sqlite3_close(database);
}

- (void)deleteAllOrderedItems {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM 'Cart'"];
    const char *sql = [query UTF8String];
    sqlite3 *database;
    if(sqlite3_open([[self DatabasePath] UTF8String], &database) == SQLITE_OK)
    {
        sqlite3_stmt *deleteStmt;
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(deleteStmt) != SQLITE_DONE )
            {
                NSLog( @"Error: %s", sqlite3_errmsg(database) );
            }
            else
            {
                NSLog(@"No Error");
            }
        }
        sqlite3_finalize(deleteStmt);
    }
    sqlite3_close(database);
}

@end
