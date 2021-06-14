import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PasswordField extends StatefulWidget {
  final String formControlName;
  final String hintText;
  final TextInputAction textInputAction;
  final void Function()? onSubmitted;
  final ValidationMessagesFunction? validationMessages;
  final bool showErrors;

  PasswordField({
    Key? key,
    required this.formControlName,
    required this.hintText,
    required this.textInputAction,
    this.validationMessages,
    this.onSubmitted,
    this.showErrors = true,
  }) : super(key: key);

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
      showErrors: widget.showErrors ? null : (fc) => widget.showErrors,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,),
          onPressed: toggleObscureText,
        ),
      ),
      validationMessages: widget.validationMessages,
    );
  }
}
