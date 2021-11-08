//
//  BleModel.m
//  Runner
//
//  Created by 周小华 on 2021/10/13.
//

#import "BleModel.h"

@implementation BleModel

@end


@implementation FResult

+ (FResult *)fromJson:(NSDictionary *)json {
    FResult *result = [[FResult alloc]init];
    result.code = [NSNumber numberWithInt:[json[@"code"] intValue]];
    result.info = json[@"info"];
    return  result;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = @{}.mutableCopy;
    if (!self.info ) {
        json[@"info"] = self.info;
    }
    if (!self.info ) {
        json[@"code"] = self.code;
    }
    return  json;
}

@end
