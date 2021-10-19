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
    return GestureDetector(
      onTap: call,
      child: Text(
        title,
        style: TextStyle(color: color),
      ),
    );
  }

  Widget action() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        label('开锁', color: Colors.blue, call: () {
          DxBlePlugin().openLock(ble: XinLi.fromDefault(entity));
        }),
      ],
    );
  }
}
