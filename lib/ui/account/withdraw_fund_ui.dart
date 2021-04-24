import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indianhub/controllers/transaction_controller.dart';
import 'package:indianhub/helpers/validator.dart';
import 'package:indianhub/ui/components/components.dart';

class WithdrawFund extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetX(
      builder: (TransactionController controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Withdraw Fund'),
          ),
          body: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormVerticalSpace(),
                  FormInputFieldWithIcon(
                    controller: controller.withdrawAmountController,
                    keyboardType: TextInputType.number,
                    iconPrefix: Icons.attach_money_rounded,
                    labelText: 'Amount',
                    validator: Validator().withdrawlAmount,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                        controller.withdrawAmountController.text = value!,
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
                          "Withdrawl Medium",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: DropdownButton(
                                underline: Text(""),
                                isDense: true,
                                value: controller.selectedWithdrawlMethod.value,
                                items: controller.allWithdrawlMethods
                                    .map(
                                      (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          )),
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
                        await controller.requestWithdraw();
                      }
                    },
                    child: Text('Request Withdrawl'),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
