import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mxg/routes.dart';
import 'package:mxg/services/all_services.dart';
import 'package:mxg/services/services.dart';
import 'package:mxg/widgets/password_field.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool _obscureText;
  late Future<User?> _checkSessionFuture;

  late FormGroup form = FormGroup({
    'email': FormControl<String>(
        validators: [Validators.email, Validators.required]),
    'password': FormControl<String>(
        validators: [Validators.required]),
  });

  @override
  void initState() {
    _obscureText = true;
    _checkSessionFuture = checkSession();
    super.initState();
  }

  void toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<User?> checkSession() async {
    var user = await getIt<AuthService>().getCurrentUser();
    if (user != null) {
      getIt<NavigationService>().push(Routes.home, clear: true);
    }
    return user;
  }

  Future<void> handleLogin() async {
    try {
      if (form.valid) {
        var user = await getIt<AuthService>().login(
            form.control('email').value.toString().trim(),
            form.control('password').value);
        if (user != null) {
          getIt<NavigationService>().push(Routes.home, clear: true);
        }
      }
    } catch (e) {
      getIt<NotificationService>().showSnackMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: _checkSessionFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error initializing app.'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return Center(
                child: ReactiveFormBuilder(
                  form: () => form,
                  builder: (context, form, child) => SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ReactiveTextField(
                          formControlName: 'email',
                          validationMessages: (fc) => {
                            ValidationMessage.email: 'Must be a valid email.',
                            ValidationMessage.required: 'Must not be empty'
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email',
                          ),
                        ),
                        PasswordField(
                          formControlName: 'password',
                          hintText: 'Password',
                          textInputAction: TextInputAction.done,
                        ),
                        TextButton(
                          child: Text('Login'),
                          onPressed: handleLogin,
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            getIt<NavigationService>().push(Routes.signup);
                          },
                          child: Text('Sign Up'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
