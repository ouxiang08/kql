//
//  DatabaseHelper.h
//
//  Created by sean on 11/21/13.
//  Copyright (c) 2013 zlm. All rights reserved.

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "AlbumModel.h"

typedef enum{
    kAlbumTable = 0
}TableType;

@interface DatabaseHelper : NSObject {
	sqlite3 *database;
}

-(BOOL)createAlbumTable:(sqlite3*)db;
-(BOOL)insertAlbumTable:(AlbumModel *)albumModel;
-(NSMutableArray *)selectAlbums;
-(BOOL)deleteAlbumTable;
-(BOOL)setAlbumHomePath:(AlbumModel *)model;

@end
