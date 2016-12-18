//
//  SplashViewController.m
//  Rahno
//
//  Created by Mohammad on 12/7/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import "SplashViewController.h"
#import "PublicMethods.h"
#import "Network.h"
#import "DataBase.h"
#import "User.h"
#import "VerifyViewController.h"
#import "TabbarViewController.h"
#import "Reachability.h"

@interface SplashViewController ()
@property (nonatomic,strong) Network *network;
@property (nonatomic,strong) DataBase *DB;
@property (nonatomic,strong) User *user;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.title = @"aaaa";

    self.network = [[Network alloc]init];
    self.DB = [[DataBase alloc]init];
    self.user = [[User alloc]init];
    
    [self appValidation:@"qlnv1bd23b0q"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToSignIn"]) {
        VerifyViewController *verify = [segue destinationViewController];
        NSLog(@"%@",verify);
        
    } else if ([segue.identifier isEqualToString:@"GoToTab"]) {
        TabbarViewController *tabbar = [segue destinationViewController];
        NSLog(@"%@",tabbar);
    }
}

#pragma mark WebService
- (void) tokenValidation:(NSString*)token {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSString *path = [NSString stringWithFormat:@"%@/%@/%@?token=%@",[PublicMethods getStrings:@"url"],[PublicMethods getStrings:@"version"],[PublicMethods getStrings:@"profile"],token];
        
        [self.network callGETWebServiceWithPath:path withCallback:^(NSDictionary *result)
         {
             NSLog(@"%@",result);
             
             if([[result objectForKey:@"res"] isEqualToString:@"success"]) {
                 
                 [self performSegueWithIdentifier:@"GoToTab" sender:self];
                 
             } else {
                 [self performSegueWithIdentifier:@"GoToSignIn" sender:self];
                 
             }
             
         } failure:^(BOOL failure) {
             
             if (failure) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"خطا" message:@"برقراری ارتباط امکان پذیر نمی باشد." delegate:nil cancelButtonTitle:@"تایید" otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];
        //end call webservice
    });
    
}
- (void) appValidation:(NSString*)token {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSString *path = [NSString stringWithFormat:@"%@/%@/%@=%@",[PublicMethods getStrings:@"url"],[PublicMethods getStrings:@"version"],[PublicMethods getStrings:@"auth"],token];
        
        [self.network callGETWebServiceWithPath:path withCallback:^(NSDictionary *result)
         {
             NSLog(@"%@",result);
             
             if([[result objectForKey:@"res"] isEqualToString:@"success"]) {
                 
                 
                 
                 if ([[[result objectForKey:@"data"] objectForKey:@"app_validation"] boolValue]) {
                     if ([self.DB UserExistOrNot]) {
                         
                         self.user = [self.DB getProfileInfo];
                         [self tokenValidation:self.user.token];
                     } else {
                         [self performSegueWithIdentifier:@"GoToSignIn" sender:self];
                     }
                     
                 } else {
                     
                     UIAlertView *updateAlert = [[UIAlertView alloc]initWithTitle:@"پیغام" message:@"این نسخه نیازمند به روز رسانی است." delegate:self cancelButtonTitle:@"انصراف" otherButtonTitles:@"دانلود آخرین نسخه", nil];
                     [updateAlert show];
                 }
                 
             } else {
                 
                 UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"خطا" message:@"خطا در api" delegate:self cancelButtonTitle:@"تلاش دوباره" otherButtonTitles:nil, nil];
                 [errorAlert show];
                 
             }
             
         } failure:^(BOOL failure) {
             
             if (failure) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"خطا" message:@"برقراری ارتباط امکان پذیر نمی باشد." delegate:nil cancelButtonTitle:@"تایید" otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];
        //end call webservice
    });
    
}
@end
