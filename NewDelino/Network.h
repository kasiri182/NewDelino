//
//  Network.h
//  Karbin
//
//  Created by Sohail on 5/2/16.
//  Copyright © 2016 Sohail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface Network : NSObject

@property NSString* serverURL;
typedef void (^IsConnectCompletionBlock)(BOOL isConnect);
typedef void (^GetRequestCompletionBlock)(id result);
typedef void (^PostRequestCompletionBlock)(id result);

#pragma mark constructor

- (id)initWithURL:(NSString *)URLPath withProt :(NSString *)port;


#pragma mark call webservice

-(void)callPOSTWebServiceWithPath:(NSString *)path AndWithParameters:(id)parameters withCallback:(PostRequestCompletionBlock)callback  failure:(IsConnectCompletionBlock)failure;

-(void)callGETWebServiceWithPath:(NSString *)path withCallback:(GetRequestCompletionBlock)callback failure:(IsConnectCompletionBlock)failure;

-(void)callPUTWebServiceWithPath:(NSString *)path AndWithParameters:(id)parameters withCallback:(PostRequestCompletionBlock)callback failure:(IsConnectCompletionBlock)failure;

#pragma mark check network connection
+ (BOOL)connected;
@end
