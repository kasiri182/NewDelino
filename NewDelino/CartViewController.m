//
//  CartViewController.m
//  Rahno
//
//  Created by Mohammad on 12/7/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import "CartViewController.h"
#import "DataBase.h"
#import "CartViewCell.h"
#import "PublicMethods.h"
#import "FinalShopViewController.h"

@interface CartViewController ()
{
    NSInteger allPrice;
}
@property (nonatomic,strong) NSMutableArray *dataArray;
//@property (nonatomic,strong) NSMutableDictionary *orderJson;
@property (nonatomic,strong) DataBase *DB;
@property (nonatomic,strong) IBOutlet UITableView *myCheckList;
@property (nonatomic,strong) IBOutlet UILabel *labelPrice;

@end

@implementation CartViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.DB = [[DataBase alloc]init];
    [self calculatePrice];
    
    [self.myCheckList reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setTabbarItem:@"سبد خرید"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSLog(@"%@",self.dataArray);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        _dataArray = [self.DB getCartItems];
    }
    return _dataArray;
};
-(void)calculatePrice {
    self.dataArray = [self.DB getCartItems];
    allPrice = 0;
    for (Items *item in self.dataArray) {
        
        allPrice += [item.price_item integerValue] * item.number_item;
    }
    [self.labelPrice setText:[NSString stringWithFormat:@"%ld",(long)allPrice]];
}

- (void)setTabbarItem:(NSString*)text {
    UIImage *image = [UIImage imageNamed:@"shop"];
    UIImage *imageSel = [UIImage imageNamed:@"shop-fill"];
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageSel = [imageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:text image:image selectedImage:imageSel];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChooseAddress"]) {
        
        //AddressesViewController *address = segue.destinationViewController;
        //address.isOrdering = YES;
    } else if ([segue.identifier isEqualToString:@"FinalShopSegue"]) {
    
        FinalShopViewController *finalShop = segue.destinationViewController;
        NSLog(@"%@",finalShop);
    
    }
}

#pragma mark - Actions
-(IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(IBAction)increaseBtn:(id)sender {
    
    UIButton * add = (UIButton*)sender;
    NSInteger selctedIndex = [add tag];
    
    CartViewCell *cell = (CartViewCell*)[self.myCheckList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selctedIndex inSection:0]];
    Items *item = cell.item_object;
    item.number_item += 1;
    [self.DB updateItemsNumber:item];
    [self calculatePrice];
    [self.myCheckList reloadData];
}
-(IBAction)decreaseBtn:(id)sender {
    
    UIButton * add = (UIButton*)sender;
    NSInteger selctedIndex = [add tag];
    
    CartViewCell *cell = (CartViewCell*)[self.myCheckList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selctedIndex inSection:0]];
    Items *item = cell.item_object;
    
    item.number_item -= 1;
    
    if (item.number_item > 0) {
        
        [self.DB updateItemsNumber:item];
        
    } else if (item.number_item == 0) {
        [self.DB deleteItems:item];
        
        
        if ([self.DB getCartItems].count > 0) {
            [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",(int)[self.DB getCartItems].count]];
        } else {
            [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
        }
        
    }
    [self calculatePrice];
    [self.myCheckList reloadData];
}
-(IBAction)continueShop:(id)sender {
    
    if (self.dataArray.count > 0) {
        [self performSegueWithIdentifier:@"FinalShopSegue" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"پیغام" message:@"کالایی در سبد خرید شما موجود نیست!" delegate:nil cancelButtonTitle:@"تایید" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count == 0) {
        return CGRectGetHeight(self.myCheckList.frame);
    }
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *defaultCell = @"Default";
    
    if (self.dataArray.count > 0) {
        CartViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckListCell"];
        if (!cell){
            cell = [[CartViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckListCell"];
        }
        self.myCheckList.scrollEnabled = YES;
        cell.item_object = (Items*)[self.dataArray objectAtIndex:indexPath.row];
        cell.name.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row] name_item]];
        cell.price.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row] price_item]];
        cell.images.image = [UIImage imageNamed:@"linked_in"];
        cell.increase.tag = indexPath.row;
        cell.decrease.tag = indexPath.row;
        cell.number.text = [NSString stringWithFormat:@"%ld",(long)[[self.dataArray objectAtIndex:indexPath.row] number_item]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCell];
    }
    self.myCheckList.scrollEnabled = NO;
    cell.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:249.0f/255.0f alpha:0.5];
    cell.textLabel.font = [UIFont fontWithName:@"IRANSans" size:18];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = @"کالایی در سبد خرید موجود نیست.";
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSLog(@"didSelect method called");
    if (self.dataArray.count > 0) {
        
    }
}


@end
