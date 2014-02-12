//
//  UIBarButtonItemFactory.h
//  wochacha
//
//  Created by sean on 12/2/13.
//  Copyright (c) 2013 wochacha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIBarButtonItemFactory : NSObject

+(UIBarButtonItem *)getBarButtonItemWithImage:(NSString *)strImageName selector:(SEL)selector target:(id)target;

+(UIBarButtonItem *)getBarButtonWithTitle:(NSString *)strTitle selector:(SEL)selector target:(id)target;

@end
