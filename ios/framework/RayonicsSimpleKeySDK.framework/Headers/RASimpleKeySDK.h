//
//  RASimpleKeySDK.h
//
//  Created by 吕德坚 on 2016/11/15.
//  Copyright © 2016年 Leo Lv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

@protocol RASimpleKeySDKDelegate <NSObject>

@optional

- (void)simpleKeySDKCallBack:(NSDictionary *)retData;

@end

@interface RASimpleKeySDK : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (weak, nonatomic) id <RASimpleKeySDKDelegate> delegate;

+ (instancetype)sharedManager;
+ (void)setManager:(CBCentralManager *)manager peripheral:(CBPeripheral *)peripheral;
//初始化SDK
- (void)SDKinit:(NSString *)PlatformID TimesStamp:(NSString *)TimesStamp secretKey:(NSString *)secretKey;

/**
 蓝牙连接
 ※可引用 SDK 初始化 方法里获取的 钥匙密钥“secretKey”
 Input {
 蓝牙中心 manager
 待连接的设备 peripeheral
 }
 Output {
 ret: true/false; //返回成功或失败标识
 msg: ; //成功、失败的信息内容
 }
 **/
- (void)bleConnect:(CBCentralManager *)manager peripheral:(CBPeripheral *)peripheral;

/**
 断开蓝牙连接
 ※可引用 SDK 初始化 方法里获取的 钥匙密钥“secretKey”
 Input {
 蓝牙中心 manager
 }
 Output {
 ret: true/false; //返回成功或失败标识
 msg: ; //成功、失败的信息内容
 }
 **/
- (void)bleDisConnect:(CBCentralManager *)manager;

/**
 读取钥匙信息
 ※可引用 SDK 初始化 方法里获取的 钥匙密钥“secretKey”
 Input {
 无
 }
 Output {
 ret: true/false; //返回成功或失败
 msg: ; //成功、失败的信息内容
 obj: {
 NSData keyCode; //钥匙 ID
 nsnumber batteryPower; //电池电量，百分比数值，例:“50%”，返回“50”
 string clock; //时钟时间
 String hardwareVersion: ;//硬件版本
 String firmwareVersion: ;//软件版本
 }
 }
 **/
- (void)readKeyInfo;

/**
 初始化电子钥匙 (注册电子钥匙)
 ※可引用 SDK 初始化 方法里获取的 钥匙密钥“secretKey”
 Input {
 无
 }
 Output {
 ret: true/false; //返回成功或失败
 msg: ; //成功、失败的信息内容
 obj: {
 NSData keyCode: ; //钥匙 ID（MacAddress）
 }
 }
 **/
- (void)Keyinit;

/**
 设置钥匙时间(电子钥匙时钟校准)
 ※可引用 SDK 初始化 方法里获取的 钥匙密钥“secretKey”
 Input {
 nsstring CurrentDate //当前时间，时间格式"yyMMddHHmmss0e"
 }
 Output {
 ret: true/false; //返回成功或失败
 msg: ; //成功、失败的信息内容
 }
 **/
- (void)issuedKeyClock:(NSString *)currentDate;

/**
 设置钥匙离线
 ※可引用 SDK 初始化 方法里获取的 钥匙密钥“secretKey”
 Input {
 nsstring time //time ，可输入:0~65535，单位:分钟
 }
 Output {
 ret: true/false; //返回成功或失败
 msg: ; //成功、失败的信息内容
 }
 **/
- (void)setOfflineTime:(NSString *)time;
//- (void)setOfflineOpen:(NSArray *)offlineOpenArray userID:(NSString *)userID  secretLock:(NSString *)secretLock;

/**
 修改系统码
 **/
- (void)changeSystemCode:(NSString *)secretLock newSecretLock:(NSString *)newSecretLock;
/**
 锁具初始化 (读或写锁具编码，即锁具登记到平台)
 ※可引用 SDK 初始化 方法里获取的 钥匙密钥“secretKey”
 Input {
 nsstring LockCode;//锁具编码（int字符串） （先发送密钥设置系统码，叫一声，收到反馈之后设置锁ID，再叫一声）
 nsstring secretLock;//锁具密钥（hex字符串）
 }
 Output {
 ret: true/false; //返回成功或失败
 msg: ; //成功、失败的信息内容
 obj:
 {
 String lockCode; //锁具 ID
 }
 }
 **/
- (void)LockCodeinit:(NSString *)lockCode secretLock:(NSString *)secretLock;

/**
 开锁
 (如钥匙有日志记录功能，则根据开锁人 ID 生成日志)
 ※可引用 SDK 初始化 方法里获取的 钥匙密钥“secretKey”
 1. 在线
 Input {
 nsstring lockCode;//锁具 ID
 nsstring secretLock;//锁具密钥
 String userID;//开锁人 ID(2 个 字节)
 nsstring startTime;//(如:16 年 2 月 23 日 17 时 17 分，传 1602231717)
 nsstring endTime;//权限开始时间，权限结束时间
 }
 Output {
 ret: true/false; //返回成功或失败
 msg: ; //成功、失败的信息内容
 }
 
 2.离线 同步权限方式
 Input {
 nsarray <String> lockCodes;//锁具 ID 列表
 nsarray<String> Areas;//区域 ID 列表
 nsstring startTime;//(如:16 年 2 月 23 日 17 时 17 分，传 1602231717)
 nsstring endTime;//任务开始时间，任务结束时间
 nsstring secretLock;//钥匙密钥
 nsstring userID;//开锁人ID(2个字节)
 }
 Output {
 ret: true/false; //返回成功或失败
 msg: ; //成功、失败的信息内容
 }
 
 注:开锁方法 1、2 请各厂商根据自身业务不同合理选择一种实现便可
 **/
- (void)OpenLock:(NSString *)lockCode secretLock:(NSString *)secretLock userID:(NSString *)userID startTime:(NSString *)startTime endTime:(NSString *)endTime;
- (void)OpenLockOffline:(NSArray *)lockCodes areas:(NSArray *)areas startTime:(NSString *)startTime endTime:(NSString *)endTime secretLock:(NSString *)secretLock userID:(NSString *)userID;
- (void)setOfflineOpen:(NSArray *)offlineOpenArray userID:(NSString *)userID  secretLock:(NSString *)secretLock;
- (void)setEngineerKeyWithUserID:(NSString *)userID startTime:(NSString *)startTime endTime:(NSString *)endTime;
/**
 读取钥匙开门日志
 ※可引用 SDK 初始化 方法里获取的 钥匙密钥“secretKey”
 Input {
 无
 }
 Output {
 ret: true/false; //返回成功或失败
 msg: ; //成功、失败的信息内容
 obj:[
 {
 actionDate: //开锁时间
 lockId: //开启的锁具ID
 userId: //开锁人ID
 },
 {
 actionDate: //开锁时间
 lockId: //开启的锁具ID
 userId: //开锁人ID
 },
 .....
 ]
 }
 **/
- (void)readLog;

/**
 日志删除
 ※可引用 SDK 初始化 方法里获取的 钥匙密钥“secretKey”
 Input {
 无
 }
 Output {
 ret: true/false; //返回成功或失败
 msg: ; //成功、失败的信息内容
 }
 **/
- (void)removeLog;
//读取锁具ID
- (void)readLockID;
- (void)setSystemCode :(NSString *)secretLock;
//设置蓝牙锁
- (void)setBleLock:(NSDictionary *)option;
/*
 option["type"] = 0x01 // 左开
 option["type"] = 0x02 // 右开
 
 */
//设置锁系统码
- (void)setNewSystemCode:(NSString *)secretLock oldSystemCode:(NSString *)oldSecretLock;
//初始化钥匙
- (void)initKey;

@property (nonatomic, strong) CBCentralManager *manager;//传入的中心
@property (nonatomic, strong) CBPeripheral *peripheral;//传入的设备
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;//传入的输入特征
@property (nonatomic, strong) CBCharacteristic *readCharacteristic;//传入的订阅通知特征
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic, strong) NSMutableDictionary *retData;



@end
