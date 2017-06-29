//
//  ViewController.m
//  SQLiteDemo
//
//  Created by Reborn on 22/06/2017.
//  Copyright © 2017 Reborn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end




@implementation ViewController

static sqlite3 *_dbHandle;

char *errorMsg;

static sqlite3_stmt *stmt;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self openDatabase];     //打开数据库
    
    
    [self createTable];      //创建数据表
    
    [self insertInfo];       //插入数据
    
//    [self deleteInfo];       //删除数据
    
    [self changeInfo];       //更改数据
    
    [self searchInfo];       //查询数据
    
    //[self closeDatabase];    //关闭数据库
    
    

}

-(void)openDatabase
{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/demo.db",NSHomeDirectory()];
    
    NSLog(@"路径:%@",path);
    
    if (sqlite3_open([path UTF8String], &_dbHandle)==SQLITE_OK) {
        NSLog(@"打开数据库成功!");
    }else{
        NSLog(@"error %s",sqlite3_errmsg(_dbHandle));
    }
}


-(void)closeDatabase
{

    
    if (sqlite3_close(_dbHandle)==SQLITE_OK) {
        NSLog(@"关闭数据库成功!");
    }else{
        NSLog(@"error %s",sqlite3_errmsg(_dbHandle));
    }
   
    
}


-(void)createTable
{
    const char *createString = "create table if not exists persons (id integer primary key autoincrement, name varchar(256), age integer)";
    
    BOOL result = sqlite3_exec(_dbHandle, createString, nil, nil, &errorMsg);
    if (result == SQLITE_OK) {
        NSLog(@"建表成功!");
    }
    else{
        NSLog(@"建表失败!Error:%s",errorMsg);
    }
    sqlite3_free(errorMsg);
}

-(void)insertInfo
{
    const char *insert = "insert into persons (name,age) values ('阿童木',5)";
    
    BOOL result = sqlite3_exec(_dbHandle, insert, nil, nil, &errorMsg);
    if (result == SQLITE_OK) {
        NSLog(@"插入数据成功!");
    }else{
        NSLog(@"插入数据失败! Error:%s",sqlite3_errmsg(_dbHandle));
    }
}

-(void)deleteInfo
{
    const char *delete = "delete from persons where id = 1";
    
    BOOL result = sqlite3_exec(_dbHandle, delete, nil, nil, &errorMsg);
    
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功!");
    }else{
        NSLog(@"删除数据失败!Error:%s",sqlite3_errmsg(_dbHandle));
    }
}

-(void)changeInfo
{
    const char *change = "update persons set name = '铁甲小宝' where id = 2";
    BOOL result = sqlite3_exec(_dbHandle, change, nil, nil, &errorMsg);
    
    if (result == SQLITE_OK) {
        NSLog(@"更改数据成功!");
    }else{
        NSLog(@"更改数据失败!Error:%s",sqlite3_errmsg(_dbHandle));
    }
}

-(void)searchInfo
{
    //创建数组 存数据
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    const char *select = "select * from persons where name = '阿童木'";
    
    //sqlite3_prepare_v2的参数第一个是数据库连接，第二个是sql语句，第三个是这个语句的长度传入-1表示到第一个null终止符为止，第四个是返回一个语句对象，第五个是返回一个指向该sql语句的第一个字节的指针
    int result = sqlite3_prepare_v2(_dbHandle, select, -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        
        // 每调一次sqlite3_step函数，stmt就会指向下一条记录
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            // 取出第0列字段的值（int类型的值）
            int ID = sqlite3_column_int(stmt, 0);
            
            // 取出第1列字段的值（text类型的值）
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            
            // 取出第2列字段的值（int类型的值）
            int age = sqlite3_column_int(stmt, 2);
            
            //将C字符串转换为OC字符串
            NSString *name1 = [[NSString alloc]initWithUTF8String:(const char *)name];
            
            //将model实例化 并把取出来的数据存入model
            ZTPerson *p = [[ZTPerson alloc]init];
            p.name = name1;
            p.age = age;
            p.ID = ID;
            [array addObject:p];
        }
    }else{
        NSLog(@"查询语句有问题,查询失败!");
    }
    NSLog(@"%@",array);
}


  
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
