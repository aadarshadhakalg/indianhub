import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indianhub/controllers/controllers.dart';
import 'package:indianhub/helpers/firestore_helper.dart';
import 'package:indianhub/models/transaction_model.dart';
import 'package:indianhub/ui/account/load_fund_ui.dart';
import 'package:indianhub/ui/account/transaction_detail.dart';
import 'package:indianhub/ui/account/withdraw_fund_ui.dart';

class MyAccount extends StatelessWidget {
  final AuthController _authController = AuthController.to;
  final FireStoreHelper _fireStoreHelper = FireStoreHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              title: Text("My Account"),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(
                    kToolbarHeight + kToolbarHeight + kToolbarHeight + 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      elevation: 2.0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              "Your Account Balance:",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0,
                                color: Color(0xFFF909090),
                              ),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              "₹ ${_authController.firestoreUser.value?.points}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 37.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.to(LoadFund());
                            },
                            icon: Icon(Icons.attach_money_outlined),
                            label: Text('Load Fund'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.to(WithdrawFund());
                            },
                            icon: Icon(Icons.money_off),
                            label: Text('Withdraw Fund'),
                          )
                        ],
                      ),
                    ),
                    Card(
                      shape: BeveledRectangleBorder(),
                      margin: const EdgeInsets.symmetric(horizontal: 0.0),
                      // color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            'Your Transactions',
                            style: TextStyle(
                              fontSize: 16.0,
                              letterSpacing: .2,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ];
        },
        body: FutureBuilder(
            future: _fireStoreHelper
                .getMyTransactions(_authController.firestoreUser.value!.uid),
            builder: (BuildContext context,
                AsyncSnapshot<List<TransactionModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              snapshot.data?[index].status == 'pending'
                                  ? Colors.amber
                                  : snapshot.data?[index].status == 'approved'
                                      ? Colors.green
                                      : Colors.red,
                          child: Icon(
                            snapshot.data?[index].status == 'pending'
                                ? Icons.pending_actions
                                : snapshot.data?[index].status == 'approved'
                                    ? Icons.approval
                                    : Icons.remove,color: Colors.white,
                          ),
                        ),
                        title: Text('Amount: ${snapshot.data?[index].amount}'),
                        subtitle:
                            Text('${snapshot.data?[index].type.toUpperCase()}'),
                        onTap: () {
                          Get.to(TransactionDetail(model: snapshot.data![index]));
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Container(
                      height: 100.0,
                      child: Column(
                        children: [Text('No Transactions Found')],
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
