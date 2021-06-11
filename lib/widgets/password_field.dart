import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PasswordField extends StatefulWidget {
  final String formControlName;
  final String hintText;
  final TextInputAction textInputAction;
  final ValidationMessagesFunction? validationMessages;

  PasswordField(
      {Key? key,
      required this.formControlName,
      required this.hintText,
      required this.textInputAction,
      this.validationMessages})
      : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = true;
    super.initState();
  }

  void toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      formControlName: widget.formControlName,
      obscureText: _obscureText,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleObscureText,
        ),
      ),
      validationMessages: widget.validationMessages,
    );
  }
}
