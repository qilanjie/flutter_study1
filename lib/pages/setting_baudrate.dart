import 'package:flutter/material.dart';
import 'package:flutter_study/stores/app.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';



import '../constants.dart';

class SettingBaudratePage extends StatelessWidget {
  final store=Get.put(AppModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
      title: Text("波特率"),
    ),
      body: ListView.separated(
        itemCount: kBaudrateList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text("${kBaudrateList[index]}"),
            onTap: () {
              store.updateBaudrate(kBaudrateList[index]);
              Navigator.of(context).popUntil(ModalRoute.withName("/"));
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 0.0),
      ),
    );
  }
}
