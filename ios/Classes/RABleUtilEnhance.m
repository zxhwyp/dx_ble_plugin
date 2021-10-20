//
//  RABleUtilNew.m
//  Runner
//
//  Created by 周小华 on 2021/10/19.
//

#import "RABleUtilEnhance.h"

@implementation RABleUtilEnhance

- (instancetype)init {
    if (self = [super init]) {
        [self initParams];
    }
    return self;
}

- (void)initParams {
    
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

}

- (void)readBleInfo {
}

/// 实际做开锁的功能
- (void)doOpenLock:(DXBleBean *)bean {
    //结束时间66年
    NSDate *end = [NSDate dateWithTimeIntervalSinceNow:66 * 365 * 24 * 60 * 60];
}

#pragma mark -- 厂商蓝牙锁回调
- (void)hntt01BleLockCallBackDelegate:(NSDictionary *)dic {
    NSString *idt = [NSString stringWithFormat:@"%@", [dic valueForKey:@"idt"]];
    NSString *ret = [NSString stringWithFormat:@"%@", [dic valueForKey:@"ret"]];

    //连接回调
    if ([idt isEqualToString:@"0202"]) {
        [self connectCallback:[ret isEqualToString:@"true"] param:dic];
        return;
    }
    //读取锁编码
    if ([idt isEqualToString:@"0902"]) {
        [self readLockCodeCallback:[ret isEqualToString:@"true"] param:dic];
        return;
    }
    //开锁回调
    if ([idt hasPrefix:@"1002"]) {
        [self openLockCallback:[ret isEqualToString:@"true"] param:dic];
        return;
    }
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
