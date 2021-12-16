import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_study/stores/app.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:open_settings/open_settings.dart';


import 'package:stream_transform/stream_transform.dart';

import '../utils.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  TextEditingController _dataController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  SerialPort? _serialPort;
  StreamSubscription? _subscription;
  bool isPortOpened = false;
  bool isHexMode = false;
  List<Widget> _historyData = [];
  final store=Get.put(AppModel());
  @override
  void initState() {

    // print('Available ports:');
    // var i = 0;
    // for (final name in SerialPort.availablePorts) {
    //   final sp = SerialPort(name);
    //   print('${++i}) $name');
    //   print('\tDescription: ${sp.description}');
    //   print('\tManufacturer: ${sp.manufacturer}');
    //   print('\tSerial Number: ${sp.serialNumber}');
    //
    //  // print(sp.openReadWrite());
    //
    //
    //   sp.dispose();
    // }
store.init();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(fontSize: 36),
        title: Text("Flutter串口例子"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 36,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("/setting");
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // Text('Running on: $_platformVersion\n'),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _historyData,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      store.device?.value != "null"
                          ? Obx(()=>Text(
                        "串口号:${store.device?.value}",
                        style: TextStyle(fontSize: 24),
                      ))
                          : TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed("/setting/device");
                              },
                              child: Text(
                                "请选择串口",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                      Text(
                        "波特率:${store.baudrate?.value}",
                        style: TextStyle(fontSize: 24),
                      ),
                      Row(
                        children: <Widget>[
                          ElevatedButton(
                            child: !isPortOpened
                                ? Text(
                                    "打开",
                                    style: TextStyle(fontSize: 36),
                                  )
                                : Text(
                                    "关闭",
                                    style: TextStyle(fontSize: 36),
                                  ),
                            onPressed: store.device?.value != "null"
                                ? () async {
                                    final debounceTransformer =
                                        StreamTransformer<Uint8List,
                                                dynamic>.fromBind(
                                            (s) => s.debounceBuffer(
                                                const Duration(
                                                    milliseconds: 500)));
                                    if (!isPortOpened) {
                                      var serialPort =
                                          await SerialPort(store.device!.value);
                                      //     serialPort.config.baudRate=9600;

                                      bool openResult =
                                          await serialPort.openReadWrite();

                                      setState(() {
                                        _serialPort = serialPort;
                                        isPortOpened = openResult;
                                      });
                                      _subscription = SerialPortReader(
                                              _serialPort!)
                                          .stream
                                          //       .transform(debounceTransformer)
                                          .listen((recv) {
                                        print("Receive: $recv");
                                        // String recvData =
                                        //     formatReceivedData(recv);
                                        String recvData = recv.toString();
                                        setState(() {
                                          _historyData
                                              .add(Text(">>> $recvData"));
                                          scrollToBottom();
                                        });
                                      });
                                      print("openResult: $openResult");
                                    } else {
                                      bool closeResult =
                                          await _serialPort!.close();
                                      _serialPort!.dispose();
                                      setState(() {
                                        _serialPort = null;
                                        isPortOpened = !closeResult;
                                      });
                                      _subscription = null;
                                      print("closeResult: $closeResult");
                                    }
                                  }
                                : null,
                          ),
                          SizedBox(width: 16.0),
                          ElevatedButton(
                            child: Text(
                              "发送",
                              style: TextStyle(fontSize: 36),
                            ),
                            onPressed: store.device?.value != "null"
                                ? () {
                                    var sentData =
                                        formatSentData(_dataController.text);
                                    print("Send: $sentData");
                                    _serialPort!
                                        .write(Uint8List.fromList(sentData));
                                    setState(() {
                                      _historyData.add(
                                          Text("<<< ${_dataController.text}"));
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          ElevatedButton(
                            child: Text(
                              "清除",
                              style: TextStyle(fontSize: 36),
                            ),
                            onPressed: () {
                              setState(() {
                                _historyData = [];
                              });
                            },
                          ),
                          SizedBox(width: 16.0),
                          Checkbox(
                            onChanged: (value) {
                              setState(() {
                                isHexMode = value!;
                              });
                            },
                            value: isHexMode,
                          ),
                          Text(
                            "Hex",
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: _dataController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Text To Send",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  scrollToBottom() {
    // print("scrollToBottom ${_scrollController.position}");
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  String formatReceivedData(recv) {
    if (isHexMode) {
      return recv
          .map((List<int> char) => char.map((c) => intToHex(c)).join())
          .join();
    } else {
      return recv.map((List<int> char) => String.fromCharCodes(char)).join();
    }
  }

  List<int> formatSentData(String sendStr) {
    if (isHexMode) {
      return hexToUnits(sendStr);
    } else {
      return sendStr.codeUnits;
    }
  }

  @override
  void dispose() {
    _serialPort?.close();
  }


}
