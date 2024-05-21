import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final String erroText;

  const TextFieldInput({super.key, required this.textEditingController, this.isPass = false , required this.hintText, required this.textInputType, this.erroText = ''});

  @override
  Widget build(BuildContext context) {
    final inputBoder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(10),
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        errorText: erroText,
        hintText: hintText,
        border: inputBoder,
        focusedBorder:inputBoder,
        enabledBorder: inputBoder,
        filled: true,
        contentPadding: EdgeInsets.all(8)
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
