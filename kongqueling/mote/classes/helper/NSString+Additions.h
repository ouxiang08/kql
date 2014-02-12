//
//  NSString+Additions.h
//  wochacha
//
//  Created by 张 超 on 13-4-16.
//  Copyright (c) 2013年 wochacha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (UIImage *)decodeBase64ToSize: (CGSize) size;

// get url parameter
- (NSString*) getQueryValueForKey:(NSString*)key;

- (NSString*) changeQueryValue:(NSString*)value forKey:(NSString*)key;

// [@"FF" integerValueFromHex] == 255
- (NSUInteger)integerValueFromHex;

+ (NSString*)countDownStringWithSeconds:(NSUInteger)seconds;

- (NSString*)stringFitMaxLength:(NSUInteger)length;// 5.8.5

-(BOOL)isNilOrBlankString;

-(BOOL)isNotNilOrBlankString;

@end
