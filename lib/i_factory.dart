///蓝牙接口类
mixin IBle {
  ///锁具编码
  String code;

  ///唯一标识uuid
  String uuid;

  ///锁名字
  String name;

  num rssi;

  TaskPackage package;

  ///锁类型
  String get style;
  Map toJson() {
    return {
      'uuid': uuid,
      'style': style,
      'code': code,
      'name': name,
      'rssi': rssi,
      'package': package?.toJson()
    };
  }
}

class DefaultBle with IBle {
  @override
  String get style => '未知';
  DefaultBle();

  factory DefaultBle.fromJson(Map value) {
    value = value ?? {};
    DefaultBle entity = DefaultBle();
    entity.name = value['name'] ?? '';
    entity.rssi = value['rssi'];
    entity.uuid = value['uuid'];
    entity.code = value['code'];
    return entity;
  }
}

///创力蓝牙门锁
class ChuangLi extends DefaultBle {
  @override
  String get style => 'ChuangLi';
  ChuangLi();
  factory ChuangLi.fromDefault(DefaultBle ble) {
    ChuangLi entity = ChuangLi();
    entity.name = ble.name;
    entity.rssi = ble.rssi;
    entity.uuid = ble.uuid;
    entity.code = ble.code;
    return entity;
  }
}

///创力蓝牙钥匙
class ChuangLiKey extends DefaultBle {
  @override
  String get style => 'ChuangLiKey';
  ChuangLiKey();
  factory ChuangLiKey.fromDefault(DefaultBle ble) {
    ChuangLiKey entity = ChuangLiKey();
    entity.name = ble.name;
    entity.rssi = ble.rssi;
    entity.uuid = ble.uuid;
    entity.code = ble.code;
    return entity;
  }
}

//瑞奥蓝牙(增强版)
class RuiAoEnhance extends DefaultBle {
  @override
  String get style => 'RuiAuEnhance';

  RuiAoEnhance();
  factory RuiAoEnhance.fromDefault(DefaultBle ble) {
    RuiAoEnhance entity = RuiAoEnhance();
    entity.name = ble.name;
    entity.rssi = ble.rssi;
    entity.uuid = ble.uuid;
    entity.code = ble.code;
    return entity;
  }
}

//瑞奥蓝牙(简单版)
class RuiAoSimple extends DefaultBle {
  @override
  String get style => 'RuiAuSimple';

  RuiAoSimple();
  factory RuiAoSimple.fromDefault(DefaultBle ble) {
    RuiAoSimple entity = RuiAoSimple();
    entity.name = ble.name;
    entity.rssi = ble.rssi;
    entity.uuid = ble.uuid;
    entity.code = ble.code;
    return entity;
  }
}

class TaskPackage {
  List lockCodes;
  List areas;
  String startTime;
  String endTime;
  num offlineTime;

  TaskPackage(
      {this.areas,
      this.endTime,
      this.lockCodes,
      this.offlineTime,
      this.startTime});

  factory TaskPackage.fromJson(Map package) {
    TaskPackage entity = TaskPackage();
    entity.lockCodes = package['lockCodes'];
    entity.areas = package['areas'];
    entity.startTime = package['startTime'];
    entity.endTime = package['endTime'];
    entity.offlineTime = package['offlineTime'];
    return entity;
  }

  Map toJson() {
    Map package = Map();
    package['lockCodes'] = lockCodes;
    package['areas'] = areas;
    package['startTime'] = startTime;
    package['endTime'] = endTime;
    package['offlineTime'] = offlineTime;
    return package;
  }
}
