//
//  ProfileViewController.m
//  Rahno
//
//  Created by Mohammad on 12/7/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import "ProfileViewController.h"
//#import "OrdersViewController.h"
#import "Network.h"
#import "PublicMethods.h"
#import "ProfileFieldsCell.h"
#import "User.h"
#import "DataBase.h"
//#import "AddressesViewController.h"
#import "EditProfileViewController.h"
#import "ProfileViewCell.h"
#import "MBProgressHUD.h"

@interface ProfileViewController ()
@property(nonatomic,weak) IBOutlet UITableView *tableProfiles;
@property (nonatomic,strong) Network *network;
@property (nonatomic,strong) DataBase *DB;
@property (nonatomic,strong) PublicMethods * Public;
@property (nonatomic,strong) User * user;
@property (nonatomic,strong) NSMutableDictionary * mainProfile;
@property (nonatomic,strong) NSArray * subjectArray;
@property (nonatomic,strong) NSMutableArray * profileArray;
@property (nonatomic,strong) NSMutableData * receivedData;

@end

@implementation ProfileViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.Public = [[PublicMethods alloc]init];
    self.network = [[Network alloc]init];
    self.DB = [[DataBase alloc]init];
    self.user = [self.DB getProfileInfo];

    //[self setTabbarItem:@"پروفایل"];
    [self getProfileInformation];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray*)profileArray {
    if (!_profileArray) {
        _profileArray = [[NSMutableArray alloc]initWithObjects:@"نام کاربری",@"نام",@"نام خانوادگی",@"همراه",@"تلفن",@"آدرس", nil];
    }
    return _profileArray;
}
- (NSMutableDictionary*)mainProfile {
    if (!_mainProfile) {
        _mainProfile = [[NSMutableDictionary alloc]init];
    }
    return _mainProfile;
}
- (void)setTabbarItem:(NSString*)text {
    UIImage *image = [UIImage imageNamed:@"profile"];
    UIImage *imageSel = [UIImage imageNamed:@"profile-fill"];
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageSel = [imageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:text image:image selectedImage:imageSel];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToAllAddress"]) {
        //AddressesViewController *address = [segue destinationViewController];
        //NSLog(@"%@",address);
        //profile.token = self.tokens;
        
    } else if ([segue.identifier isEqualToString:@"OrdersViewController"]) {
        
        //OrdersViewController *orders = [segue destinationViewController];
        //NSLog(@"%@",orders);
        //profile.token = self.tokens;
    } else if ([segue.identifier isEqualToString:@"EditProfileView"]) {
        EditProfileViewController *edit = [segue destinationViewController];
        edit.editState = YES;
        edit.token = self.user.token;
        
    }
}

#pragma mark - WebService
- (void) getProfileInformation {
    //show loading
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSString *path = [NSString stringWithFormat:@"%@/%@/%@?token=%@",[PublicMethods getStrings:@"url"],[PublicMethods getStrings:@"version"],[PublicMethods getStrings:@"profile"],self.user.token];
        
        [self.network callGETWebServiceWithPath:path withCallback:^(NSDictionary *result)
         {
             NSLog(@"%@",result);
             
             if([[result objectForKey:@"res"] isEqualToString:@"success"]) {
                 
                 self.mainProfile = [[NSMutableDictionary alloc]initWithDictionary:[result objectForKey:@"data"]];
                 [self.tableProfiles reloadData];
             }
             
             //end show loading
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
         } failure:^(BOOL failure) {
             //end show loading
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
             if (failure) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"خطا" message:@"برقراری ارتباط امکان پذیر نمی باشد." delegate:nil cancelButtonTitle:@"تایید" otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];
        //end call webservice
    });
    
}
- (void) saveProfile {
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[self.mainProfile objectForKey:@"username"],@"username",[self.mainProfile objectForKey:@"name"],@"name",[self.mainProfile objectForKey:@"lastname"],@"lastname",@"test@gmail.com",@"email",[NSNumber numberWithInteger:1],@"sex", nil];
    //NSLog(@"%@",params);
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //prepare parameters
        NSString *path = [NSString stringWithFormat:@"%@/%@/%@?token=%@",[PublicMethods getStrings:@"url"],[PublicMethods getStrings:@"version"],[PublicMethods getStrings:@"profile"],self.user.token];
        NSLog(@"path = %@",path);
        
        NSData *myData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[myData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:path]];
        [request setHTTPMethod:@"PUT"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:myData];
        NSURLConnection * connection = [[NSURLConnection alloc]
                                        initWithRequest:request
                                        delegate:self startImmediately:NO];
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                              forMode:NSDefaultRunLoopMode];
        [connection start];
        
    });
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.profileArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"ProfileCell";
    //static NSString *CellIdentifier2 = @"Choosing";
    ProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (!cell) {
        cell = [[ProfileViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titles.text = [self.profileArray objectAtIndex:indexPath.row];
    cell.titles.textAlignment = NSTextAlignmentRight;
    //[cell.titles setFont:[UIFont fontWithName:@"IRAN Sans" size:14]];
    if (indexPath.row == 0) {
        cell.details.text = [self.mainProfile objectForKey:@"username"];
        return cell;
    } else if (indexPath.row == 1) {
        cell.details.text = [self.mainProfile objectForKey:@"name"];
        return cell;
        
    } else if (indexPath.row == 2) {
        cell.details.text = [self.mainProfile objectForKey:@"lastname"];
        return cell;
        
    } else if (indexPath.row == 3) {
        cell.details.text = [self.mainProfile objectForKey:@"mobile"];
        return cell;
        
    } else if (indexPath.row == 4) {
        cell.details.text = [self.mainProfile objectForKey:@"pic_id"];
        return cell;
        
    } else if (indexPath.row == 5) {
        cell.details.text = [self.mainProfile objectForKey:@"address"];
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    /*if (indexPath.row == 0) {
     
     [self performSegueWithIdentifier:@"EditProfileView" sender:self];
     
     } else if (indexPath.row == 1) {
     
     [self performSegueWithIdentifier:@"GoToAllAddress" sender:self];
     
     } else if (indexPath.row == 2) {
     
     [self performSegueWithIdentifier:@"GoToAllOrder" sender:self];
     }*/
}

#pragma mark - IBActions
-(IBAction)Edit:(id)sender {
    
    [self performSegueWithIdentifier:@"EditProfileView" sender:self];
    
}
#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //buffer is the object Of NSMutableData and it is global,so declare it in .h file
    self.receivedData = [NSMutableData data];
    NSLog(@"ESTOY EN didReceiveResponse*********");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"ESTOY EN didReceiveDATA*********");
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Here You will get the whole data
    NSLog(@"ESTOY EN didFINISHLOADING*********");
    NSError *jsonParsingError = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:&jsonParsingError];
    
    NSLog(@"%@",dict);
    if ([[[dict objectForKey:@"data"] objectForKey:@"change"] boolValue]) {
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"خطا" message:@"برقراری ارتباط امکان پذیر نمی باشد." delegate:nil cancelButtonTitle:@"تایید" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"ERROR de PARSING");
    NSLog(@"ESTOY EN didFAILWITHERROR*********");
}

@end
