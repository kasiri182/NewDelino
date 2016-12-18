//
//  FinalShopViewController.m
//  Rahno
//
//  Created by Mohammad on 12/8/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import "FinalShopViewController.h"
#import "PublicMethods.h"
#import "User.h"
#import "DataBase.h"
#import "Network.h"
#import "MBProgressHUD.h"
#import "AddAddressViewController.h"

@interface FinalShopViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,weak) IBOutlet UITableView *tableShop;
@property (nonatomic,strong) Network *network;
@property (nonatomic,strong) DataBase *DB;
@property (nonatomic,strong) PublicMethods * Public;
@property (nonatomic,strong) User * user;
@property (nonatomic,strong) NSMutableArray *chooseArray;
@property (nonatomic,strong) NSMutableArray *addreses;
@property (nonatomic,strong) NSMutableArray *payments;
@property (nonatomic,strong) NSMutableData * receivedData;

@end

@implementation FinalShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.addressArray = nil;
    self.Public = [[PublicMethods alloc]init];
    self.network = [[Network alloc]init];
    self.DB = [[DataBase alloc]init];
    self.user = [self.DB getProfileInfo];
    [self getAllAddress];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray*)chooseArray {
    if (!_chooseArray) {
        _chooseArray = [NSMutableArray arrayWithObjects:@"0",@"0", nil];
    }
    return _chooseArray;
}
- (NSMutableArray*)addreses {
    if (!_addreses) {
        _addreses = [[NSMutableArray alloc] init];
    }
    return _addreses;
}
- (NSMutableArray*)payments {
    if (!_payments) {
        _payments = [NSMutableArray arrayWithObjects:@"پرداخت نقدی",@"پرداخت با دستگاه کارت خوان", nil];
    }
    return _payments;
}
- (NSMutableDictionary*)createJSONOrder:(NSInteger)idAddress {
    
    NSMutableDictionary *orderJson = [[NSMutableDictionary alloc]init];
    [orderJson setObject:[NSString stringWithFormat:@"%ld",(long)idAddress] forKey:@"address_id"];
    NSMutableArray *itemsArray = [NSMutableArray array];
    for (Items *item in [self.DB getCartItems]) {
        NSString *itemID = [NSString stringWithFormat:@"%@",item.id_item];
        NSString *itemNumber = [NSString stringWithFormat:@"%ld",(long)item.number_item];
        NSArray * objectOrder = [NSArray arrayWithObjects:itemID,itemNumber, nil];
        [itemsArray addObject:objectOrder];
    }
    [orderJson setObject:itemsArray forKey:@"items"];
    
    return orderJson;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"GoToAddAddress"]) {
        AddAddressViewController *add = segue.destinationViewController;
        NSLog(@"%@",add);
    }
}
#pragma mark - WebService
- (void) getAllAddress {
    
    //show loading
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSString *path = [NSString stringWithFormat:@"%@/%@/%@?token=%@",[PublicMethods getStrings:@"url"],[PublicMethods getStrings:@"version"],[PublicMethods getStrings:@"allAddress"],self.user.token];
        
        [self.network callGETWebServiceWithPath:path withCallback:^(NSDictionary *result)
         {
             NSLog(@"%@",result);
             //end show loading
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
             if([[result objectForKey:@"res"] isEqualToString:@"success"]) {
                 
                 NSLog(@"%@",result);
                 
                 for (NSDictionary *dictionary in [result objectForKey:@"data"]) {
                     [self.addreses addObject:dictionary];
                 }
                 [self.tableShop reloadData];
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
         }];
        //end call wevservice
    });
    
    
}


#pragma mark - IBAction
-(IBAction)Accept:(id)sender {

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"پیغام" message:@"تغییر قیمت" delegate:self cancelButtonTitle:@"انصراف" otherButtonTitles:@"تایید", nil];
    [alert show];
}
-(IBAction)AddAddress:(id)sender {

    [self performSegueWithIdentifier:@"GoToAddAddress" sender:self];
}


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.addreses.count;
    }
    return self.payments.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    
    viewHeader.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:viewHeader.bounds];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:headerView.bounds];
    headerView.layer.masksToBounds = NO;
    headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    headerView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    headerView.layer.shadowRadius = 5.0;  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
    headerView.layer.shadowOpacity = 0.2f;
    headerView.layer.shadowPath = shadowPath.CGPath;
    
    headerView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    headerView.layer.cornerRadius = 5.0 ;
    
    
    UILabel *lblTitleOne = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetHeight(viewHeader.frame), 0, CGRectGetWidth(viewHeader.frame)- CGRectGetHeight(viewHeader.frame) - 10,CGRectGetHeight(viewHeader.frame))];
    lblTitleOne.backgroundColor = [UIColor clearColor];
    lblTitleOne.textAlignment = NSTextAlignmentRight;
    NSArray *title = [NSArray arrayWithObjects:@"آدرس",@"پرداخت", nil];
    lblTitleOne.text = [NSString stringWithFormat:@"%@",[title objectAtIndex:section]];
    [headerView addSubview:lblTitleOne];
    if (section == 0) {
        UIButton *addAddress = [UIButton buttonWithType:UIButtonTypeCustom];
        addAddress.frame = CGRectMake(0, 0, CGRectGetHeight(viewHeader.frame), CGRectGetHeight(viewHeader.frame));
        addAddress.backgroundColor = [UIColor redColor];
        [addAddress setTitle:@" + " forState:UIControlStateNormal];
        [addAddress addTarget:self action:@selector(AddAddress:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:addAddress];
    }
    
    [viewHeader addSubview:headerView];
    return viewHeader;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"Default";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld %ld",indexPath.section,indexPath.row];
    if (indexPath.section == 0) {
        cell.textLabel.text = [[self.addreses objectAtIndex:indexPath.row] objectForKey:@"address"];
        if (indexPath.row == [[self.chooseArray objectAtIndex:0] integerValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [self.payments objectAtIndex:indexPath.row];
        if (indexPath.row == [[self.chooseArray objectAtIndex:1] integerValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row != [[self.chooseArray objectAtIndex:0] integerValue]) {
            
            [self.chooseArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row != [[self.chooseArray objectAtIndex:1] integerValue]) {
            
            [self.chooseArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
    }
    [tableView reloadData];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        NSMutableDictionary *dict = [self createJSONOrder:1];
        [self sendOrder:dict];
    }
}


#pragma mark - WebService
- (void) sendOrder:(NSMutableDictionary*)json {
    
    //NSLog(@"%@",params);
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //prepare parameters
        NSLog(@"%@",json);
        NSString *path = [NSString stringWithFormat:@"%@/%@/%@?token=%@",[PublicMethods getStrings:@"url"],[PublicMethods getStrings:@"version"],[PublicMethods getStrings:@"order"],self.user.token];
        NSLog(@"%@",path);
        
        NSData *myData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[myData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:path]];
        [request setHTTPMethod:@"POST"];
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
    if ([[dict objectForKey:@"res"] isEqualToString:@"success"]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"تبریک" message:@"سفارش شما با موفقیت ثبت شد!" delegate:nil cancelButtonTitle:@"تایید" otherButtonTitles:nil, nil];
        [alert show];
        [self.DB deleteAllOrderedItems];
        [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
        [self.tabBarController setSelectedIndex:3];
        
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
