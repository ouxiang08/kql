//
//  DatabaseHelper.m
//
//  Created by sean on 11/21/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "DatabaseHelper.h"

@implementation DatabaseHelper

//open database,if database is not exists, then create
-(BOOL)openDatabase:(TableType)tableType{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);     
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *strTableName;
    if (tableType == kAlbumTable) {
        strTableName = @"album.sql";
    }
    
	NSString *path = [documentsDirectory stringByAppendingPathComponent:strTableName];     
	NSFileManager *fileManager = [NSFileManager defaultManager];     
	BOOL find = [fileManager fileExistsAtPath:path];     
	
	if (find) {        
		//NSLog(@"Database file have already existed.");         
		if(sqlite3_open([path UTF8String], &database) != SQLITE_OK) {             
			sqlite3_close(database);             
			NSLog(@"Error: open database file.");             
			return NO;        
		}         
		return YES;    
	}     
	
	//NSLog(@"database is not found.");
	
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		[self createAlbumTable :database];
		return YES;
	} else {
		sqlite3_close(database); 
        NSLog(@"Error: open database file.");   
		return NO;
	} 
    return NO;
}

#pragma mark - album table operate
-(BOOL)createAlbumTable:(sqlite3*)db{
    sqlite3_stmt *statement;
	char *sql ="CREATE TABLE album(aid integer primary key,name text,ipubflag integer,count integer,homeImgPath text)";
	if(sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK) {  
		NSLog(@"Error: failed to prepare statement:create channels table");         
		return NO; 
    }   
	int success = sqlite3_step(statement);
	
	sqlite3_finalize(statement); 
    if ( success != SQLITE_DONE) {
		NSLog(@"Error: failed to dehydrate:CREATE TABLE album"); 
        return NO;   
	}
    
	return YES;
}

-(BOOL)deleteAlbumTable{
    [self openDatabase:kAlbumTable];
	char *sql;
	sqlite3_stmt *statement=nil;
	int success;
	
    sql ="delete from album";
    if(sqlite3_prepare_v2(database, sql, -1, &statement, nil) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement:create album table");
        return NO;
    }
    
    success = sqlite3_step(statement);
    
    if (success != SQLITE_DONE) {
        NSLog(@"Error: failed to insert");
        return NO;
    }
	
	sqlite3_finalize(statement);
	sqlite3_close(database);
	
	return TRUE;
}

-(BOOL)insertAlbumTable:(AlbumModel *)albumModel{
    [self openDatabase:kAlbumTable];
	char *sql;
	sqlite3_stmt *statement=nil;
	int success;
	
    sql ="insert into album(aid,name,ipubflag,count,homeImgPath) values(?,?,?,?,?)";
    if(sqlite3_prepare_v2(database, sql, -1, &statement, nil) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement:create album table");
        return NO;
    }

    sqlite3_bind_int(statement, 1, albumModel.aid);
    sqlite3_bind_text(statement, 2, [albumModel.strAlbumName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 3, albumModel.iPubFlag);
    sqlite3_bind_int(statement, 4, albumModel.count);
    sqlite3_bind_text(statement, 5, [albumModel.strHomeImgPath UTF8String], -1, SQLITE_TRANSIENT);
    success = sqlite3_step(statement);
    
    if (success != SQLITE_DONE) {
        NSLog(@"Error: failed to insert");
        return NO;
    }
	
	sqlite3_finalize(statement);
	sqlite3_close(database);
	
	return TRUE;
}

-(NSMutableArray *)selectAlbums{
    [self openDatabase:kAlbumTable];
    
    NSMutableArray *arrResult = [[NSMutableArray alloc]init];
	sqlite3_stmt *statement = nil;
	NSString *sql = [[NSString alloc]initWithFormat:@"select * from album order by aid desc"];
	
	if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
		NSLog(@"Error: failed to prepare statement with message:get items.");
	}
    
	while (sqlite3_step(statement) == SQLITE_ROW) {
        AlbumModel *albumModel = [[AlbumModel alloc] init];
		albumModel.aid = sqlite3_column_int(statement, 0);
        albumModel.strAlbumName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        albumModel.iPubFlag = sqlite3_column_int(statement, 2);
        albumModel.count = sqlite3_column_int(statement, 3);
        albumModel.strHomeImgPath = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];

        [arrResult addObject:albumModel];
	}
	
    sqlite3_finalize(statement);
	sqlite3_close(database);
    
	return arrResult;

}

-(BOOL)setAlbumHomePath:(AlbumModel *)model{
    [self openDatabase:kAlbumTable];
	sqlite3_stmt *statement = nil;
	NSString *sql = [[NSString alloc]initWithFormat:@"update album set homeImgPath=? where aid=?"];
	
	if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
		NSLog(@"Error: failed to prepare statement with message:get items.");
	}
    
    sqlite3_bind_text(statement, 1, [model.strHomeImgPath UTF8String], -1, SQLITE_TRANSIENT);
     sqlite3_bind_int(statement, 2, model.aid);
    
	BOOL success = sqlite3_step(statement);
    sqlite3_finalize(statement);
	sqlite3_close(database);
    
	return success;
}

@end