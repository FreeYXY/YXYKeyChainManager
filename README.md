# YXYKeyChainManager

[iOS KeyChain(钥匙串)介绍](https://www.jianshu.com/p/a73a86a3a569)

一、Cocopods使用方式
```
pod 'YXYKeyChainManager', '~> 0.0.1'
```

二、API简介
```

/**
 数据存储
 
 @param service 数据存储时的标示
 @return 是否存储成功
 */
+ (BOOL)save:(NSString *)service data:(id)data;

/**
 数据查询
 
 @param service 数据存储时的标示
 @return 查询到的数据
 */
+ (id)load:(NSString *)service;

/**
 更新数据
 
 @param data 要更新的数据
 @param service 数据存储时的标示
 @return 是否更新成功
 */
+(BOOL)update:(id)data service:(NSString *)service;

/**
 删除数据
 
 @param service 数据存储时的标示
 */
+ (void)deleteKeyData:(NSString *)service;
```

三、API使用示例
```
#pragma mark - 获取本地存储的uuid，如果尚未存储则取出uuid存储
+ (NSString *)uuid {
    static NSString * const IDFVKEY = @"PrivilegeGoIDFV";
    NSString *uuid = (NSString *)[YXYKeyChainManager load:IDFVKEY];
    if ([uuid isEqualToString:@""] || !uuid) {
        uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
        uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [YXYKeyChainManager save:IDFVKEY data:uuid];
    }
    return uuid;
}
```
