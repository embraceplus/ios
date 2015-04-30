//
//  ArchiveFile.m
//  Ucard
//
//  Created by Ucard on 14-3-13.
//  Copyright (c) 2014年 Orange. All rights reserved.
//

#import "ArchiveFile.h"

@implementation ArchiveFile

+ (void)archiveDocumentWithRootObject:(NSMutableArray *)brr FileName:(NSString *)name
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr objectAtIndex:0];
    NSString *s = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];
    [NSKeyedArchiver archiveRootObject:brr toFile:s];
    
    NSLog(@"%@",path);
}

+ (NSMutableArray *)readDocumentWithFileName:(NSString *)name
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr objectAtIndex:0];
    NSLog(@"%@",path);
    NSString *s = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];
    //创建一个文件管理器判断文件是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //如果存在就读取
    if([fileManager fileExistsAtPath:s])
    {
        //如果读取成功就返回数据
        if([NSKeyedUnarchiver unarchiveObjectWithFile:s])
        {
            NSMutableArray *brr = [NSKeyedUnarchiver unarchiveObjectWithFile:s];
            return brr;
        }
        else
            return nil;
    }
    else
        return nil;
}

+ (NSArray *)getFilelistFromDocument
{
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr objectAtIndex:0];
    
    NSFileManager* fm=[NSFileManager defaultManager];
    if(![fm fileExistsAtPath:path]){
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //取得一个目录下得所有文件名
    
    NSArray *files = [fm subpathsAtPath:path];
    return files;
}

@end
