//
//  BleUtil.m
//  Runner
//
//  Created by 周小华 on 2021/10/13.
//

#import "CLBleUtil.h"
#import <HNTT01CLProtocol/HNTT01CLProtocol.h>
@interface CLBleUtil()<hntt01BleLockCallBackDelegate>

@property (nonatomic, strong) HNTT01BleLock * hnBleLock;

/// 是否是蓝牙钥匙
@property (nonatomic, assign) BOOL isKey;

@end

@implementation CLBleUtil

- (instancetype)initWithType:(BOOL)isKey {
    if (self = [super init]) {
        _isKey = isKey;
        [self initCLParams];
    }
    return self;
}

- (void)initCLParams {
    _hnBleLock = [[HNTT01BleLock alloc]init];
    _hnBleLock.delegate = self;
}


#pragma 通过厂家蓝牙sdk操作蓝牙
- (void)openLock:(DXBleBean *)bean {
    self.currentBean = bean;
    //连接
    [self connectBle:bean];
}

- (void)setKeyTask:(DXBleKeyBean *)bean {
    self.currentBean = bean;
    //连接
    [self connectBle:bean];
}
///初始化锁具
- (void)initBleBlock:(DXBleBean *)bean{
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
    [_hnBleLock bleConnectWithPeripheral:ble manager:self.searchUtil.mgr secretKey:@"xW2Nr5QZHxTLC06v" secretLock:@"47111C334E043030BDAB3931" userID:@"34953" isKeyDevice: _isKey];
}

- (void)readBleInfo {
    [_hnBleLock readLockCode];
}
///初始化钥匙
- (void)initKey {
    [_hnBleLock keyInit];
}

/// 实际做开锁的功能
- (void)doOpenLock:(DXBleBean *)bean {
    //结束时间66年
    NSDate *end = [NSDate dateWithTimeIntervalSinceNow:66 * 365 * 24 * 60 * 60];
    [_hnBleLock openLockWithLockCode:bean.code startTime:[NSDate date] endTime:end];
}


- (void)doSetKeyTask {
    DXBleKeyBean *key = (DXBleKeyBean *) self.currentBean;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *start = [formatter dateFromString:key.package.startTime];
    NSDate *end = [formatter dateFromString:key.package.endTime];
    [_hnBleLock setTaskWithLockCodes:key.package.lockCodes areas:key.package.areas startTime:start endTime:end offLineTime:key.package.offLineTime];
}
///初始化锁具
- (void)doInitLock {
    if (self.currentBean.code == nil) {
        self.ftResult(@{@"code":@1, @"msg":@"请传入锁具编码"});
        return;
    }
    [_hnBleLock lockCodeInit:self.currentBean.code];
}

#pragma mark -- 厂商蓝牙锁回调
- (void)hntt01BleLockCallBackDelegate:(NSDictionary *)dic {
    NSString *idt = [NSString stringWithFormat:@"%@", [dic valueForKey:@"idt"]];
    NSString *ret = [NSString stringWithFormat:@"%@", [dic valueForKey:@"ret"]];

    //连接回调
    if ([idt hasPrefix:@"02"]) {
        [self connectCallback:[ret isEqualToString:@"true"] param:dic];
        return;
    }
    //钥匙初始化回调
    if ([idt hasPrefix:@"05"]) {
        [self initKeyCallback:[ret isEqualToString:@"true"] param:dic];
        return;
    }
    //读取锁编码
    if ([idt hasPrefix:@"09"]) {
        [self readLockCodeCallback:[ret isEqualToString:@"true"] param:dic];
        return;
    }
    //开锁回调
    if ([idt hasPrefix:@"10"]) {
        [self openLockCallback:[ret isEqualToString:@"true"] param:dic];
        return;
    }
    ///设置钥匙task回调
    if ([idt hasPrefix:@"11"]) {
        [self setTaskCallback:[ret isEqualToString:@"true"] param:dic];
        return;
    }

    if ([idt hasPrefix:@"08"]) {
        [self initLockCallback:[ret isEqualToString:@"true"] param:dic];
        return;
    }
}

/// 蓝牙连接回调
- (void)connectCallback:(BOOL)result param:(NSDictionary *)dic {
    
    @try {
        if (!result) {
            self.ftResult(@{@"code":@1, @"msg":@"蓝牙连接失败"});
            self.OpenLockCall(1, @"蓝牙连接失败");
            return;
        }
        if ([self.command isEqual:METHOD_SET_KEY_TASK]) {
            [self initKey];
        } else if ([self.command isEqual:METHOD_OPENLOCK]) {
            [self readBleInfo];
        }else if ([self.command isEqual:METHOD_INIT_BLE_LOCK]) {
            [self doInitLock];
        }
    } @catch (NSException *exception) {
        if ([self.command isEqual:METHOD_SET_KEY_TASK]) {
            self.SetKeyTaskCall(3, @"设置蓝牙钥匙信息失败");
        } else if ([self.command isEqual:METHOD_OPENLOCK]) {
            self.OpenLockCall(1, @"蓝牙连接失败");
        }
        self.ftResult(@{@"code":@1, @"msg":@"蓝牙连接失败"});
    }
  
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
    self.ftResult(@{@"code":@2, @"msg":@"蓝牙信息读取失败"});
    [_hnBleLock bleDisConnect];
}
///钥匙初始化回调
- (void)initKeyCallback:(BOOL)result param:(NSDictionary *)dic {
    if (result) {
        [self doSetKeyTask];
        return;
    }
    self.SetKeyTaskCall(2, @"蓝牙钥匙初始化失败");
    self.ftResult(@{@"code":@2, @"msg":@"蓝牙钥匙初始化失败"});

}
///  开锁回调
- (void)openLockCallback:(BOOL)result param:(NSDictionary *)dic {
    if (result) {
        self.OpenLockCall(0, @"蓝牙开锁成功");
        self.ftResult(@{@"code":@0, @"msg":@"蓝牙开锁成功"});
        return;
    }
    self.OpenLockCall(3, @"蓝牙开锁失败");
    self.ftResult(@{@"code":@3, @"msg":@"蓝牙开锁失败"});
    [_hnBleLock bleDisConnect];
}
///  设置钥匙task回调
- (void)setTaskCallback:(BOOL)result param:(NSDictionary *)dic {
    if (result) {
        self.SetKeyTaskCall(0, @"设置蓝牙钥匙信息成功");
        self.ftResult(@{@"code":@0, @"msg":@"设置蓝牙钥匙信息成功"});
        return;
    }
    self.SetKeyTaskCall(3, @"设置蓝牙钥匙信息失败");
    self.ftResult(@{@"code":@3, @"msg":@"设置蓝牙钥匙信息失败"});
}

///初始化锁具回调
- (void)initLockCallback:(BOOL)result param:(NSDictionary *)dic {
    if (result) {
        self.ftResult(@{@"code":@0, @"msg":@"初始化锁具成功"});
        return;
    }
    self.ftResult(@{@"code":@3, @"msg":@"初始化锁具失败"});
}

@end
