//
//  PublicMethods.h
//  Karbin
//
//  Created by Sohail on 5/7/16.
//  Copyright © 2016 Sohail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PublicMethods : NSObject

@property(nonatomic , strong) NSString* registerToken;

- (UIColor*)colorWithHexString:(NSString*)hex;
- (UIFont*)fontTexts:(NSInteger)integer;
- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font;
- (CGFloat)heightOfString:(NSString *)string withFont:(UIFont *)font;
- (CGFloat)getHeightSentenceLimitWidth:(NSString *)sentence withWidth:(CGFloat)width withFont:(UIFont *)font sizeFont:(NSInteger)sizeFont;
- (CGFloat)getHeightSentence:(NSString *)sentence withWidth:(CGFloat)width withFont:(UIFont *)font customLineHeight:(NSInteger)customLine;
- (NSString *)convertDatewithFormat:(NSString *)dateString;
- (NSDictionary*)convertStringToDictionary:(NSString*)string;
- (NSString*)convertNSDicToString:(NSDictionary*)dict;
- (NSString*)convertEnNumberToFarsi:(NSString*)number;
- (NSString*)convertFaNumberToEnglish:(NSString*)number;
- (NSString *)getCurrentPersianTime;
- (NSString*)getCurrentTime;
- (NSString*)randomStringWithLenght:(NSInteger)lenght;
- (NSString*)getPersianTimeStamp:(double)times;
- (NSString*)getCurrentYear;
- (NSDate*)convertStringToDate:(NSString*)timeString;
- (CALayer*)addBorderBottomWithSize:(CGFloat)size width:(CGFloat)width height:(CGFloat)height color:(UIColor*)color;
- (id)showMessageView:(UIView*)view message:(NSString*)text;
-(NSData *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height;
#pragma mark - Fraction formatter
+(NSString *)getStrings:(NSString*)key;

@end
