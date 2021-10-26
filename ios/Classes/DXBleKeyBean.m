//
//  DXBleKeyBean.m
//  dx_ble_plugin
//
//  Created by 周小华 on 2021/10/26.
//

#import "DXBleKeyBean.h"

@interface DXBleKeyBean()

@end

@implementation DXBleKeyBean

+(instancetype)fromJson:(NSDictionary *)map {
    
    DXBleKeyBean *bean = [[DXBleKeyBean alloc]init];
    if (map != nil && [map isKindOfClass:[NSDictionary class]]) {
        bean.code = [map valueForKey:@"code"];
        bean.name = [map valueForKey:@"name"];
        bean.uuid = [map valueForKey:@"uuid"];
        bean.style = [map valueForKey:@"style"];
        bean.rssi = [map valueForKey:@"rssi"];
        bean.package = [TaskPackage fromJson:[map valueForKey:@"package"]];
    }
    return bean;
}

@end

@implementation TaskPackage

+(instancetype)fromJson:(NSDictionary *)map {
    TaskPackage *bean = [[TaskPackage alloc]init];
    if (map != nil && [map isKindOfClass:[NSDictionary class]]) {
        bean.lockCodes = [map valueForKey:@"lockCodes"];
        bean.areas = [map valueForKey:@"areas"];
        bean.startTime = [map valueForKey:@"startTime"];
        bean.endTime = [map valueForKey:@"endTime"];
        bean.offLineTime = [[map valueForKey:@"offlineTime"] integerValue];
    }
    return bean;
}

@end
