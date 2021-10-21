#import "AppDelegate.h"
#import <dx_ble_plugin/DxBlePlugin.h>
#import "GeneratedPluginRegistrant.h"

@interface AppDelegate()

@property(strong, nonatomic) BleDispatchCenter* bleCenter;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName: BLE_NAME
              binaryMessenger:controller.binaryMessenger];
    [BleDispatchCenter shareInstance].bleChannel = channel;
    
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        [[BleDispatchCenter shareInstance] flutterMethodCallHandler:call FlutterResult:result];
    }];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
