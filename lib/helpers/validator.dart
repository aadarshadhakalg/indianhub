// matching various patterns for kinds of data


import 'package:indianhub/controllers/controllers.dart';

class Validator {

  final AuthController _authController = AuthController.to;
  Validator();

  String? email(String? value) {
    String pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!))
      return 'Please enter valid email address';
    else
      return null;
  }

  String? password(String? value) {
    String pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!))
      return 'Invalid Password. Password must be more than 6 character long';
    else
      return null;
  }

  String? name(String? value) {
    String pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!))
      return 'Not a valid name';
    else
      return null;
  }


  String? referral(String? value){
    return null;
  }

  String? number(String? value) {
    String pattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!))
      return 'Number Field';
    else
      return null;
  }

  String? amount(String? value) {
    String pattern = r'^\d+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!))
      return 'You must specify amount';
    else if(int.parse(value) <= 0){
      return 'Amount must be greater than 0';
    }
      return null;
  }

  String? withdrawlAmount(String? value) {
    String pattern = r'^\d+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!))
      return 'You must specify amount';
    else if(int.parse(value) <= 0){
      return 'Amount must be greater than 0';
    } else if(_authController.firestoreUser.value!.points! < int.parse(value)){
      return 'Insufficient Balance';
    }
      return null;
  }

  String? notEmpty(String? value) {
    String pattern = r'^\S+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!))
      return 'This field is required';
    else
      return null;
  }
}
