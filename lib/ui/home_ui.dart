import 'package:flutter/material.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';
import 'ui.dart';
import 'package:get/get.dart';

class HomeUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) => controller.firestoreUser.value?.uid == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              drawer: Drawer(
                child: Column(
                  children: [
                    UserAccountsDrawerHeader(
                      currentAccountPicture: Avatar(controller.firestoreUser.value!),
                      accountName: Text(controller.firestoreUser.value!.name),
                      accountEmail: Text('Balance : ' + controller.firestoreUser.value!.points.toString()),
                    )
                  ],
                ),
              ),
              appBar: AppBar(
                title: Text(
                  'IndianHUB',
                  style: TextStyle(fontSize: 22.0),
                ),
                actions: [
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Get.to(SettingsUI());
                      }),
                ],
              ),
              body: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 120),
                    Avatar(controller.firestoreUser.value!),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FormVerticalSpace(),
                        Text(
                            'UUID' + ': ' + controller.firestoreUser.value!.uid,
                            style: TextStyle(fontSize: 16)),
                        FormVerticalSpace(),
                        Text(
                            'Name' +
                                ': ' +
                                controller.firestoreUser.value!.name,
                            style: TextStyle(fontSize: 16)),
                        FormVerticalSpace(),
                        Text(
                            'Email' +
                                ': ' +
                                controller.firestoreUser.value!.email,
                            style: TextStyle(fontSize: 16)),
                        FormVerticalSpace(),
                        Text(
                            'isAdmin' +
                                ': ' +
                                controller.admin.value.toString(),
                            style: TextStyle(fontSize: 16)),
                        FormVerticalSpace(),
                        Text(
                            'Referral Code' +
                                ': ' +
                                controller.firestoreUser.value!.referral,
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
