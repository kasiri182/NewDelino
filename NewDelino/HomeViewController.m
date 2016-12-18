//
//  HomeViewController.m
//  Rahno
//
//  Created by Mohammad on 12/7/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import "HomeViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "DataBase.h"
#import "HomeCollectionViewCell.h"
#import "DetailViewController.h"

@interface HomeViewController () <CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic,strong) NSString *nextID;
@property (nonatomic,strong) NSString *nextTitle;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) DataBase *DB;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setTabbarItem:@"فروشگاه"];
    self.DB = [[DataBase alloc]init];
    //hide nav bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //set status bar light content
    //[self setNeedsStatusBarAppearanceUpdate];
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout*)self.myCollectionView.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(2,2,2,2);
    layout.minimumColumnSpacing = 2;
    layout.columnCount = 3;
    layout.minimumInteritemSpacing = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTabbarItem:(NSString*)text {
    UIImage *image = [UIImage imageNamed:@"store"];
    UIImage *imageSel = [UIImage imageNamed:@"store-fill"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageSel = [imageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:text image:image selectedImage:imageSel];
}
-(NSMutableArray*)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        _dataArray = [self.DB getCategoryByParent:@"0"];
    }
    return _dataArray;
};

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToNext"]) {
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
    return CGSizeMake(CGRectGetWidth(self.myCollectionView.frame), CGRectGetHeight(self.myCollectionView.frame));
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionview cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell1";
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionview dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    dispatch_async(dispatch_get_main_queue(), ^(){
        cell.ID = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        cell.categoryLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
    });
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = (HomeCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    self.nextID = cell.ID;
    self.nextTitle = cell.categoryLabel.text;
    [self performSegueWithIdentifier:@"GoToNext" sender:self];
}

@end
