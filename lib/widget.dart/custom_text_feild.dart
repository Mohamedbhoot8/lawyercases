import 'package:flutter/material.dart';

class CustomTextFeild extends StatelessWidget {
  const CustomTextFeild(
      {super.key,
      this.controller,
      this.keyboardtype,
      this.prefixicon,
      this.labeltext,
      this.value});
  final TextEditingController? controller;
  final TextInputType? keyboardtype;
  final Widget? prefixicon;
  final String? labeltext;
  final String? Function(String?)? value;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
          controller: controller,
          keyboardType: keyboardtype,
          decoration:
              InputDecoration(prefixIcon: prefixicon, labelText: labeltext),
          validator: value),
    );
  }
}
