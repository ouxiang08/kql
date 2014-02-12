//
//  UIBarButtonItemFactory.m
//  wochacha
//
//  Created by sean on 12/2/13.
//  Copyright (c) 2013 wochacha. All rights reserved.
//

#import "UIBarButtonItemFactory.h"

@implementation UIBarButtonItemFactory

+(UIBarButtonItem *)getBarButtonItemWithImage:(NSString *)strImageName selector:(SEL)selector target:(id)target{
    UIImage *image = [UIImage imageNamed:strImageName];
    UIButton *buttonBar = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBar.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [buttonBar setBackgroundImage:image forState:UIControlStateNormal];
    [buttonBar addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:buttonBar];
    
    return barItem;
}

+(UIBarButtonItem *)getBarButtonWithTitle:(NSString *)strTitle selector:(SEL)selector target:(id)target{
    
    UIImage *imageDefault = [UIImage imageNamed:@"nav_bar_button_bg_normal"];
    
    if (strTitle.length!=2) {
        int length = strTitle.length - 2;
        imageDefault = [imageDefault scaleToSize:CGSizeMake(imageDefault.size.width+9*length, imageDefault.size.height)];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, imageDefault.size.width, imageDefault.size.height );
    [button setBackgroundImage:imageDefault forState:UIControlStateNormal];
    [button setTitle:strTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

@end
