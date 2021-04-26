import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:core';
import 'package:get/get.dart';
import 'auth.dart';
import '../components/components.dart';
import '../../helpers/helpers.dart';
import '../../controllers/controllers.dart';

class SignInUI extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
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
                        labelText: 'Your Email',
                        validator: Validator().email,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => null,
                        onSaved: (value) =>
                            authController.emailController.text = value!,
                      ),
                      FormVerticalSpace(),
                      FormInputFieldWithIcon(
                        controller: authController.passwordController,
                        iconPrefix: Icons.lock,
                        labelText: 'Your Password',
                        validator: Validator().password,
                        obscureText: true,
                        onChanged: (value) => null,
                        onSaved: (value) =>
                            authController.passwordController.text = value!,
                        maxLines: 1,
                      ),
                      FormVerticalSpace(),
                      PrimaryButton(
                          labelText: 'Sign In',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              authController.signInWithEmailAndPassword(context);
                            }
                          }),
                      FormVerticalSpace(),
                      LabelButton(
                        labelText: 'Reset Password',
                        onPressed: () => Get.to(ResetPasswordUI()),
                      ),
                      LabelButton(
                        labelText: 'Sign Up',
                        onPressed: () => Get.to(SignUpUI()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );}else{
            return Center(child: CircularProgressIndicator(),);
          }
        }
      ),
    );
  }
}
