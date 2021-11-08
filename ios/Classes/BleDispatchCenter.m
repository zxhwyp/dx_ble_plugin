//
//  BleUtil.m
//  Runner
//
//  Created by 周小华 on 2021/10/13.
//

#import "BleDispatchCenter.h"
#import "CLBleUtil.h"
#import "BleConst.h"
#import "DXBleBean.h"
#import "BleUtilBase.h"
#import "RABleUtilEnhance.h"
#import "RABleUtilSimple.h"
#import "DXBleKeyBean.h"

@interface BleDispatchCenter()

@property(strong, nonatomic) BleSearchUtil* bleSearchUtil;

@property(strong, nonatomic) BleUtilBase* bleUtil;

@property (nonatomic, strong) NSString * command;

@property (nonatomic, strong) FlutterResult ftResult;

@end

@implementation BleDispatchCenter


+ (instancetype) shareInstance {
    static BleDispatchCenter *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BleDispatchCenter alloc]init];
        [_sharedInstance initBleSearchUtil];
    });
    return _sharedInstance;
}

- (void)flutterMethodCallHandler:(FlutterMethodCall *)call FlutterResult:(FlutterResult)result {
    self.command = call.method;
    self.ftResult = result;
    if ([call.method isEqualToString: METHOD_SEARCHBLE]) {
        NSArray *names = (NSArray *)call.arguments;
        [self startScan: names];
        result(@1);
        return;
    }
    
    if ([call.method isEqualToString: METHOD_OPENLOCK]) {
        DXBleBean *bean = [DXBleBean fromJson: call.arguments];
        [self openLock:bean];
        return;
    }
    
    if ([call.method isEqualToString: METHOD_SET_KEY_TASK]) {
        DXBleKeyBean *bean = [DXBleKeyBean fromJson: call.arguments];
        [self setKeyTask: bean];
        return;
    }
    
    if ([call.method isEqualToString: METHOD_INIT_BLE_LOCK]) {
        DXBleBean *bean = [DXBleBean fromJson: call.arguments];
        [self initBleLock: bean];
        return;
    }
    result(@0);
}


/// 蓝牙搜索: 根据平台初始化对应的蓝牙sdk -> 开始搜索
/// @param bleNames 需要搜索的蓝牙名字
- (void)startScan:(NSArray *)bleNames {
    [_bleSearchUtil startScan: bleNames];
}

/// 开锁：链接设备 -> 读取设备code -> 开锁
/// @param bean 蓝牙对象
- (void)openLock:(DXBleBean *)bean {
    [self initBleutil:bean];
    __weak typeof(self) weakself = self;
    _bleUtil.OpenLockCall = ^(NSInteger code, NSString * _Nonnull errorInfo) {
        [weakself.bleChannel invokeMethod:CALL_OPENLOCK arguments: @{@"@code": @(code), @"info": errorInfo}];
    };
    [_bleUtil openLock: bean];
}
//初始化锁具
- (void)initBleLock:(DXBleBean *)bean {
    [self initBleutil:bean];
    [_bleUtil initBleBlock:bean];
}

/// 设置蓝牙钥匙指令用于开门：链接设备 -> 读取设备code -> 开锁
/// @param bean 蓝牙钥匙对象
- (void)setKeyTask:(DXBleKeyBean *)bean {
    [self initBleutil: bean];
    __weak typeof(self) weakself = self;
    _bleUtil.SetKeyTaskCall = ^(NSInteger code, NSString * _Nonnull errorInfo) {
        [weakself.bleChannel invokeMethod:CALL_SETKEYTASK arguments: @{@"@code": @(code), @"info": errorInfo}];
    };
    [_bleUtil setKeyTask:bean];
}


- (void)initBleSearchUtil {
    __weak typeof(self) weakself = self;
    _bleSearchUtil = [[BleSearchUtil alloc] init];
    _bleSearchUtil.BleError = ^(NSInteger code, NSString * _Nonnull errorInfo) {
        [weakself.bleChannel invokeMethod:CALL_ERROR arguments:@{@"@code": @(code), @"info": errorInfo}];
    };
    
    _bleSearchUtil.BleStatus = ^(NSInteger status, NSString * info) {
        [weakself.bleChannel invokeMethod:CALL_STATUS arguments:@{@"info": info, @"status": @(status)}];
    };
    
    _bleSearchUtil.BleSearchCall = ^(NSDictionary * bles) {
        [weakself.bleChannel invokeMethod:CALL_SEARCH arguments:bles];
    };

}

- (void)initBleutil:(DXBleBean *)bean {
    if ([bean.style isEqualToString: BLE_CL]) {
        _bleUtil = [[CLBleUtil alloc] initWithType:false];
    }else if ([bean.style isEqualToString: BLE_CL_KEY]) {
        _bleUtil = [[CLBleUtil alloc] initWithType:true];
    }else if ([bean.style isEqualToString: BLE_RUIAO_Enhance]) {
        _bleUtil = [[RABleUtilEnhance alloc] init];
    }else if ([bean.style isEqualToString: BLE_RUIAO_Simple]) {
        _bleUtil = [[RABleUtilSimple alloc] initWithSearchUtil:_bleSearchUtil];
    }
    _bleUtil.searchUtil = _bleSearchUtil;
    _bleUtil.command = self.command;
    _bleUtil.ftResult = self.ftResult;
}

@end
