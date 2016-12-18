//
//  AddAddressViewController.m
//  RahnoHyper
//
//  Created by Mohammad on 10/31/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import "AddAddressViewController.h"
#import "Network.h"
#import "PublicMethods.h"
#import "ProfileFieldsCell.h"
#import "User.h"
#import "DataBase.h"
#import "MBProgressHUD.h"

@interface AddAddressViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong) IBOutlet UITextField *nameAddress;
@property(nonatomic,strong) IBOutlet UITextField *phoneAddress;
@property(nonatomic,strong) IBOutlet UITextView *textAddress;
@property (nonatomic,strong) Network *network;
@property (nonatomic,strong) DataBase *DB;
@property (nonatomic,strong) PublicMethods * Public;
@property (nonatomic,strong) User * user;
@property (nonatomic,strong) NSMutableDictionary * addressInfo;
@property (nonatomic,strong) NSArray * subjectArray;
@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.Public = [[PublicMethods alloc]init];
    self.network = [[Network alloc]init];
    self.DB = [[DataBase alloc]init];
    self.user = [self.DB getProfileInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableDictionary*)addressInfo {
    if (!_addressInfo) {
        _addressInfo = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"",@"name",@"",@"phonenum",@"",@"address", nil];
    }
    return _addressInfo;
}
#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        case 0:{
            [self.addressInfo setObject:str forKey:@"name"];
        }
            break;
        case 1:{
            [self.addressInfo setObject:str forKey:@"phonenum"];
        }
            break;
        default:
            break;
    }
    return YES;
}
#pragma mark - TextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSString * str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (textView.tag == 2) {
        [self.addressInfo setObject:str forKey:@"address"];
    }
    return YES;
}

#pragma mark - WebService
- (void) addAddressWebService {
    
    //NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:mobile,@"mobile", nil];
    //NSLog(@"%@",params);
    //show loading
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //call webservice sign up
        //prepare parameters
        NSString *path = [NSString stringWithFormat:@"%@/%@/%@?token=%@",[PublicMethods getStrings:@"url"],[PublicMethods getStrings:@"version"],[PublicMethods getStrings:@"allAddress"],self.user.token];
        
        [self.network callPOSTWebServiceWithPath:path AndWithParameters:self.addressInfo withCallback:^(NSDictionary *result) {
            NSLog(@"%@",result);
            //end show loading
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            if([[result objectForKey:@"res"] isEqualToString:@"success"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
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
        }];        //end call wevservice
    });
}
#pragma mark - IBActions
-(IBAction)returnBtn:(id)sender {
    
    NSLog(@"%@",self.addressInfo);
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)AddingAddress:(id)sender {
    
    NSLog(@"%@",self.addressInfo);
    
    if (![self.nameAddress.text isEqualToString:@""] && ![self.phoneAddress.text isEqualToString:@""] && ![self.textAddress.text isEqualToString:@""]) {
        
        [self addAddressWebService];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"خطا" message:@"تمامی فیلدها را پر کنید!" delegate:nil cancelButtonTitle:@"تایید" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

@end
