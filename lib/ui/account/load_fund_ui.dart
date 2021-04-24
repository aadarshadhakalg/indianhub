import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indianhub/controllers/transaction_controller.dart';
import 'package:indianhub/helpers/validator.dart';
import 'package:indianhub/ui/components/form_input_field_with_icon.dart';
import 'package:indianhub/ui/components/form_vertical_spacing.dart';

class LoadFund extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetX(builder: (TransactionController controller) {
      if (controller.currentState.value == TransactionStates.Normal) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Load Fund'),
          ),
          body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/qr.jpg',
                      height: 200,
                    ),
                    FormVerticalSpace(),
                    Text(
                        'Scan the Qr and pay and add payment details in below form and click on load fund to load fund.'),
                    FormVerticalSpace(),
                    FormInputFieldWithIcon(
                      controller: controller.loadAmountController,
                      keyboardType: TextInputType.number,
                      iconPrefix: Icons.attach_money_rounded,
                      labelText: 'Amount',
                      validator: Validator().amount,
                      onChanged: (value) => null,
                      onSaved: (value) =>
                          controller.loadAmountController.text = value!,
                      maxLines: 1,
                    ),
                    FormVerticalSpace(),
                    FormInputFieldWithIcon(
                      controller: controller.transactionIdController,
                      iconPrefix: Icons.credit_card,
                      labelText: 'Transaction Id',
                      validator: Validator().notEmpty,
                      onChanged: (value) => null,
                      onSaved: (value) =>
                          controller.transactionIdController.text = value!,
                      maxLines: 1,
                    ),
                    FormVerticalSpace(),
                    FormInputFieldWithIcon(
                      controller: controller.transactionTimeController,
                      keyboardType: TextInputType.datetime,
                      iconPrefix: Icons.watch,
                      labelText: 'Transaction Time',
                      validator: Validator().notEmpty,
                      onChanged: (value) => null,
                      onSaved: (value) =>
                          controller.transactionTimeController.text = value!,
                      maxLines: 1,
                    ),
                    FormVerticalSpace(),
                    Container(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Payment Method",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.black12.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButton(
                              isDense: true,
                              underline: Text(''),
                              value: controller.selectedWithdrawlMethod.value,
                              items: controller.allLoadMethods
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                controller.selectedWithdrawlMethod.value =
                                    value.toString();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    FormVerticalSpace(),
                    ElevatedButton(
                      onPressed: () async{
                        if(_formKey.currentState!.validate()){
                          await controller.requestLoad();
                        }
                      },
                      child: Text('Request Load'),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
