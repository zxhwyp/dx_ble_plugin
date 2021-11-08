//
//  BleModel.h
//  Runner
//
//  Created by 周小华 on 2021/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BleModel : NSObject

@property(copy, nonatomic) NSString *name;

@property(strong, nonatomic) NSNumber *rssi;

@property(copy, nonatomic) NSString *UUIDString;

@end


@interface FResult : NSObject

@property(copy, nonatomic) NSString *info;

@property(strong, nonatomic) NSNumber *code;

@end

NS_ASSUME_NONNULL_END
