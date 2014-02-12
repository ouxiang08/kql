//
//  NSString+Additions.m
//  wochacha
//
//  Created by 张 超 on 13-4-16.
//  Copyright (c) 2013年 wochacha. All rights reserved.
//

#import "NSString+Additions.h"
#import "Base64GG.h"

@implementation NSString(Additions)

- (UIImage *)decodeBase64ToSize: (CGSize) size
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    data = [Base64 decodeData:data];
    
    UIImage *image = [UIImage imageWithData: data];
    
    if ( image.size.width != size.width && image.size.height != size.height ) {
        CGSize itemSize = size;
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

- (NSString*) getQueryValueForKey:(NSString*)key
{
    NSRange range = [self rangeOfString:[NSString stringWithFormat:@"(\\?|&)%@=([^&]*)", key] options:NSRegularExpressionSearch];
    if (range.length > 0) {
        range.location++;
        range.length--;
        NSString* keyAndEqual = [NSString stringWithFormat:@"%@=", key];
        return [[self substringWithRange:range] stringByReplacingOccurrencesOfString:keyAndEqual withString:@""];
    } else {
        return nil;
    }
}

- (NSString*) changeQueryValue:(NSString*)value forKey:(NSString*)key
{
    NSRange range = [self rangeOfString:[NSString stringWithFormat:@"(\\?|&)%@=([^&]*)", key] options:NSRegularExpressionSearch];
    NSString* stringTmp = [NSString stringWithFormat:@"%@=%@", key, value];
    if (range.length > 0) {
        range.location++;
        range.length--;
        return [self stringByReplacingCharactersInRange:range withString:stringTmp];
    } else {
        if([self rangeOfString:@"?"].length > 0) {
            return [NSString stringWithFormat:@"%@&%@", self, stringTmp];
        } else {
            return [NSString stringWithFormat:@"%@?%@", self, stringTmp];
        }
    }
}

- (NSUInteger)integerValueFromHex
{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner scanHexInt:&result];
    return result;
}

+ (NSString*)countDownStringWithSeconds:(NSUInteger)seconds
{
    NSInteger day = seconds / 86400;
    NSInteger hour = seconds % 86400 / 3600;
    NSInteger minute = seconds % 3600 / 60;
    NSInteger second = seconds % 60;
    return [NSString stringWithFormat:@"%d天%2d时%2d分%2d秒",day,hour,minute,second];
}

- (NSString*)stringFitMaxLength:(NSUInteger)length
{
    if (self.length > length) {
        return [[self substringToIndex:length - 1] stringByAppendingString:@"..."];
    }
    return self;
}

-(BOOL)isNilOrBlankString{
    if (!self||[[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isNotNilOrBlankString{
    if (self&&[[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0) {
        return YES;
    }else{
        return NO;
    }
}

@end
