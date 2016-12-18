//
//  DBData.h
//  Karbin
//
//  Created by Sohail on 5/25/16.
//  Copyright © 2016 Sohail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Items : NSObject
@property(nonatomic , strong) NSString* id_item;
@property(nonatomic , strong) NSString* name_item;
@property(nonatomic , strong) NSString* price_item;
@property(nonatomic , strong) NSString* catParent_item;
@property(nonatomic , strong) NSString* image_item;
@property(nonatomic , strong) NSString* subParent_item;
@property(nonatomic) NSInteger number_item;
@property(nonatomic , strong) NSString* comment_item;

@end
