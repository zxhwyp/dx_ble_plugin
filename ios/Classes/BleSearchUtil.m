//
//  BleUtilBase.m
//  Runner
//
//  Created by 周小华 on 2021/10/18.
//

#import "BleSearchUtil.h"

@interface BleSearchUtil()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, copy) NSString * statusInfo;

@end

@implementation BleSearchUtil


- (instancetype)init {
    if (self = [super init]) {
        [self initParams];
    }
    return self;
}

- (void)initParams {
    self.bleDic = [[NSMutableDictionary alloc]init];
    _mgr = [[CBCentralManager alloc] init];
}


- (void)startScan:(NSArray<NSString *> *)bleNames {
    self.filters = bleNames;
    [self startScan];
}

- (void)startScan {
    if(self.mgr == nil || self.mgr.state != 5){
        self.BleStatus(self.mgr.state, @"请检查蓝牙是否开启");
        return;
    }
    [self stopScan: @"NO"];
    [self.bleDic removeAllObjects];
    self.mgr.delegate = self;
    [self.mgr scanForPeripheralsWithServices:nil options:nil];
    [self performSelector:@selector(stopScan:) withObject:@"YES" afterDelay:6];
}

- (void)stopScan:(NSString *)over {
    if ([over isEqualToString:@"YES"]) {
        self.BleError(3, @"搜索超时");
    }
    [self.mgr stopScan];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case 0:
            _statusInfo = @"设备未知类型";
            self.BleStatus(0, _statusInfo);
            break;
        case 1:
            _statusInfo = @"蓝牙正在初始化";
            break;
        case 2:
            _statusInfo = @"设备不支持蓝牙功能";
            self.BleStatus(2, _statusInfo);
            break;
        case 3:
            _statusInfo = @"蓝牙功能未授权";
            self.BleStatus(3, _statusInfo);
            break;
        case 4:
            _statusInfo = @"未打开蓝牙";
            self.BleStatus(4, _statusInfo);
            break;
        case 5:
            _statusInfo = @"蓝牙已开启";
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *name = peripheral.name;
    if (name == nil || [name isEqualToString:@""]) {
        return;
    }
    if (self.filters == nil || self.filters.count == 0) {
        return;
//        [self.bleDic setValue:peripheral forKey:peripheral.identifier.UUIDString];
//        self.BleSearchCall(@{@"name": name, @"uuid": peripheral.identifier.UUIDString,
//                             @"rssi": RSSI
//                           });
//        return;
    }
    
    if ([self.filters containsObject:peripheral.name]) {
        [self.bleDic setValue:peripheral forKey:peripheral.identifier.UUIDString];
        self.BleSearchCall(@{@"name": name, @"uuid": peripheral.identifier.UUIDString,
                             @"rssi": RSSI
                           });
    }
}


- (void)openLock:(DXBleBean *)bean {

}

@end
