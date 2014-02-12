//
//  WCCAlbumPickerControllerViewController.m
//  ImagePicker
//
//  Created by Hayden on 13-10-12.
//  Copyright (c) 2013年 Yardlan. All rights reserved.
//

#import "WCCAlbumPickerController.h"
#import "WCCImagePickerController.h"
#import "WCCAssetTablePicker.h"

@interface WCCAlbumPickerController ()

@property (nonatomic, retain) ALAssetsLibrary *library;

@end

@implementation WCCAlbumPickerController

@synthesize parent = _parent;
@synthesize assetGroups = _assetGroups;
@synthesize library = _library;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationItem setTitle:@"相册加载中..."];
    
    UIBarButtonItem *cancelButton = [UIBarButtonItemFactory getBarButtonWithTitle:@"取消" selector:@selector(cancelImagePicker) target:self.parent];
	[self.navigationItem setRightBarButtonItem:cancelButton];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    self.library = assetLibrary;
    
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       
                       // Group enumerator Block
                       void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                       {
                           if (group == nil) {
                               return;
                           }
                           
                           // added fix for camera albums order
                           NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                           NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                           
                           if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                               [self.assetGroups insertObject:group atIndex:0];
                           }
                           else {
                               [self.assetGroups addObject:group];
                           }
                           
                           // Reload albums
                           [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                       };
                       
                       // Group Enumerator Failure Block
                       void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                           
                           UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有访问相册的权限!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                           [alert show];
                           [self dismissViewControllerAnimated:NO completion:^(void){}];
                           NSLog(@"A problem occured %@", [error description]);
                       };
                       
                       // Enumerate Albums
                       [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                                   usingBlock:assetGroupEnumerator
                                                 failureBlock:assetGroupEnumberatorFailure];
                       
                   });
}

- (void)reloadTableView
{
	[self.tableView reloadData];
	[self.navigationItem setTitle:@"选择相册"];
}

- (void)selectedAssets:(NSArray*)assets
{
	[_parent selectedAssets:assets];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	WCCAssetTablePicker *picker = [[WCCAssetTablePicker alloc] initWithNibName: nil bundle: nil];
    picker.iMaxSelected = self.iMaxSelected;
    picker.iMinSelected = self.iMinSelected;
	picker.parent = self;
    
    picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
    [picker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
	picker.assetPickerFilterDelegate = self.assetPickerFilterDelegate;
	
	[self.navigationController pushViewController:picker animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 57;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{
    
}

@end