//
//  PublicMethods.m
//  Karbin
//
//  Created by Sohail on 5/7/16.
//  Copyright © 2016 Sohail. All rights reserved.
//

#import "PublicMethods.h"

#define Global_Yekan(s) [UIFont fontWithName:@"IRANSans" size:s];

@implementation PublicMethods
@synthesize registerToken;

-(void)setRegisterToken:(NSString *)regist
{
    if (!registerToken) {
        registerToken = regist;
    }
}
-(NSString*)registerToken {
    return  registerToken;
}

- (UIColor*)colorWithHexString:(NSString*)hex{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
- (UIFont*)fontTexts:(NSInteger)integer{
    UIFont *font = Global_Yekan(integer);
    return font;
}
- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}
- (CGFloat)heightOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    //NSLog(@"%f",[[[NSAttributedString alloc] initWithString:string attributes:attributes] size].height);
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].height;
}
- (CGFloat)getHeightSentenceLimitWidth:(NSString *)sentence withWidth:(CGFloat)width withFont:(UIFont *)font sizeFont:(NSInteger)sizeFont {
    
    CGSize constraint = CGSizeMake(width, 20000.0f);
    NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:sentence attributes:@{NSFontAttributeName:font}];
    
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    int numberOfLines = (size.height / font.lineHeight);
    
    CGFloat height = MAX(size.height, 30.0f);
    if (numberOfLines*sizeFont > 2*height) {
        return 2*height +(2*10)/*+60+(2*10)*/;
    }
    else
        return numberOfLines*sizeFont +(2*10);
}

- (CGFloat)getHeightSentence:(NSString *)sentence withWidth:(CGFloat)width withFont:(UIFont *)font customLineHeight:(NSInteger)customLine {
    
    CGSize constraint = CGSizeMake(width, 20000.0f);
    NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:sentence attributes:@{NSFontAttributeName:font}];
    
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    int numberOfLines = (size.height / font.lineHeight);
    
    return numberOfLines * customLine + 10;
}




- (NSDictionary*)convertStringToDictionary:(NSString*)string {
    NSError* error;
    //giving error as it takes dic, array,etc only. not custom object.
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return json;
}
- (NSString*)convertNSDicToString:(NSDictionary*)dict {
    NSError* error;
    //giving error as it takes dic, array,etc only. not custom object.
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString* nsJson=  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return nsJson;
}
- (NSString*)convertEnNumberToFarsi:(NSString*)number {
    NSString *text;
    NSDecimalNumber *someNumber = [NSDecimalNumber decimalNumberWithString:number];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSLocale *gbLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fa"];
    [formatter setLocale:gbLocale];
    text = [formatter stringFromNumber:someNumber];
    if (![text isEqualToString:@"ناعدد"]) {
        return text;
    }
    return nil;
}
- (NSString*)convertFaNumberToEnglish:(NSString*)number{
    NSString *text;
    NSString *NumberString = number;
    NSNumberFormatter *nf1 = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    [nf1 setLocale:locale];
    NSNumber *newNum = [nf1 numberFromString:NumberString];
    text = [NSString stringWithFormat:@"%@",newNum];
    if (text) {
        return text;
    }
    return nil;
}
-(NSString*)getCurrentTime {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    return dateString;
}

- (NSString *) getCurrentPersianTime {
    
    NSCalendar *persCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierPersian];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *IRLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"];
    [dateFormatter setLocale:IRLocal];
    [dateFormatter setCalendar:persCalendar];
    NSDate *today = [NSDate date];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *currDay = [dateFormatter stringFromDate:today];
    
    [NSString stringWithFormat:@"%@",currDay];
    
    return currDay;
    
}
- (NSString *)convertDatewithFormat:(NSString *)dateString
{
    NSCalendar *persCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierPersian];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *IRLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"];
    [dateFormatter setLocale:IRLocal];
    [dateFormatter setCalendar:persCalendar];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *formattedDate = [dateFormatter stringFromDate:[self convertStringToDate:dateString]];
    
//    [NSString stringWithFormat:@"%@",currDay];
    
    
    return formattedDate;
}
-(NSString*)getPersianTimeStamp:(double)times {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(times / 1000.0)];
    NSCalendar *persCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierPersian];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *IRLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"];
    [dateFormatter setLocale:IRLocal];
    [dateFormatter setCalendar:persCalendar];
    [dateFormatter setDateFormat:@"y/MM/d HH:mm"];
    NSString *currDay = [dateFormatter stringFromDate:date];
    return currDay;
}
- (NSString*)getCurrentYear {
    NSCalendar *persCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierPersian];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *IRLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"];
    [dateFormatter setLocale:IRLocal];
    [dateFormatter setCalendar:persCalendar];
    NSDate *today = [NSDate date];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *month = [dateFormatter stringFromDate:today];
    return month;
}
- (NSDate*)convertStringToDate:(NSString*)timeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:timeString];
    return dateFromString;
}

- (NSString*)randomStringWithLenght:(NSInteger)lenght {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: lenght];
    
    for (int i=0; i<lenght; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    
    return randomString;
}
- (CALayer*)addBorderBottomWithSize:(CGFloat)size width:(CGFloat)width height:(CGFloat)height color:(UIColor*)color {
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,height-size,width,size);
    bottomBorder.backgroundColor = color.CGColor;
    return bottomBorder;
}


- (id)showMessageView:(UIView*)view message:(NSString *)text {

    // Display a message when the table is empty
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
    
    messageLabel.text = text;
//    messageLabel.textColor = [UIColor blackColor];
    messageLabel.textColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:249.0f/255.0f alpha:0.5];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [self fontTexts:18];
    [messageLabel sizeToFit];
    
    return messageLabel;
}

-(NSData *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = height;
    float maxWidth = width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return imageData;
    
}



#pragma mark - Fraction formatter
+(NSString *)getStrings:(NSString*)key{
    
    NSString *str = [NSString stringWithFormat:NSLocalizedStringFromTable(key,@"globalStrings", nil)];
    
    return str;
}
@end