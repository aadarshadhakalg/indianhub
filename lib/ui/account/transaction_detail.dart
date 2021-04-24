import 'package:flutter/material.dart';
import 'package:indianhub/models/transaction_model.dart';

class TransactionDetail extends StatelessWidget {
  final TransactionModel model;

  const TransactionDetail({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction Detail'),),
      body: SafeArea(
        child: FutureBuilder(builder:
            (BuildContext context, AsyncSnapshot<TransactionModel> snapshot) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Id: ${model.id}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Divider(),
                Text(
                  'Requested Date: ${model.date}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Divider(),
                Text(
                  'Transaction Type: ${model.type.toUpperCase()}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Divider(),
                Text(
                  'Amount: ${model.amount}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Divider(),
                Text(
                  'Transaction Medium: ${model.transactionMedium}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Divider(),
                Text(
                  'Status: ${model.status.toUpperCase()}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Divider(),
                Text(
                  'Transaction id: ${model.transactionId}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Divider(),
                Text(
                  'Transaction Time: ${model.transactionTime}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Divider(),
                Text(
                  'Response: ${model.response}',
                  style: TextStyle(fontSize: 16.0),
                ),

              ],
            ),
          );
          // } else {
          // return Center(
          // child: CircularProgressIndicator(),
          // );
          // }
        }),
      ),
    );
  }
}
