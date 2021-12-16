import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置",style: TextStyle(fontSize: 24),),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("选择串口设备",style: TextStyle(fontSize: 24),),
            onTap: () {
              Navigator.of(context).pushNamed("/setting/device");
            },
          ),
          Divider(),
          ListTile(
            title: Text("选择波特率",style: TextStyle(fontSize: 24),),
            onTap: () {
              Navigator.of(context).pushNamed("/setting/baudrate");
            },
          ),
          Divider(),
          ListTile(
            title: Text("打开系统显示设置",style: TextStyle(fontSize: 24),),
            onTap: () {
              OpenSettings.openDisplaySetting();
            },
          ),
          Divider()
        ],
      ),
    );
  }
}
