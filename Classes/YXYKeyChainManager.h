//
//  YXYKeyChainManager.h
//  PrivilegeGo
//  钥匙串工具类
//  Created by YXY on 2019/8/6.
//  Copyright © 2019 Techwis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXYKeyChainManager : NSObject

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

@end

NS_ASSUME_NONNULL_END
