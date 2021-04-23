import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'dart:math';

import 'package:indianhub/models/user_model.dart';

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

  Future<void> addReferralCode(String uid, String code)async {
    await _db.collection('referralcodes').add({
      'code':code,
      'user':uid,
      'referredUsers':[],
    });
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

  Future<void> updateReferral(String referralCode, String referredUserId) async {
    QuerySnapshot referralcodes = await _db
        .collection('referralcodes')
        .where('code', isEqualTo: referralCode)
        .get();

    String documentid = referralcodes.docs[0].id;

    DocumentSnapshot referralCodeSnapshot = await _db.collection('referralcodes').doc(documentid).get();
    var referralCodeData = referralCodeSnapshot.data();
    List referredUsers = referralCodeData?['referredUsers'];
    print(referredUsers);
    referredUsers.add(referredUserId.toString());
    print(referredUsers);
    await _db.collection('referralcodes').doc(documentid).update({'referredUsers': referredUsers});
  } 

  Future<List<UserModel>> getReferredUsers(String referralCode) async{

    List<UserModel> allReferredUsers = [];

    QuerySnapshot referralcodes = await _db
        .collection('referralcodes')
        .where('code', isEqualTo: referralCode)
        .get();
    String documentid = referralcodes.docs[0].id;
    DocumentSnapshot referralCodeSnapshot = await _db.collection('referralcodes').doc(documentid).get();
    var referralCodeData = referralCodeSnapshot.data();

    for (var item in referralCodeData?['referredUsers']) {
      DocumentSnapshot snapshot = await _db
        .doc('/users/$item').get();
      UserModel userModel = UserModel.fromMap(snapshot.data()!);
      allReferredUsers.add(userModel);
    }

    return allReferredUsers;
  }
}
