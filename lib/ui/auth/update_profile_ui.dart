import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../models/models.dart';
import '../components/components.dart';
import '../../helpers/helpers.dart';
import '../../controllers/controllers.dart';
import 'auth.dart';

class UpdateProfileUI extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    //print('user.name: ' + user?.value?.name);
    authController.nameController.text =
        authController.firestoreUser.value!.name;
    authController.emailController.text =
        authController.firestoreUser.value!.email;
    return Scaffold(
      appBar: AppBar(title: Text('auth.updateProfileTitle')),
      body: GetX(builder: (AuthController controller) {
        if (controller.currentState.value == AuthStates.Normal) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      LogoGraphicHeader(),
                      SizedBox(height: 48.0),
                      FormInputFieldWithIcon(
                        controller: authController.nameController,
                        iconPrefix: Icons.person,
                        labelText: 'auth.nameFormField',
                        validator: Validator().name,
                        onChanged: (value) => null,
                        onSaved: (value) =>
                            authController.nameController.text = value!,
                      ),
                      FormVerticalSpace(),
                      FormInputFieldWithIcon(
                        controller: authController.emailController,
                        iconPrefix: Icons.email,
                        labelText: 'auth.emailFormField',
                        validator: Validator().email,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => null,
                        onSaved: (value) =>
                            authController.emailController.text = value!,
                      ),
                      FormVerticalSpace(),
                      PrimaryButton(
                          labelText: 'auth.updateUser',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              UserModel _updatedUser = UserModel(
                                uid: authController.firestoreUser.value!.uid,
                                name: authController.nameController.text,
                                email: authController.emailController.text,
                                photoUrl: authController
                                    .firestoreUser.value!.photoUrl,
                                referral: authController
                                    .firestoreUser.value!.referral,
                              );
                              _updateUserConfirm(context, _updatedUser,
                                  authController.firestoreUser.value!.email);
                            }
                          }),
                      FormVerticalSpace(),
                      LabelButton(
                        labelText: 'auth.resetPasswordLabelButton',
                        onPressed: () => Get.to(ResetPasswordUI()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Future<void> _updateUserConfirm(
      BuildContext context, UserModel updatedUser, String oldEmail) async {
    final AuthController authController = AuthController.to;
    final TextEditingController _password = new TextEditingController();
    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        title: Text(
          'auth.enterPassword',
        ),
        content: FormInputFieldWithIcon(
          controller: _password,
          iconPrefix: Icons.lock,
          labelText: 'auth.passwordFormField',
          validator: (value) {
            String pattern = r'^.{6,}$';
            RegExp regex = RegExp(pattern);
            if (!regex.hasMatch(value!))
              return 'validator.password';
            else
              return null;
          },
          obscureText: true,
          onChanged: (value) => null,
          onSaved: (value) => _password.text = value!,
          maxLines: 1,
        ),
        actions: <Widget>[
          new TextButton(
            child: new Text('auth.cancel'.toUpperCase()),
            onPressed: () {
              Get.back();
            },
          ),
          new TextButton(
            child: new Text('auth.submit'.toUpperCase()),
            onPressed: () async {
              Get.back();
              await authController.updateUser(
                  context, updatedUser, oldEmail, _password.text);
            },
          )
        ],
      ),
    );
  }
}
