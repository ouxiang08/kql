//
//  MyArtListTableViewCell.h
//  mote
//
//  Created by sean on 11/16/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyArtListTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *imageViewAlbumLogo;
@property(nonatomic, strong) IBOutlet UILabel *labelAlbumName;
@property(nonatomic, strong) IBOutlet UILabel *labelOpenLevel;

@end
