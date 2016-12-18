//
//  DBData.m
//  Karbin
//
//  Created by Sohail on 5/25/16.
//  Copyright © 2016 Sohail. All rights reserved.
//

#import "Items.h"

@implementation Items
- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSString*)comment_item {
    if (!_comment_item) {
        _comment_item = @"";
    }
    return _comment_item;
}
-(NSInteger)number_item {
    if (!_number_item) {
        _number_item = 0;
    }
    return _number_item;
}




@end
