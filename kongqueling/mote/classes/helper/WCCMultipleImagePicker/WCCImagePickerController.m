//
//  WCCImagePickerController.m
//  ImagePicker
//
//  Created by sean on 13-10-12.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "WCCImagePickerController.h"
#import "WCCAsset.h"
#import "WCCAssetCell.h"
#import "WCCAssetTablePicker.h"
#import "WCCAlbumPickerController.h"

@implementation WCCImagePickerController

@synthesize delegate = _myDelegate;

- (void)cancelImagePicker
{
	if([_myDelegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[_myDelegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
}

- (void)selectedAssets:(NSArray *)assets
{
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	
	for(ALAsset *asset in assets) {
        
		NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
        if ([asset valueForProperty:ALAssetPropertyType]) {
            [workingDictionary setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
        }
        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        NSUInteger size = [assetRep size];
        uint8_t *buff = malloc(size);
        NSError *err = nil;
        NSUInteger gotByteCount = [assetRep getBytes:buff fromOffset:0 length:size error:&err];
        if (gotByteCount) {
            if (err) {
                NSLog(@"!!! Error reading asset: %@", [err localizedDescription]);
                free(buff);
            }  
        }
        NSData *data = [NSData dataWithBytesNoCopy:buff length:size freeWhenDone:YES];

        //CGImageRef imgRef = [assetRep fullResolutionImage];

        UIImage *img = [UIImage imageWithData:data];
        //UIImage *img = [UIImage imageWithCGImage:imgRef scale:[UIScreen mainScreen].scale orientation:(UIImageOrientation)assetRep.orientation];
        if (img) {
            [workingDictionary setObject:img forKey:@"UIImagePickerControllerOriginalImage"];
            [workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
            [returnArray addObject:workingDictionary];
        }
	}
    
	if(_myDelegate != nil && [_myDelegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
		[_myDelegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:[NSArray arrayWithArray:returnArray]];
	} else {
        [self popToRootViewControllerAnimated:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    NSLog(@"ELC Image Picker received memory warning.");
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc
{
    
}

@end
