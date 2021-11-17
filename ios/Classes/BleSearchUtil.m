//
//  BleUtilBase.m
//  Runner
//
//  Created by 周小华 on 2021/10/18.
//

#import "BleSearchUtil.h"

@interface BleSearchUtil()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, copy) NSString * statusInfo;

@property (nonatomic, assign) int statusCode;

@property (nonatomic, strong) FlutterResult ftResult;

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
    self.mgr.delegate = self;
}

- (void)bleStatus:(FlutterResult)result {
    int bleCode = _statusCode == 5 ? 0 : 1;
    result(@{@"code": @(bleCode), @"info": _statusInfo});
}



- (void)startScan:(NSArray *)bleNames needFilter:(BOOL)filter  result:(FlutterResult)result {
    self.ftResult = result;
    self.needfilter = filter;
    self.filters = bleNames;
    [self startScan];
}

- (void)startScan {
    if(self.mgr == nil || self.mgr.state != 5){
        self.ftResult(@{@"code": @1, @"info": @"请检查蓝牙是否开启"});
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
        self.ftResult(@{@"code": @3, @"info": @"搜索超时"});
    }
    [self.mgr stopScan];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    _statusCode = 5;
    switch (central.state) {
        case 0:
            _statusInfo = @"设备未知类型";
            _statusCode = 0;
            break;
        case 1:
            _statusInfo = @"蓝牙重置中";
            _statusCode = 0;
            break;
        case 2:
            _statusInfo = @"设备不支持蓝牙功能";
            _statusCode = 2;
            break;
        case 3:
            _statusCode = 3;
            _statusInfo = @"蓝牙功能未授权";
            break;
        case 4:
            _statusCode = 4;
            _statusInfo = @"未打开蓝牙";
            break;
        case 5:
            _statusCode = 5;
            _statusInfo = @"蓝牙已打开";
            break;
        default:
            break;
    }
    if (self.ftResult != nil) {
        self.ftResult(@{@"code": @(_statusCode), @"info": _statusInfo});
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *name = peripheral.name;
    if (name == nil || [name isEqualToString:@""]) {
        return;
    }
    
    if (!self.needfilter) {
            [self.bleDic setValue:peripheral forKey:peripheral.identifier.UUIDString];
            self.BleSearchCall(@{@"name": name, @"uuid": peripheral.identifier.UUIDString,
                                 @"rssi": RSSI });
            self.ftResult(@{@"code": @0, @"ble":@{@"name": name, @"uuid": peripheral.identifier.UUIDString,
                                              @"rssi": RSSI }});
            return;
    }
    
    if ([self.filters isKindOfClass:[NSArray class]] &&
        [self.filters containsObject:peripheral.name]) {
        [self.bleDic setValue:peripheral forKey:peripheral.identifier.UUIDString];
        self.BleSearchCall(@{@"name": name, @"uuid": peripheral.identifier.UUIDString,
                             @"rssi": RSSI
                           });
        self.ftResult(@{@"code": @0, @"ble":@{@"name": name, @"uuid": peripheral.identifier.UUIDString,
                                          @"rssi": RSSI }});
    }
}


- (void)openLock:(DXBleBean *)bean {

}

@end
