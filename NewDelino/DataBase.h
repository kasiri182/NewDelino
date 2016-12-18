//
//  DataBase.h
//  Karbin
//
//  Created by Sohail on 5/14/16.
//  Copyright © 2016 Sohail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Items.h"
#import "User.h"

@interface DataBase : NSObject
{
    sqlite3 *myDataBase;
}
@property(nonatomic , strong) Items *object;
@property(nonatomic , strong) User *user;

- (void)checkDataBase;
- (NSMutableArray*)getCategoryByParent:(NSString*)parentId;
- (NSMutableArray*)getCategoryByCategoryID:(NSString*)parentId;
- (BOOL) UserExistOrNot;

- (BOOL)ItemExistOrNot:(NSInteger)ID;
- (void)insertItemToOrderList:(Items*)item;
- (void)insertUser:(User*)user;

- (NSInteger)getCountItems:(NSInteger)itemId;
- (User*)getProfileInfo;
- (void)updateItemsNumber:(Items*)item;
- (NSMutableArray*)getCartItems;
- (void)deleteItems:(Items*)item;
- (void)deleteAllOrderedItems;
- (NSMutableArray*)searchFilterJob:(NSString*)text;
@end
