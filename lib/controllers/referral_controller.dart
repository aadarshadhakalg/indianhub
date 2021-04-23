import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'dart:math';

class ReferralController extends GetxController {
  static ReferralController to = Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String getRandomCode() {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String code = String.fromCharCodes(Iterable.generate(
        8, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return code;
  }

  Future<String> generateNewCode() async {
    String code = getRandomCode();
    if (!await isValidCode(code)) {
      return code;
    } else {
      generateNewCode();
    }
    return '';
  }


  Future<bool> isValidCode(String code) async {

    if(code.replaceAll(' ', '').length == 0){
    return true;
    }
    QuerySnapshot allcodes = await _db
        .collection('referralcodes')
        .where('code', isEqualTo: code)
        .get();

    if (allcodes.size == 1) {
      return true;
    }
    return false;
  } 
}
