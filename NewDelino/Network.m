//
//  Network.m
//  Karbin
//
//  Created by Sohail on 5/2/16.
//  Copyright © 2016 Sohail. All rights reserved.
//

#import "Network.h"
#import "Reachability.h"
@implementation Network
@synthesize serverURL;

#pragma mark constructor
- (id)initWithURL:(NSString *)URLPath withProt :(NSString *)port
{
    self = [super init];
    if (self)
    {
        self.serverURL = [NSString stringWithFormat:@"%@:%@/" , URLPath , port];
    }
    return self;
}



#pragma mark call webservice
-(void)callPOSTWebServiceWithPath:(NSString *)path AndWithParameters:(id)parameters withCallback:(PostRequestCompletionBlock)callback failure:(IsConnectCompletionBlock)failure
{
    __block NSDictionary* response = [[NSDictionary alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        response = responseObject;
        callback(response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(YES);
    }];
    
}
-(void)callGETWebServiceWithPath:(NSString *)path withCallback:(GetRequestCompletionBlock)callback failure:(IsConnectCompletionBlock)failure{
    
    __block NSDictionary* response =[[NSDictionary alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        response = responseObject;
        //connect(YES);
        response = responseObject;
        callback(response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(YES);

    }];
    
}

-(void)callPUTWebServiceWithPath:(NSString *)path AndWithParameters:(id)parameters withCallback:(PostRequestCompletionBlock)callback failure:(IsConnectCompletionBlock)failure
{
    
    __block NSDictionary* response = [[NSDictionary alloc]init];
    AFHTTPSessionManager *manager;
//    NSDictionary *parameters = @{@"read": @true};
    
    [manager PUT:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        response = responseObject;
        callback(response);

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
        failure(YES);
        
    }];
    
    
    
    
    /*__block NSDictionary* response = [[NSDictionary alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager PUT:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"%@",responseObject);
        response = responseObject;
        callback(response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(YES);
    }];*/
}


+ (BOOL)connected {
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable)
    {
//        NSLog(@"connection unavailable");
        return NO;
        
    } else {
//        NSLog(@"connection available");
        return YES;
    }
}
@end
