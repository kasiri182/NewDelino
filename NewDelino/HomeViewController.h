//
//  HomeViewController.h
//  Rahno
//
//  Created by Mohammad on 12/7/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic , strong) IBOutlet UICollectionView* myCollectionView;
@property(nonatomic , strong) NSMutableArray* myCategorySource;

@end
