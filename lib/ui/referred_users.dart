import 'package:flutter/material.dart';
import 'package:indianhub/controllers/controllers.dart';
import 'package:indianhub/helpers/firestore_helper.dart';
import 'package:indianhub/models/user_model.dart';

class ReferredUsers extends StatelessWidget {
  final FireStoreHelper _fireStoreHelper = FireStoreHelper();
  final AuthController _authController = AuthController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reffered Users'),
      ),
      body: FutureBuilder(
          future: _fireStoreHelper
              .getReferredUsers(_authController.firestoreUser.value!.referral),
          builder:
              (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data?[index].photoUrl ?? ''),
                    ),
                    title: Text(snapshot.data?[index].name ?? 'Unknown User'),                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
