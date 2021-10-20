//
//  DXBleBean.h
//  Runner
//
//  Created by 周小华 on 2021/10/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DXBleBean : NSObject

@property(copy, nonatomic) NSString* code;

@property(copy, nonatomic) NSString* uuid;

@property(copy, nonatomic) NSString* name;

@property(strong, nonatomic) NSNumber* rssi;

@property(copy, nonatomic, readonly) NSString* style;

+ (instancetype)fromJson:(NSDictionary *)map;

- (NSDictionary *)tojson:(DXBleBean *)bean;

@end

NS_ASSUME_NONNULL_END
