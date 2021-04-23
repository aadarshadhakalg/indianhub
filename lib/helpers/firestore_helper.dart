import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indianhub/models/user_model.dart';

class FireStoreHelper{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Referral Helpers
  /// 
  /// Help with CRUD of referral datas and all
  
  Future<void> addReferralCode(String uid, String code)async {
    await _db.collection('referralcodes').add({
      'code':code,
      'user':uid,
      'referredUsers':[],
    });
  }


  Future<void> useRefferalCode(String referralCode, String referredUserId) async {
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