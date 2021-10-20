//
//  BleUtilBase.h
//  Runner
//
//  Created by 周小华 on 2021/10/18.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DXBleBean.h"

NS_ASSUME_NONNULL_BEGIN

@interface BleSearchUtil : NSObject

@property(copy, nonatomic) void(^BleError)(NSInteger code,NSString *errorInfo);

@property(copy, nonatomic) void(^BleStatus)(NSInteger status, NSString * _Nullable info);

@property(copy, nonatomic) void(^BleSearchCall)(NSDictionary * _Nullable ble);

@property (nonatomic, copy) NSArray<NSString *> *filters;

/*中心角色*/
@property (nonatomic, strong) CBCentralManager *mgr;

@property (nonatomic, strong) NSMutableDictionary<NSString *, CBPeripheral *>* bleDic;

/// 蓝牙搜索
/// @param bleNames 需要搜索的蓝牙名字
- (void)startScan:(NSArray *)bleNames;

@end

NS_ASSUME_NONNULL_END
