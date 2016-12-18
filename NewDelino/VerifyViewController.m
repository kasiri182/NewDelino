//
//  VerifyViewController.m
//  Rahno
//
//  Created by Mohammad on 12/7/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import "VerifyViewController.h"
#import "PublicMethods.h"
#import "Network.h"
#import "User.h"
#import "DataBase.h"
#import "MBProgressHUD.h"
#import "EditProfileViewController.h"

@interface VerifyViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) Network *network;
@property (nonatomic,strong) PublicMethods *Public;
@property (nonatomic,strong) DataBase *DB;
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * active;
@property (nonatomic,strong) NSString * tokens;

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"ورود";
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.Public = [[PublicMethods alloc]init];
    self.network = [[Network alloc]init];
    self.DB = [[DataBase alloc]init];
    self.codeView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToProfile"]) {
        EditProfileViewController *profile = [segue destinationViewController];
        profile.token = self.tokens;
        
    }
    /*if ([segue.identifier isEqualToString:@"activeCodeSegue"]) {
     ActiveViewController *active = [segue destinationViewController];
     active.mobile = self.mobileNumber.text;
     active.idPerson = self.ID;
     
     }*/
}

#pragma mark - WebService
- (void) sendMobileNumber:(NSString*)mobile {
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:mobile,@"mobile", nil];
    NSLog(@"%@",params);
    //show loading
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //call webservice sign up
        //prepare parameters
        NSString *path = [NSString stringWithFormat:@"%@/%@/%@",[PublicMethods getStrings:@"url"],[PublicMethods getStrings:@"version"],[PublicMethods getStrings:@"sendMobile"]];
        NSLog(@"%@",path);
        
        [self.network callPOSTWebServiceWithPath:path AndWithParameters:params withCallback:^(NSDictionary *result) {
            NSLog(@"%@",result);
            //end show loading
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            if([[result objectForKey:@"res"] isEqualToString:@"success"]) {
                
                self.ID = [[result objectForKey:@"data"] objectForKey:@"id"];
                self.codeView.hidden = NO;
                self.mobileNumber.userInteractionEnabled = NO;
                [self.activeCode becomeFirstResponder];
                //[self performSegueWithIdentifier:@"activeCodeSegue" sender:self];
                
            } else {
                UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"خطا" message:@"خطا در انجام فرآیند!" delegate:nil cancelButtonTitle:@"تایید" otherButtonTitles:nil, nil];
                [error show];
            }
        }failure:^(BOOL failure) {
            //end show loading
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            if (failure) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"خطا" message:@"برقراری ارتباط امکان پذیر نمی باشد." delegate:nil cancelButtonTitle:@"تایید" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];//end call webservice
    });
}
- (void) sendActivationCode {
    
    //show loading
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSString *path = [NSString stringWithFormat:@"%@/%@/%@?id=%@&code=%@",[PublicMethods getStrings:@"url"],[PublicMethods getStrings:@"version"],[PublicMethods getStrings:@"sendMobile"],self.ID,self.active];
        
        [self.network callGETWebServiceWithPath:path withCallback:^(NSDictionary *result)
         {
             NSLog(@"%@",result);
             //end show loading
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
             if([[[result objectForKey:@"data"] objectForKey:@"validation"] boolValue]) {
                 self.tokens = [[result objectForKey:@"data"] objectForKey:@"token"];
                 
                 User *user = [[User alloc]init];
                 user.token = self.tokens;
                 [self.DB insertUser:user];
                 [self performSegueWithIdentifier:@"GoToProfile" sender:self];
             }
             
         } failure:^(BOOL failure) {
             //end show loading
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
             if (failure) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"خطا" message:@"برقراری ارتباط امکان پذیر نمی باشد." delegate:nil cancelButtonTitle:@"تایید" otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];//end call webservice
    });
}

#pragma mark -TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 10) {
        if (str.length >= 2) {
            if (str.length == 11) {
                
                [self sendMobileNumber:str];
            }
            return YES;
        } else {
            return NO;
        }
        
    } else if (textField.tag == 20) {
        if (str.length == 4) {
            self.active = str;
            [self sendActivationCode];
            
        }
    }
    return YES;
    
}

@end
