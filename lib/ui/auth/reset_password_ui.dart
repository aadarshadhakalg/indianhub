import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'auth.dart';
import '../components/components.dart';
import '../../helpers/helpers.dart';
import '../../controllers/controllers.dart';

class ResetPasswordUI extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: GetX(
        builder: (AuthController controller) {
          if(controller.currentState.value == AuthStates.Normal){
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
                        controller: authController.emailController,
                        iconPrefix: Icons.email,
                        labelText: 'Your Email Address',
                        validator: Validator().email,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => null,
                        onSaved: (value) =>
                            authController.emailController.text = value as String,
                      ),
                      FormVerticalSpace(),
                      PrimaryButton(
                          labelText: 'Send Password Reset Link',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await authController.sendPasswordResetEmail(context);
                            }
                          }),
                      FormVerticalSpace(),
                      signInLink(context),
                    ],
                  ),
                ),
              ),
            ),
          );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }

  appBar(BuildContext context) {
    if (authController.emailController.text == '') {
      return null;
    }
    return AppBar(title: Text('Your Email Address'));
  }

  signInLink(BuildContext context) {
    if (authController.emailController.text == '') {
      return LabelButton(
        labelText: 'Sign In',
        onPressed: () => Get.offAll(SignInUI()),
      );
    }
    return Container(width: 0, height: 0);
  }
}
