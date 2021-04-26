
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:indianhub/controllers/controllers.dart';
import 'package:indianhub/controllers/success_ui.dart';
import 'package:indianhub/helpers/firestore_helper.dart';
import 'package:indianhub/models/user_model.dart';

enum TransactionStates { Loading, Normal }

class TransactionController extends GetxController {
  static TransactionController to = Get.find();
  AuthController _authController = AuthController.to;

  FireStoreHelper _fireStoreHelper = FireStoreHelper();

  Rx<TransactionStates> currentState =
      Rx<TransactionStates>(TransactionStates.Normal);
  List<String> allWithdrawlMethods = ['Paytm', 'Gpay', 'Phonepe', 'Upi Id'];
  List<String> allLoadMethods = ['Paytm', 'Gpay', 'Phonepe', 'Others'];
  Rx<String> selectedWithdrawlMethod = Rx<String>('Paytm');
  Rx<String> selectedLoadMethod = Rx<String>('Paytm');
  TextEditingController withdrawAmountController = TextEditingController();
  TextEditingController withdrawAccountIdController = TextEditingController();
  TextEditingController loadAmountController = TextEditingController();
  TextEditingController transactionIdController = TextEditingController();
  TextEditingController transactionTimeController = TextEditingController();

  Future<void> requestLoad() async {
    currentState.value = TransactionStates.Loading;

    try {
      _fireStoreHelper.addTransaction(
        amount: int.parse(loadAmountController.text),
        date: DateTime.now(),
        transactionMedium: selectedLoadMethod.value,
        transactionId: transactionIdController.text,
        transactionTime: transactionTimeController.text,
        type: 'load',
        uid: _authController.firestoreUser.value!.uid,
      );
      loadAmountController.text = '';
      transactionIdController.text = '';
      transactionTimeController.text = '';
      currentState.value = TransactionStates.Normal;
      Get.to(SuccessPage(message: 'Success'));
    } catch (e) {
      currentState.value = TransactionStates.Normal;
      Get.snackbar('Load Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }


  Future<void> requestWithdraw() async {
    currentState.value = TransactionStates.Loading;

    try {
      Map oldModelData = _authController.firestoreUser.value!.toJson();
      oldModelData['points'] = oldModelData['points'] - int.parse(withdrawAmountController.text);
      _fireStoreHelper.updateUser(UserModel.fromMap(oldModelData));
      _fireStoreHelper.addTransaction(
        amount: int.parse(withdrawAmountController.text),
        date: DateTime.now(),
        transactionMedium: selectedWithdrawlMethod.value,
        type: 'withdraw',
        uid: _authController.firestoreUser.value!.uid,
        withdrawlAccount: withdrawAccountIdController.text,
      );
      withdrawAmountController.text = '';
      withdrawAccountIdController.text = '';
      currentState.value = TransactionStates.Normal;
      Get.to(SuccessPage(message: 'Success'));
    } catch (e) {
      currentState.value = TransactionStates.Normal;
      Get.snackbar('Withdrawl Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }
}
