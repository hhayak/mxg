import 'package:flutter/material.dart';
import 'package:mxg/services/all_services.dart';
import 'package:mxg/services/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignupPage extends StatelessWidget {
  final FormGroup form = FormGroup(
    {
      'email': FormControl<String>(
          validators: [Validators.email, Validators.required]),
      'password': FormControl<String>(validators: [Validators.required]),
      'confirmPassword': FormControl<String>(validators: [Validators.required]),
    },
    validators: [Validators.mustMatch('password', 'confirmPassword')],
  );

  Future<void> signup() async {
    print(form.value);
    if (form.valid) {
      try {
        await getIt<AuthService>().signup(
            form.control('email').value, form.control('password').value);
      } catch (e) {
        getIt<NotificationService>().showSnackMessage(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ReactiveFormBuilder(
          form: () => form,
          builder: (context, form, child) => SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReactiveTextField(
                  formControlName: 'email',
                  validationMessages: (fc) => {
                    ValidationMessage.email: 'Must be a valid email.',
                    ValidationMessage.required: 'Must not be empty'
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                ReactiveTextField(
                  formControlName: 'password',
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: Icon(Icons.remove_red_eye),
                  ),
                ),
                ReactiveTextField(
                  formControlName: 'confirmPassword',
                  validationMessages: (fc) => {
                    ValidationMessage.mustMatch: 'Passwords do not match',
                  },
                  showErrors: (control) => control.invalid && control.touched && control.dirty,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    suffixIcon: Icon(Icons.remove_red_eye),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: signup,
                  child: Text('Signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
