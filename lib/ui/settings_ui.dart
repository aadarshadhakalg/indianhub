import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:indianhub/ui/referred_users.dart';
import 'auth/auth.dart';
import 'package:get/get.dart';
import 'components/segmented_selector.dart';
import '../controllers/controllers.dart';
import '../models/models.dart';

class SettingsUI extends StatelessWidget {
  //final LanguageController languageController = LanguageController.to;
  //final ThemeController themeController = ThemeController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: _buildLayoutSection(context),
    );
  }

  Widget _buildLayoutSection(BuildContext context) {
    return ListView(
      children: <Widget>[
        themeListTile(context),
        ListTile(
          title: Text('Update Profile'),
          trailing: ElevatedButton(
            onPressed: () async {
              Get.to(UpdateProfileUI());
            },
            child: Text(
              'Update',
            ),
          ),
        ),
        ListTile(
          title: Text('Reffered Users'),
          trailing: ElevatedButton(
            onPressed: () {
              Get.to(ReferredUsers());
            },
            child: Text(
              'View All',
            ),
          ),
        ),
        ListTile(
          title: Text('Signout'),
          trailing: ElevatedButton(
            onPressed: () {
              AuthController.to.signOut();
            },
            child: Text(
              'Signout',
            ),
          ),
        )
      ],
    );
  }

  themeListTile(BuildContext context) {
    final List<MenuOptionsModel> themeOptions = [
      MenuOptionsModel(
          key: "system", value: 'System', icon: Icons.brightness_4),
      MenuOptionsModel(
          key: "light", value: 'Light', icon: Icons.brightness_low),
      MenuOptionsModel(key: "dark", value: 'Dark', icon: Icons.brightness_3)
    ];
    return GetBuilder<ThemeController>(
      builder: (controller) => ListTile(
        title: Text('Theme'),
        subtitle: SegmentedSelector(
          selectedOption: controller.currentTheme,
          menuOptions: themeOptions,
          onValueChanged: (value) {
            controller.setThemeMode(value);
          },
        ),
      ),
    );
  }
}
