//
//  SearchViewController.h
//  Rahno
//
//  Created by Mohammad on 12/7/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic , strong) IBOutlet UICollectionView* searchCollection;
@property(nonatomic , strong) IBOutlet UITextField*searchFields;

@property(nonatomic , strong) NSMutableArray* myCategorySource;



@end
