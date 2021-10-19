///蓝牙接口类
mixin IBle {
  ///编码
  String code;

  ///唯一标识uuid
  String uuid;

  ///锁名字
  String name;

  num rssi;

  ///锁类型
  String get style;
  Map toJson() {
    return {
      'uuid': uuid,
      'style': style,
      'code': code,
      'name': name,
      'rssi': rssi
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

//创力蓝牙
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
