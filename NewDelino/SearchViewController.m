//
//  SearchViewController.m
//  Rahno
//
//  Created by Mohammad on 12/7/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import "SearchViewController.h"
#import "HomeCollectionViewCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "DetailViewController.h"
#import "DataBase.h"
#import "AppDelegate.h"
#import "PublicMethods.h"

@interface SearchViewController () <CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic,strong) NSString *nextID;
@property (nonatomic,strong) NSString *nextTitle;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) DataBase *DB;
@property (nonatomic,strong) PublicMethods *Public;

@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.DB = [[DataBase alloc]init];
    self.Public = [[PublicMethods alloc]init];
    if (![self.searchFields.text isEqualToString:@""]) {
        self.dataArray = [self.DB searchFilterJob:self.searchFields.text];
    } else {
        self.dataArray = [NSMutableArray array];
    }
    [self.searchCollection reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setTabbarItem:@"جستجو"];
    
    //hide nav bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //set status bar light content
    //[self setNeedsStatusBarAppearanceUpdate];
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout*)self.searchCollection.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(5,5,5,5);
    layout.minimumColumnSpacing = 5;
    layout.columnCount = 2;
    layout.minimumInteritemSpacing = 5;
    
    /*self.myCollectionView.alwaysBounceVertical = YES;
     __weak HomeViewController *weakSelf = self;
     [self.myCollectionView addPullToRefreshWithActionHandler:^{
     [weakSelf refreshWebService];
     }];*/
    
}
- (void)setTabbarItem:(NSString*)text {
    UIImage *image = [UIImage imageNamed:@"search"];
    UIImage *imageSel = [UIImage imageNamed:@"search-fill"];
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageSel = [imageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:text image:image selectedImage:imageSel];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray*)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        //_dataArray = [self.DB getCategoryByParent:@"0"];
    }
    return _dataArray;
};
#pragma mark Actions
-(IBAction)AddActions:(id)sender {
    
    UIButton * add = (UIButton*)sender;
    NSInteger selctedIndex = [add tag];
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:selctedIndex inSection:0];
    
    HomeCollectionViewCell *cell = (HomeCollectionViewCell*)[self.searchCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selctedIndex inSection:0]];
    //    NSLog(@"%@",[cell.item_object ]);
    
    Items *item = cell.item_object;
    NSLog(@"%@",cell.item_object.id_item);
    
    if (![self.DB ItemExistOrNot:[[[self.dataArray objectAtIndex:selctedIndex] id_item] integerValue]]) {
        item.number_item = 1;
        [self.DB insertItemToOrderList:item];
        
        [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",(int)[self.DB getCartItems].count]];
        
    } else {
        
        item.number_item = [self.DB getCountItems:[[[self.dataArray objectAtIndex:selctedIndex] id_item] integerValue]] + 1;
        [self.DB updateItemsNumber:item];
        
    }
    
    //    [self.searchCallection reloadData];
    [self.searchCollection reloadItemsAtIndexPaths:[NSArray arrayWithObjects:rowToReload, nil]];
}

-(IBAction)CancelSearching:(id)sender {
    
    [self.searchFields resignFirstResponder];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchFields resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchGoToNext"]) {
        DetailViewController *secondPage = [segue destinationViewController];
        secondPage.currentID = self.nextID;
        secondPage.titleCat = self.nextTitle;
    }
}

#pragma mark collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    CGFloat cellWidth = (self.view.frame.size.width / 2) - 17;
    //    CGFloat textViewWidth = cellWidth - 40;
    return  CGSizeMake(150, 150);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionview cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell2";
    
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionview dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        //        Items *item = [[Items alloc]init];
        
        //        item = (Items*)[self.dataArray objectAtIndex:indexPath.row];
        cell.item_object = (Items*)[self.dataArray objectAtIndex:indexPath.row];
        //        NSLog(@"num = %ld",);
        cell.subject.text = [[self.dataArray objectAtIndex:indexPath.row] name_item];
        
        NSInteger Number = cell.item_object.number_item;
        if (Number > 0) {
            [cell.addBtn setBackgroundColor:[self.Public colorWithHexString:@"673AB7"]];
            cell.number.textColor = [self.Public colorWithHexString:@"673AB7"];
            cell.number.backgroundColor = [self.Public colorWithHexString:@"FFD54F"];
            cell.number.text = [NSString stringWithFormat:@"%ld",(long)Number];
            cell.price.textColor = [self.Public colorWithHexString:@"FFD54F"];
            [cell.addBtn setTitle:@"+" forState:UIControlStateNormal];
            
        } else {
            
            [cell.addBtn setBackgroundColor:[self.Public colorWithHexString:@"FFD54F"]];
            cell.number.textColor = [self.Public colorWithHexString:@"FFD54F"];
            cell.number.backgroundColor = [self.Public colorWithHexString:@"673AB7"];
            cell.number.text = [NSString stringWithFormat:@"+"];
            cell.price.textColor = [self.Public colorWithHexString:@"673AB7"];
            [cell.addBtn setTitle:@"+" forState:UIControlStateNormal];
            
            
        }
        cell.number.layer.cornerRadius = CGRectGetWidth(cell.number.frame)/2;
        cell.number.layer.masksToBounds = YES;
        
        cell.price.text = [[self.dataArray objectAtIndex:indexPath.row] price_item];
        cell.categoryImage.image = [UIImage imageNamed:@"linked_in"];
        cell.addBtn.tag = indexPath.row;
        //[cell.addBtn setTitle:[[self.dataArray objectAtIndex:indexPath.row] name_item] forState:UIControlStateNormal];
    });
    
    return cell;
    
}
/*- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 RootCollectionViewCell *cell = (RootCollectionViewCell*)[self.myCollectionView cellForItemAtIndexPath:indexPath];
 NSLog(@"%@",[cell.item_object name_item]);
 }*/
#pragma mark UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"%@",str);
    
    if (str.length == 0) {
        NSLog(@"nil");
        self.dataArray = [NSMutableArray array];
        //[self showFilterTable];
    }
    else {
        self.dataArray = [self.DB searchFilterJob:str];
    }
    [self.searchCollection reloadData];
    
    return YES;
}


@end
