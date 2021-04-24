import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indianhub/ui/account/my-account.dart';

import 'mybets/my_bets_ui.dart';


class DrawerWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('My Account'),
            onTap: (){
              Get.to(MyAccount());
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('My Bets'),
            onTap: (){
              Get.to(MyBets());
            },
          ),
          Divider(),
        ],
      ),
      
    );
  }
}