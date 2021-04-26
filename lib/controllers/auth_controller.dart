import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indianhub/controllers/controllers.dart';
import 'package:indianhub/controllers/referral_controller.dart';
import 'package:indianhub/controllers/theme_controller.dart';
import 'package:indianhub/helpers/firestore_helper.dart';
import '../models/models.dart';
import '../ui/auth/auth.dart';
import '../ui/ui.dart';
import '../helpers/helpers.dart';

enum AuthStates { Loading, Normal }

class AuthController extends GetxController {
  static AuthController to = Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();
  final ReferralController referralController = ReferralController.to;
  final FireStoreHelper _fireStoreHelper = FireStoreHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> firestoreUser = Rxn<UserModel>();
  final RxBool admin = false.obs;

  Rx<AuthStates> currentState = Rx<AuthStates>(AuthStates.Normal);

  @override
  void onReady() async {
    //run every time auth state changes
    ever(firebaseUser, handleAuthChanged);

    firebaseUser.bindStream(user);

    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  handleAuthChanged(_firebaseUser) async {
    //get user data from firestore
    //
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        Get.offAll(SignInUI());
      } else {
        firestoreUser.bindStream(streamFirestoreUser());
        await isAdmin();
        Get.offAll(HomeUI());
      }
    });
  }

  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser!;

  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();

  //Streams the firestore user from the firestore collection
  Stream<UserModel?> streamFirestoreUser() {
    print('streamFirestoreUser()');

    return _db
        .doc('/users/${firebaseUser.value!.uid}')
        .snapshots()
        .map((snapshot) => UserModel?.fromMap(snapshot.data()!));
  }

  //get the firestore user from the firestore collection
  Future<UserModel> getFirestoreUser() {
    return _db.doc('/users/${firebaseUser.value!.uid}').get().then(
        (documentSnapshot) => UserModel.fromMap(documentSnapshot.data()!));
  }

  //Method to handle user sign in using email and password
  signInWithEmailAndPassword(BuildContext context) async {
    currentState.value = AuthStates.Loading;
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      emailController.clear();
      passwordController.clear();
      currentState.value = AuthStates.Normal;
    } catch (error) {
      currentState.value = AuthStates.Normal;
      Get.snackbar('auth.signInErrorTitle', 'auth.signInError',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 7),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  // User registration using email and password
  registerWithEmailAndPassword(BuildContext context) async {
    currentState.value = AuthStates.Loading;
    if (await referralController.isValidCode(referralCodeController.text)) {
      try {
        await _auth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((result) async {
          print('uID: ' + result.user!.uid.toString());
          print('email: ' + result.user!.email.toString());
          //get photo url from gravatar if user has one
          Gravatar gravatar = Gravatar(emailController.text);
          String gravatarUrl = gravatar.imageUrl(
            size: 200,
            defaultImage: GravatarImage.retro,
            rating: GravatarRating.pg,
            fileExtension: true,
          );
          //create the new user object
          //
          String referral = await referralController.generateNewCode();
          UserModel _newUser = UserModel(
            uid: result.user!.uid,
            email: result.user!.email!,
            name: nameController.text,
            photoUrl: gravatarUrl,
            isAdmin: false,
            points: 0,
            referral: referral,
            referredBy: referralCodeController.text,
          );
          //create the user in firestore
          _createUserFirestore(_newUser, result.user!);
          await _fireStoreHelper.addReferralCode(result.user!.uid, referral);
          if (referralCodeController.text.replaceAll(' ', '').length != 0) {
            await _fireStoreHelper.useRefferalCode(
                referralCodeController.text.replaceAll(' ', ''),
                result.user!.uid);
          }
          
        });
        emailController.clear();
          passwordController.clear();
          referralCodeController.clear();
          currentState.value = AuthStates.Normal;
      } on FirebaseAuthException catch (error) {
        currentState.value = AuthStates.Normal;

        Get.snackbar('Signup Error', error.message!,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 10),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      } catch (e) {
        currentState.value = AuthStates.Normal;

        print(e);
      }
    } else {
      currentState.value = AuthStates.Normal;
      Get.snackbar('Invalid Code', 'The referral code you used is not valid!',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //handles updating the user when updating profile
  Future<void> updateUser(BuildContext context, UserModel user, String oldEmail,
      String password) async {
    try {
      currentState.value = AuthStates.Loading;
      await _auth
          .signInWithEmailAndPassword(email: oldEmail, password: password)
          .then((_firebaseUser) {
        _firebaseUser.user!
            .updateEmail(user.email)
            .then((value) => _updateUserFirestore(user, _firebaseUser.user!));
      });
      currentState.value = AuthStates.Normal;
      Get.snackbar(
          'auth.updateUserSuccessNoticeTitle', 'auth.updateUserSuccessNotice',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    } on PlatformException catch (error) {
      //List<String> errors = error.toString().split(',');
      // print("Error: " + errors[1]);
      currentState.value = AuthStates.Normal;
      print(error.code);
      String authError;
      switch (error.code) {
        case 'ERROR_WRONG_PASSWORD':
          authError = 'auth.wrongPasswordNotice';
          break;
        default:
          authError = 'auth.unknownError';
          break;
      }
      Get.snackbar('auth.wrongPasswordNoticeTitle', authError,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //updates the firestore user in users collection
  void _updateUserFirestore(UserModel user, User _firebaseUser) {
    _db.doc('/users/${_firebaseUser.uid}').update(user.toJson());
    update();
  }

  //create the firestore user in users collection
  void _createUserFirestore(UserModel user, User _firebaseUser) {
    _db.doc('/users/${_firebaseUser.uid}').set(user.toJson());
    update();
  }

  //password reset email
  Future<void> sendPasswordResetEmail(BuildContext context) async {
    currentState.value = AuthStates.Loading;
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      currentState.value = AuthStates.Normal;
      Get.snackbar('auth.resetPasswordNoticeTitle', 'auth.resetPasswordNotice',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    } on FirebaseAuthException catch (error) {
      currentState.value = AuthStates.Normal;
      Get.snackbar('auth.resetPasswordFailed', error.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //check if user is an admin user
  isAdmin() async {
    await getUser.then((user) async {
      DocumentSnapshot adminRef =
          await _db.collection('admin').doc(user.uid).get();
      if (adminRef.exists) {
        admin.value = true;
      } else {
        admin.value = false;
      }
      update();
    });
  }

  // Sign out
  Future<void> signOut() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    firestoreUser.value = null;
    ThemeController.to.clearThemeMode();
    return _auth.signOut();
  }
}
