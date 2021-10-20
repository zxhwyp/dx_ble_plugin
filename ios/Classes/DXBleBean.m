//
//  DXBleBean.m
//  Runner
//
//  Created by 周小华 on 2021/10/14.
//

#import "DXBleBean.h"

@interface DXBleBean()

@property(copy, nonatomic) NSString* style;

@end

@implementation DXBleBean

+(instancetype)fromJson:(NSDictionary *)map {
    DXBleBean *bean = [[DXBleBean alloc]init];
    if (map != nil && [map isKindOfClass:[NSDictionary class]]) {
        bean.code = [map valueForKey:@"code"];
        bean.name = [map valueForKey:@"name"];
        bean.uuid = [map valueForKey:@"uuid"];
        bean.style = [map valueForKey:@"style"];
        bean.rssi = [map valueForKey:@"rssi"];
    }
    return bean;
}

- (NSDictionary *)tojson:(DXBleBean *)bean {
    NSMutableDictionary *dic = @{}.mutableCopy;
    if (bean.name != nil) {
        [dic setValue:bean.name forKey:@"name"];
    }
    if (bean.code != nil) {
        [dic setValue:bean.code forKey:@"code"];
    }
    if (bean.uuid != nil) {
        [dic setValue:bean.uuid forKey:@"uuid"];
    }
    if (bean.rssi != nil) {
        [dic setValue:bean.rssi forKey:@"rssi"];
    }
    if (bean.style != nil) {
        [dic setValue:bean.style forKey:@"style"];
    }
    return dic;
}

@end
