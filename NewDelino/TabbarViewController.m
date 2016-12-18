//
//  TabbarViewController.m
//  RahnoHyper
//
//  Created by Mohammad on 9/30/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import "TabbarViewController.h"
#import "PublicMethods.h"
#import "DataBase.h"

@interface TabbarViewController ()

@property (nonatomic,strong) PublicMethods *public;
@property (nonatomic,strong) DataBase *DB;


@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.public = [[PublicMethods alloc]init];
    self.DB = [[DataBase alloc]init];
    
    /*[[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [self.public colorWithHexString:@"673AB7"] } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [self.public colorWithHexString:@"673AB7"] } forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[self.public fontTexts:6], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [(UITabBarController*)self.navigationController.topViewController setSelectedIndex:3];
    
    NSInteger Count = [self.DB getCartItems].count;
    
    if (Count > 0) {
        [[[self.tabBar items]objectAtIndex:2]setBadgeValue:[NSString stringWithFormat:@"%ld",(long)Count]];
    }
    self.navigationController.navigationBarHidden = YES;*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
