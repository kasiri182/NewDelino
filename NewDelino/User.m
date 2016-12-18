//
//  User.m
//  RahnoHyper
//
//  Created by Mohammad on 10/25/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import "User.h"

@implementation User


-(NSString*)username {
    if (!_username) {
        _username = @"";
    }
    return _username;
}
-(NSString*)name {
    if (!_name) {
        _name = @"";
    }
    return _name;
}
-(NSString*)lastname {
    if (!_lastname) {
        _lastname = @"";
    }
    return _lastname;
}
-(NSString*)token {
    if (!_token) {
        _token = @"";
    }
    return _token;
}


@end
