import 'package:flutter/material.dart';
import 'package:indianhub/controllers/controllers.dart';
import 'package:indianhub/helpers/firestore_helper.dart';
import 'package:indianhub/models/user_model.dart';
import 'package:share/share.dart';

class ReferredUsers extends StatelessWidget {
  final FireStoreHelper _fireStoreHelper = FireStoreHelper();
  final AuthController _authController = AuthController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reffer and Earn'),
        actions: [
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(
                    'Download IndiaHub app from here and use my referral code: ${_authController.firestoreUser.value!.referral} while creating account to get 10 app points',
                    subject: 'Download The App');
              })
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: 'Your Referral Code is :',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: _authController.firestoreUser.value!.referral,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent),
              )
            ]),
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(),
          Center(
            child: Text('Your Referred Users'),
          ),
          Divider(),
          Expanded(
            child: FutureBuilder(
                future: _fireStoreHelper.getReferredUsers(
                    _authController.firestoreUser.value!.referral),
                builder: (BuildContext context,
                    AsyncSnapshot<List<UserModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data?[index].photoUrl ?? ''),
                          ),
                          title: Text(
                              snapshot.data?[index].name ?? 'Unknown User'),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }
}
