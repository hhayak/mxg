import 'package:flutter/material.dart';
import 'package:mxg/models/mxg_user.dart';
import 'package:mxg/routes.dart';
import 'package:mxg/services/services.dart';
import 'package:mxg/services/user_service.dart';
import 'package:mxg/widgets/future_button.dart';
import 'package:mxg/widgets/password_field.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignupPage extends StatelessWidget {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final FormGroup form = FormGroup(
    {
      'email': FormControl<String>(validators: [Validators.email]),
      'password': FormControl<String>(),
      'confirmPassword': FormControl<String>(),
    },
    validators: [
      Validators.mustMatch('password', 'confirmPassword'),
      Validators.required
    ],
  );

  Future<void> handleSignup() async {
    if (form.touched && form.valid) {
      try {
        var user = await getIt<AuthService>().signup(
            form.control('email').value.toString().trim(),
            form.control('password').value);
        if (user != null) {
          var mxgUser = MxgUser(user.uid, 'f', 'l', null);
          getIt<UserService>().addUser(mxgUser);
          getIt<NavigationService>().push(Routes.home, clear: true);
        }
      } catch (e) {
        _btnController.softError();
        getIt<NotificationService>().showSnackMessage(e.toString());
      }
    } else {
      _btnController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: ReactiveFormBuilder(
            form: () => form,
            builder: (context, form, child) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ReactiveTextField(
                    formControlName: 'email',
                    textInputAction: TextInputAction.next,
                    onSubmitted: () => form.focus('password'),
                    keyboardType: TextInputType.emailAddress,
                    validationMessages: (fc) => {
                      ValidationMessage.email: 'Must be a valid email.',
                      ValidationMessage.required: 'This field is required.',
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  PasswordField(
                    formControlName: 'password',
                    hintText: 'Password',
                    textInputAction: TextInputAction.next,
                    onSubmitted: () => form.focus('confirmPassword'),
                    validationMessages: (fc) => {
                      ValidationMessage.required: 'This field is required.',
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  PasswordField(
                    formControlName: 'confirmPassword',
                    hintText: 'Confirm Password',
                    textInputAction: TextInputAction.done,
                    validationMessages: (fc) => {
                      ValidationMessage.required: 'This field is required.',
                      ValidationMessage.mustMatch: 'Passwords must match.',
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FutureButton(
                    controller: _btnController,
                    onPressed: handleSignup,
                    text: 'Sign up',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
