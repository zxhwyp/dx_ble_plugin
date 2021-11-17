import 'package:dx_ble_plugin/dx_ble_plugin.dart';
import 'package:dx_ble_plugin/i_factory.dart';
import 'package:dx_ble_plugin_example/util.dart';
import 'package:flutter/material.dart';

import 'ble_detail.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<IBle> bles = <IBle>[];
  String status = '未知';
  @override
  void initState() {
    DxBlePlugin().globalEB.on<BleEvent>().listen((event) {
      switch (event.tag) {
        case CALL_SEARCH:
          setState(() {
            if (bles.map((e) => e.uuid).toList().contains(event.ble.uuid) ==
                false) {
              bles.add(event.ble);
            }
          });
          break;
        default:
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [search(), ...bles.map((e) => bleList(e)).toList()],
        ),
      ),
    );
  }

  Widget bleStatus() {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
          onPressed: () {
            DxBlePlugin().bleStatus().then((value) {
              setState(() {
                status = value.info;
              });
            });
          },
          child: Text(
            '点击获取蓝牙状态：$status',
            style: TextStyle(color: Colors.blue),
          )),
    );
  }

  Widget search() {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
          onPressed: () {
            setState(() {
              bles.clear();
            });
            DxBlePlugin().searchBleList();
          },
          child: Text(
            '搜索',
            style: TextStyle(color: Colors.blue),
          )),
    );
  }

  Widget bleList(IBle item) {
    if (item.name == null || item.name.trim() == '') {
      item.name = '未知';
    }
    return TextButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => BleDetail(entity: item)));
        },
        child: Text(
          item.name + ':\n' + item.uuid,
          style: TextStyle(color: Colors.black),
        ));
  }
}
