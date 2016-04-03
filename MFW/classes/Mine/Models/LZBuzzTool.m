//
//  LZBuzzTool.m
//  MFW
//
//  Created by scjy on 16/3/31.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZBuzzTool.h"
#import "FMDatabase.h"

@implementation LZBuzzTool
static FMDatabase *_db;
+ (void)initialize
{
    // 1.打开数据库sqlite
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Buzz.db"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_buzz (id integer PRIMARY KEY, time text NOT NULL, content text, locality text, name text);"];
}

+ (NSArray *)buzzs{
    // 得到结果集
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_buzz;"];
    // 不断往下取数据
    NSMutableArray *buzzs = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        LZBuzz *buzz = [[LZBuzz alloc] init];
        buzz.time = [set stringForColumn:@"time"];
        buzz.content = [set stringForColumn:@"content"];
        buzz.locality = [set stringForColumn:@"locality"];
        buzz.name = [set stringForColumn:@"name"];
//        buzz.integer = [set intForColumn:@"integer"];
        [buzzs addObject:buzz];
    }
    return buzzs;
}
+ (void)addBuzz:(LZBuzz *)buzz{
    [_db executeUpdateWithFormat:@"INSERT INTO t_buzz(time, content, locality, name) VALUES (%@, %@, %@, %@);", buzz.time, buzz.content, buzz.locality ,buzz.name];
}
+ (void)deleteBuzz:(NSUInteger)indexPath{
    [_db executeUpdateWithFormat:@"DELETE FROM t_buzz WHERE interger = %u;",indexPath];
}
@end



























