//
//  MKTextField.m
//  Karbin
//
//  Created by Mohammad on 7/25/16.
//  Copyright © 2016 Sohail. All rights reserved.
//

#import "MKTextField.h"

@implementation MKTextField
@synthesize leftPadding,rightPadding,topPadding,bottomPadding;
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + leftPadding, bounds.origin.y + topPadding, bounds.size.width - (rightPadding+leftPadding), bounds.size.height - (topPadding+bottomPadding));
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end
