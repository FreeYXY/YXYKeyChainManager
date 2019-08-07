//
//  YXYKeyChainManager.m
//  PrivilegeGo
//
//  Created by YXY on 2017/7/13.
//  Copyright © 2017年 Techwis. All rights reserved.
//

#import "YXYKeyChainManager.h"

@implementation YXYKeyChainManager

/**
 创建生成保存数据查询条件
 
 @param service 数据存储时的标示
 @return 返回数据查询条件
 */
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (BOOL)save:(NSString *)service data:(id)data {
    // 获取存储的数据的条件
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    // 删除旧的数据
    SecItemDelete((CFDictionaryRef)keychainQuery);
    // 设置新的数据
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    // 添加数据
    OSStatus saveState = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    // 释放对象
    keychainQuery = nil;
    // 判断是否存储成功
    if (saveState == errSecSuccess) {
        return YES;
    }
    return NO;
}

+ (id)load:(NSString *)service {
    id ret = nil;
    // 通过标记获取数据查询条件
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    // 这是获取数据的时，必须提供的两个属性
    // TODO: 查询结果返回到 kSecValueData
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    // TODO: 只返回搜索到的第一条数据
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    // 创建一个数据对象
    CFDataRef keyData = NULL;
    // 通过条件查询数据
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData) CFRelease(keyData);
    // 释放对象
    keychainQuery = nil;
    return ret;
}

+(BOOL)update:(id)data service:(NSString *)service {
    // 通过标记获取数据更新的条件
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:service];
    // 创建更新数据字典
    NSMutableDictionary * updataMutableDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    // 存储数据
    [updataMutableDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    // 获取存储的状态
    OSStatus  updataStatus = SecItemUpdate((CFDictionaryRef)keychainQuery, (CFDictionaryRef)updataMutableDictionary);
    // 释放对象
    keychainQuery = nil;
    updataMutableDictionary = nil;
    // 判断是否更新成功
    if (updataStatus == errSecSuccess) {
        return  YES ;
    }
    return NO;
}

+ (void)deleteKeyData:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    // 释放内存
    keychainQuery = nil ;
}

@end

