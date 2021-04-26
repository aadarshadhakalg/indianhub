import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indianhub/models/transaction_model.dart';
import 'package:indianhub/models/user_model.dart';

class FireStoreHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  ///Users Helper
  ///
  ///
  
  Future<UserModel> getLoggedUser(String uid)async{
    return _db.collection('users').doc(uid).get().then((value) => UserModel.fromMap(value.data()!));
  }

  /// Referral Helpers
  ///
  /// Help with CRUD of referral datas and all

  Future<void> addReferralCode(String uid, String code) async {
    await _db.collection('referralcodes').add({
      'code': code,
      'user': uid,
      'referredUsers': [],
      'waitingForBonus': [],
      'bonusEarned':0,
    });
  }

  Future<void> useRefferalCode(
      String referralCode, String referredUserId) async {
    QuerySnapshot referralcodes = await _db
        .collection('referralcodes')
        .where('code', isEqualTo: referralCode)
        .get();

    String documentid = referralcodes.docs[0].id;

    DocumentSnapshot referralCodeSnapshot =
        await _db.collection('referralcodes').doc(documentid).get();
    var referralCodeData = referralCodeSnapshot.data();
    List referredUsers = referralCodeData?['referredUsers'];
    List waitingForBonus = referralCodeData?['waitingForBonus'];
    referredUsers.add(referredUserId.toString());
    waitingForBonus.add(referredUserId.toString());
    await _db.collection('referralcodes').doc(documentid).update({
      'referredUsers': referredUsers,
      'waitingForBonus':waitingForBonus,
    });
  }

  Future<List<UserModel>> getReferredUsers(String referralCode) async {
    List<UserModel> allReferredUsers = [];

    QuerySnapshot referralcodes = await _db
        .collection('referralcodes')
        .where('code', isEqualTo: referralCode)
        .get();
    String documentid = referralcodes.docs[0].id;
    DocumentSnapshot referralCodeSnapshot =
        await _db.collection('referralcodes').doc(documentid).get();
    var referralCodeData = referralCodeSnapshot.data();

    for (var item in referralCodeData?['referredUsers']) {
      DocumentSnapshot snapshot = await _db.doc('/users/$item').get();
      UserModel userModel = UserModel.fromMap(snapshot.data()!);
      allReferredUsers.add(userModel);
    }
    return allReferredUsers;
  }


  Future<int> getBonusEarned(String referralCode) async {

    QuerySnapshot referralcodes = await _db
        .collection('referralcodes')
        .where('code', isEqualTo: referralCode)
        .get();
    String documentid = referralcodes.docs[0].id;
    DocumentSnapshot referralCodeSnapshot =
        await _db.collection('referralcodes').doc(documentid).get();
    var referralCodeData = referralCodeSnapshot.data();

    return referralCodeData?['bonusEarned'];
  }

  



  /// Transaction Helpers
  ///
  ///
  ///
  ///Help to add and remove transactions

  Future<void> addTransaction({
    required String type,
    required int amount,
    required String uid,
    required String transactionMedium,
    String? transactionId,
    String? transactionTime,
    required DateTime date,
  }) async {
    await _db.collection('transactions').add({
      'type': type,
      'amount': amount,
      'uid': uid,
      'status': 'pending',
      'response': null,
      'transactionMedium': transactionMedium,
      'transactionId': transactionId,
      'transactionTime': transactionTime,
      'date': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<TransactionModel>> getMyTransactions(String uid) async {
    QuerySnapshot querySnapshot =
        await _db.collection('transactions').where('uid', isEqualTo: uid).orderBy('date',descending: true).get();

    List<TransactionModel> allTransactions = [];

    for (var snapshots in querySnapshot.docs) {
      Map data = snapshots.data();
      data['id'] = snapshots.id;
      TransactionModel model = TransactionModel.fromMap(data);
      allTransactions.add(model);
    }
    return allTransactions;
  }
}
