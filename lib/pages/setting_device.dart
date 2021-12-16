

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_study/stores/app.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';




class SettingDevicePage extends StatefulWidget {
  @override
  _SettingDevicePageState createState() => _SettingDevicePageState();
}

class _SettingDevicePageState extends State<SettingDevicePage> {
  late List<String> deviceList;
  final store=Get.put(AppModel());
  @override
  void initState() {
    super.initState();
         findDevices();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
      title: Text("串口设备"),
    ),
      body: FutureBuilder(
        future: findDevices(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data![index]),
                    subtitle: Text(snapshot.data![index]),
                    onTap: () {
                      store.updateDevice(snapshot.data![index]);
                      Navigator.of(context).popUntil(ModalRoute.withName("/"));
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(height: 0.0),
              );
          }
        },
      ),
    );
  }

  Future<List<String>> findDevices()  async{
    return  await SerialPort.availablePorts;
  }
}
