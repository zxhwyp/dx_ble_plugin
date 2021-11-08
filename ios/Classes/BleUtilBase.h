//
//  BleUtilBase.h
//  Runner
//
//  Created by 周小华 on 2021/10/18.
//

#import <Foundation/Foundation.h>
#import "DXBleBean.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleSearchUtil.h"
#import "DXBleKeyBean.h"
#import <Flutter/Flutter.h>
#import "BleConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface BleUtilBase : NSObject

@property (nonatomic, strong) FlutterResult ftResult;

/*外设角色，我们当选中某个外设连接成功后，将外设对象赋值给该对象*/
@property (nonatomic, strong) DXBleBean * currentBean;

@property (nonatomic, strong) BleSearchUtil * searchUtil;
///当前指令
@property (nonatomic, strong) NSString * command;

/// 开锁：链接设备 -> 读取设备code -> 开锁
/// @param bean 蓝牙对象
- (void)openLock:(DXBleBean *)bean;

/// 设置紧急开门
/// @param bean 蓝牙对象
- (void)setKeyTask:(DXBleKeyBean *)bean;

/// 初始化锁具
/// @param bean 蓝牙对象
- (void)initBleBlock:(DXBleBean *)bean;

@end

NS_ASSUME_NONNULL_END
