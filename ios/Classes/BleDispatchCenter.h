//
//  BleUtil.h
//  Runner
//
//  Created by 周小华 on 2021/10/13.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BleDispatchCenter : NSObject

@property(strong, nonatomic) FlutterMethodChannel* bleChannel;

+ (instancetype) shareInstance;

- (void)flutterMethodCallHandler:(FlutterMethodCall *)call FlutterResult:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
