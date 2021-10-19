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

//新力蓝牙
class XinLi extends DefaultBle {
  @override
  String get style => 'ChuangLi';
  XinLi();
  factory XinLi.fromDefault(DefaultBle ble) {
    XinLi entity = XinLi();
    entity.name = ble.name;
    entity.rssi = ble.rssi;
    entity.uuid = ble.uuid;
    entity.code = ble.code;
    return entity;
  }
}

//瑞奥蓝牙(新)
class RuiAoNew extends DefaultBle {
  @override
  String get style => 'RuiAuNew';

  RuiAoNew();
  factory RuiAoNew.fromDefault(DefaultBle ble) {
    RuiAoNew entity = RuiAoNew();
    entity.name = ble.name;
    entity.rssi = ble.rssi;
    entity.uuid = ble.uuid;
    entity.code = ble.code;
    return entity;
  }
}

//瑞奥蓝牙(旧)
class RuiAoOld extends DefaultBle {
  @override
  String get style => 'RuiAuOld';

  RuiAoOld();
  factory RuiAoOld.fromDefault(DefaultBle ble) {
    RuiAoOld entity = RuiAoOld();
    entity.name = ble.name;
    entity.rssi = ble.rssi;
    entity.uuid = ble.uuid;
    entity.code = ble.code;
    return entity;
  }
}
