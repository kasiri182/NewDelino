//
//  CartViewCell.h
//  Rahno
//
//  Created by Mohammad on 12/7/16.
//  Copyright © 2016 Mohammad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Items.h"

@interface CartViewCell : UITableViewCell

@property (nonatomic,strong) Items *item_object;
@property (nonatomic,weak) IBOutlet UIImageView *images;
@property (nonatomic,weak) IBOutlet UILabel *name;
@property (nonatomic,weak) IBOutlet UILabel *number;
@property (nonatomic,weak) IBOutlet UILabel *price;
@property (nonatomic,weak) IBOutlet UIButton *increase;
@property (nonatomic,weak) IBOutlet UIButton *decrease;

@end
