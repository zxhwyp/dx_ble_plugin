//
//  BleUtilBase.h
//  Runner
//
//  Created by 周小华 on 2021/10/18.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DXBleBean.h"
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BleSearchUtil : NSObject

@property(copy, nonatomic) void(^BleSearchCall)(NSDictionary * _Nullable ble);

@property (nonatomic, copy) NSArray<NSString *> *filters;
/// 是否需要按名字过滤，默认是
@property (nonatomic, assign) BOOL needfilter;

/*中心角色*/
@property (nonatomic, strong) CBCentralManager *mgr;

@property (nonatomic, strong) NSMutableDictionary<NSString *, CBPeripheral *>* bleDic;

- (void)bleStatus:(FlutterResult)result;

/// 蓝牙搜索
/// @param bleNames 需要搜索的蓝牙名字
- (void)startScan:(NSArray *)bleNames needFilter:(BOOL)filter  result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
