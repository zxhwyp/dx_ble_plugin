#import "DxBlePlugin.h"

@implementation DxBlePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName: BLE_NAME
            binaryMessenger:[registrar messenger]];
  [BleDispatchCenter shareInstance].bleChannel = channel;
  DxBlePlugin* instance = [[DxBlePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    [[BleDispatchCenter shareInstance] flutterMethodCallHandler:call FlutterResult:result];
}

@end
