//
//  RABleUtilOld.m
//  Runner
//
//  Created by 周小华 on 2021/10/19.
//

#import "RABleUtilSimple.h"
#import <RayonicsSimpleKeySDK/RayonicsSimpleKeySDKKit.h>

static NSString * const kSecretKey = @"36363636";

@interface RABleUtilSimple()<RASimpleKeySDKDelegate>

@property (nonatomic, strong) CBPeripheral *currentBle;

@end

@implementation RABleUtilSimple

- (instancetype)initWithSearchUtil:(BleSearchUtil *)search {
    if (self = [super init]) {
        self.searchUtil = search;
        [self initParams];
    }
    return self;
}

- (void)initParams {
    [RASimpleKeySDK sharedManager].delegate = self;
}


#pragma 通过厂家蓝牙sdk操作蓝牙

- (void)openLock:(DXBleBean *)bean {
    self.currentBean = bean;
    //连接
    [self connectBle:bean];
}


- (void)connectBle:(DXBleBean *)bean {
    CBPeripheral *ble = [self.searchUtil.bleDic valueForKey:bean.uuid];
    if (ble == nil) {
        self.OpenLockCall(1, @"未知设备");
        return;
    }
    _currentBle = ble;
    [RASimpleKeySDK setManager:self.searchUtil.mgr peripheral: _currentBle];

    ///TODO 接入厂家自己的设备连接逻辑
    [[RASimpleKeySDK sharedManager] bleConnect:self.searchUtil.mgr peripheral:_currentBle];
}

- (void)readBleInfo {
    ///TODO 接入厂家自己的设备读取逻辑
    [[RASimpleKeySDK sharedManager] readKeyInfo];
}

/// 实际做开锁的功能
- (void)doOpenLock:(DXBleBean *)bean {
    ///TODO 接入厂家自己的设备开锁逻辑
    //结束时间66年
    NSInteger start = (NSInteger)[[NSDate date] timeIntervalSince1970];
    NSString *startStr = [NSString stringWithFormat:@"%ld", start];
    NSInteger end = (NSInteger)[NSDate dateWithTimeIntervalSinceNow:66 * 365 * 24 * 60 * 60];
    NSString *endStr = [NSString stringWithFormat:@"%ld", end];
    [[RASimpleKeySDK sharedManager] OpenLock:bean.code secretLock:kSecretKey userID:@"02" startTime:startStr endTime:endStr];
}

#pragma mark -- 厂商蓝牙锁回调

#pragma mark - RASimpleKeySDKDelegate

- (void)simpleKeySDKCallBack:(NSDictionary *)retData {

    NSLog(@"@169:ret data : %@", retData);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *idt = [NSString stringWithFormat:@"%@", [retData valueForKey:@"idt"]];
        NSString *ret = [NSString stringWithFormat:@"%@", [retData valueForKey:@"ret"]];

        //连接回调
        if ([idt isEqualToString:@"0202"]) {
            [self connectCallback:[ret isEqualToString:@"true"] param:retData];
            return;
        }
        //读取锁编码
        if ([idt isEqualToString:@"0902"]) {
            [self readLockCodeCallback:[ret isEqualToString:@"true"] param:retData];
            return;
        }
        //开锁回调
        if ([idt hasPrefix:@"1002"]) {
            [self openLockCallback:[ret isEqualToString:@"true"] param:retData];
            return;
        }
    });
}

/// 蓝牙连接回调
- (void)connectCallback:(BOOL)result param:(NSDictionary *)dic {
    if (result) {
        [self readBleInfo];
        return;
    }
    self.OpenLockCall(1, @"蓝牙连接失败");
}
/// 读取锁编码
- (void)readLockCodeCallback:(BOOL)result param:(NSDictionary *)dic {
    NSDictionary *codeDic = [dic objectForKey:@"obj"];
    NSString *code = [codeDic objectForKey:@"lockCode"];

    if (result && code != nil) {
        self.currentBean.code = code;
        [self doOpenLock: self.currentBean];
        return;
    }
    self.OpenLockCall(2, @"蓝牙信息读取失败");
}
///  开锁回调
- (void)openLockCallback:(BOOL)result param:(NSDictionary *)dic {
    if (result) {
        self.OpenLockCall(0, @"蓝牙开锁成功");
        return;
    }
    self.OpenLockCall(3, @"蓝牙开锁失败");
}

@end
