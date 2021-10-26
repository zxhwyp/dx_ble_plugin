//
//  DXBleKeyBean.h
//  dx_ble_plugin
//
//  Created by 周小华 on 2021/10/26.
//

#import "DXBleBean.h"
@class TaskPackage;

NS_ASSUME_NONNULL_BEGIN

@interface DXBleKeyBean : DXBleBean

@property(strong, nonatomic) TaskPackage* package;

@end


@interface TaskPackage : NSObject

@property(copy, nonatomic) NSArray* lockCodes;

@property(copy, nonatomic) NSArray* areas;

@property(copy, nonatomic) NSString* startTime;

@property(copy, nonatomic) NSString* endTime;

@property(assign, nonatomic) NSInteger offLineTime;

+ (instancetype)fromJson:(NSDictionary *)map;

@end


NS_ASSUME_NONNULL_END

