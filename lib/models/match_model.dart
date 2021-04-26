//Transaction Model

class MatchModel {
  final String teamAname;
  final String teamBname;
  final int team;
  final String uid;
  final String status;
  final String? response;
  final String transactionMedium;
  final String? transactionId;
  final String? transactionTime;
  final String? withdrawlAccount;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.uid,
    required this.status,
    this.response,
    required this.transactionMedium,
    this.transactionId,
    this.transactionTime,
    this.withdrawlAccount,
    required this.date,
  });

  factory TransactionModel.fromMap(Map data) {
    return TransactionModel(
      id: data['id'],
      type: data['type'],
      amount: data['amount'],
      uid: data['uid'],
      status: data['status'],
      response: data['response'] ?? 'No Response from Admin',
      transactionMedium: data['transactionMedium'],
      transactionId: data['transactionId'] ?? 'Empty',
      transactionTime: data['transactionTime'] ?? 'Not Provided',
      withdrawlAccount: data['withdrawlAccount'] ?? 'NULL',
      date: DateTime.fromMillisecondsSinceEpoch(data['date']),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "amount": amount,
        "uid": uid,
        'status': status,
        'response': response,
        'transactionMedium': transactionMedium,
        'transactionId': transactionId,
        'transactionTime':transactionTime,
        'withdrawlAccount':withdrawlAccount,
        'date':date
      };
}
