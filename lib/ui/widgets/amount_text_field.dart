
import 'package:flutter/material.dart';
import 'package:money_minder/models/category_list.dart';

class AmountTextField extends StatelessWidget {
  const AmountTextField({
    super.key,
    required this.amountController, required this.categoryDataTextField, required this.onSubmitted,
  });

  final TextEditingController amountController;
  final  CategoryData categoryDataTextField;
  final void Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:  amountController,
      autofocus: true,
      keyboardType: TextInputType.number,
      onSubmitted: onSubmitted ,

      decoration: InputDecoration(
        label:  Text("${ categoryDataTextField.name} Expense"),
        prefixIcon:  Icon(categoryDataTextField.icon,color: categoryDataTextField.color,),


        hintText: "100 e.g",

        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15)
        ),

      ),
    );
  }
}