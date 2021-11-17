import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ble_const.dart';
import 'i_factory.dart';
export 'ble_const.dart';

///电信蓝牙插件
class DxBlePlugin {
  ///厂家分：创力，瑞澳
  ///瑞澳sdk：有新版和老版区别
  static const MethodChannel _channel = const MethodChannel('com.dx.bleplugin');

  factory DxBlePlugin() => _instance;

  static final DxBlePlugin _instance = DxBlePlugin._singleton();

  EventBus globalEB = EventBus();

  DxBlePlugin._singleton() {
    _channel.setMethodCallHandler(methodCall);
  }

  /// 获取蓝牙状态
  Future<NativeResult> bleStatus() async {
    Map value = await _channel.invokeMethod(METHOD_BLE_STATUS);
    return NativeResult.fromJson(value);
  }

  /// 2. 搜索蓝牙设备
  /// @param names 搜索全部蓝牙
  Future<NativeResult> searchBleAll() async {
    Map value = await _channel.invokeMethod(METHOD_SEARCHBLE_ALL);
    return NativeResult.fromJson(value);
  }

  /// 2. 搜索蓝牙设备
  /// @param names 按名字搜索
  Future<NativeResult> searchBleList({List<String> names}) async {
    Map value = await _channel.invokeMethod(METHOD_SEARCHBLE, names);
    return NativeResult.fromJson(value);
  }

// 2. 开锁
  Future<NativeResult> openLock({@required IBle ble}) async {
    Map value = await _channel.invokeMethod(METHOD_OPENLOCK, ble.toJson());
    return NativeResult.fromJson(value);
  }

// 2. 应急钥匙/区域授权
  Future<NativeResult> setKeyTask({@required IBle ble}) async {
    Map value = await _channel.invokeMethod(METHOD_SET_KEY_TASK, ble.toJson());
    return NativeResult.fromJson(value);
  }

  // 2. 创力设置锁具编码/创力重置锁具编码
  Future<NativeResult> initBleLock({@required IBle ble}) async {
    Map value = await _channel.invokeMethod(METHOD_INIT_BLE_LOCK, ble.toJson());
    return NativeResult.fromJson(value);
  }

  Future<dynamic> methodCall(MethodCall call) async {
    var value = call.arguments;
    if (call.method == CALL_SEARCH) {
      globalEB
          .fire(BleEvent(tag: call.method, ble: DefaultBle.fromJson(value)));
      return;
    }
    globalEB.fire(BleEvent(tag: call.method, param: value));
  }
}

class BleEvent {
  ///回调方法
  String tag;

  ///一般回调参数
  var param;

  ///蓝牙搜索回调
  IBle ble;
  BleEvent({this.tag, this.ble, this.param});
}

class NativeResult {
  ///回调信息
  String info;

  ///回调code：0成功，非0失败
  int code;

  IBle ble;

  NativeResult({this.info, this.code});

  factory NativeResult.fromJson(Map value) {
    value = value ?? {};
    NativeResult entity = NativeResult();
    entity.info = value['info'] ?? '';
    entity.code = value['code'];
    Map bleMap = value['ble'];
    if (bleMap is Map) {
      entity.ble = DefaultBle.fromJson(bleMap);
    }
    return entity;
  }
}
