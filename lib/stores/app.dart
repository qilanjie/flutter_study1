import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
class AppModel extends GetxController  {
  RxString? _device="".obs;
  RxInt _baudrate=9600.obs;

  RxString? get device => _device;

  RxInt? get baudrate => _baudrate ;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();



  init() async {
    final SharedPreferences prefs = await _prefs;
    _device?.value= prefs.getString("device")??"null";
    _baudrate.value = prefs.getInt("baudrate")??9600;

  }

  void updateDevice(String device) async {
    final SharedPreferences prefs = await _prefs;
    var isOK = await prefs.setString("device", device);
    if (isOK) {
      _device?.value= prefs.getString("device")??"null";
    }


  }

  void updateBaudrate(int baudrate) async {
    final SharedPreferences prefs = await _prefs;
    var isOK = await prefs.setInt("baudrate", baudrate);
    if (isOK) {
      _baudrate.value = prefs.getInt("baudrate")??9600;
    }


  }
}
