//
//  DBManager.m
//  MyAwareness
//
//  Created by luowei on 15/6/11.
//  Copyright (c) 2015 luosai. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"
#import "Defines.h"
#import "Summary.h"

@implementation DBManager

singleton_implementation(DBManager)

- (BOOL)createTable {

    BOOL res = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:PATH_OF_DB]) {
        // create it
        FMDatabase *db = [FMDatabase databaseWithPath:PATH_OF_DB];
        if ([db open]) {
            NSString *sql = @"CREATE TABLE summary ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , \
                    'content' VARCHAR(500), 'createTime' datetime default current_timestamp)";
            res = [db executeUpdate:sql];
        }
    }
    return res;
}

- (BOOL)insertContent:(NSString *)content {
    BOOL res = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:PATH_OF_DB];
    if ([db open]) {
        NSString *sql = @"insert into summary (content) values(?) ";
        res = [db executeUpdate:sql, content];
        [db close];
    }
    return res;
}

- (BOOL)updateContent:(NSString *)content byId:(NSInteger)_id{
    BOOL res = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:PATH_OF_DB];
    if ([db open]) {
        NSString *sql = @"update summary set content = ? where id = ?";
        res = [db executeUpdate:sql, content,_id];
        [db close];
    }
    return res;
}


- (NSArray *)listContent {
    NSMutableArray *data = @[].mutableCopy;
    FMDatabase *db = [FMDatabase databaseWithPath:PATH_OF_DB];
    if ([db open]) {
        NSString *sql = @"select * from summary";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            Summary *summary = [[Summary alloc] initWithCreateAt:[rs dateForColumn:@"createTime"]
                                                         content:[rs stringForColumn:@"content"]
                                                              id:@([rs intForColumn:@"id"])];
            [data addObject:summary];
        }
        [db close];
    }
    return data.count > 0 ? [NSArray arrayWithArray:data] : nil;
}

- (BOOL)clearAll {
    BOOL res = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:PATH_OF_DB];
    if ([db open]) {
        NSString *sql = @"delete from summary";
        res = [db executeUpdate:sql];
        [db close];
    }
    return res;
}

@end
