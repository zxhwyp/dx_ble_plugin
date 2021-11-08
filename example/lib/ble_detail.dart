import 'package:dx_ble_plugin/dx_ble_plugin.dart';
import 'package:dx_ble_plugin/i_factory.dart';
import 'package:dx_ble_plugin_example/util.dart';
import 'package:flutter/material.dart';

class BleDetail extends StatefulWidget {
  final IBle entity;
  BleDetail({this.entity});
  @override
  _BleDetailState createState() => _BleDetailState();
}

class _BleDetailState extends State<BleDetail> {
  IBle get entity => widget.entity;
  @override
  void initState() {
    super.initState();
    DxBlePlugin().globalEB.on<BleEvent>().listen((event) {
      switch (event.tag) {
        case CALL_ERROR:
          showToast(event.param.toString());
          break;
        case CALL_STATUS:
          showToast(event.param.toString());
          break;
        case CALL_OPENLOCK:
          showToast(event.param.toString());
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("蓝牙详情"),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          label('蓝牙名字：' + widget.entity.name ?? ''),
          label('rssi：' + widget.entity.rssi?.toString() ?? ''),
          label('uuid:' + widget.entity.uuid ?? ''),
          SizedBox(
            height: 100,
          ),
          action()
        ],
      ),
    );
  }

  Widget label(String title, {Color color = Colors.black, VoidCallback call}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: call,
        child: Text(
          title,
          style: TextStyle(color: color),
        ),
      ),
    );
  }

  Widget action() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        label('开锁', color: Colors.blue, call: () {
          DxBlePlugin().openLock();
        }),
        label('设置蓝牙锁指令', color: Colors.blue, call: () {
          ChuangLiKey key = ChuangLiKey.fromDefault(entity);
          key.package = TaskPackage.fromJson({
            'lockCodes': ['0791060087733490'],
            'areas': ['0791'],
            'startTime': '2021-10-27',
            'endTime': '2022-10-27',
            'offlineTime': 24
          });
          DxBlePlugin().setKeyTask(ble: key);
        }),
        label('初始化锁具', color: Colors.blue, call: () {
          //该方法回调不经过通知 直接方法返回结果
          DxBlePlugin().initBleLock().then((value) {
            showToast(value.info);
          });
        }),
      ],
    );
  }
}
