#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "BleDispatchCenter.h"

@interface AppDelegate()

@property(strong, nonatomic) BleDispatchCenter* bleCenter;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    _bleCenter = [BleDispatchCenter initBleDispatchCenter:controller.binaryMessenger];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
