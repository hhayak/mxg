import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mxg/routes.dart';
import 'package:mxg/services/all_services.dart';
import 'package:mxg/services/services.dart';
import 'package:mxg/widgets/future_button.dart';
import 'package:mxg/widgets/password_field.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool _obscureText;
  late Future<User?> _checkSessionFuture;
  late RoundedLoadingButtonController _btnController;

  late FormGroup form = FormGroup({
    'email': FormControl<String>(validators: [Validators.required]),
    'password': FormControl<String>(validators: [Validators.required]),
  });

  @override
  void initState() {
    _obscureText = true;
    _checkSessionFuture = checkSession();
    _btnController = RoundedLoadingButtonController();
    super.initState();
  }

  void toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<User?> checkSession() async {
    await getIt<AuthService>().reload();
    var user = getIt<AuthService>().getCurrentUser();
    if (user != null) {
      getIt<NavigationService>().push(Routes.home, clear: true);
    }
    return user;
  }

  Future<void> handleLogin() async {
    try {
      if (form.touched && form.valid) {
        var user = await getIt<AuthService>().login(
            form.control('email').value.toString().trim(),
            form.control('password').value);
        if (user != null) {
          _btnController.success();
          getIt<NavigationService>().push(Routes.home, clear: true);
        }
      } else {
        _btnController.stop();
      }
    } catch (e) {
      _btnController.softError();
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
                  builder: (context, form, child) => Container(
                    width: 300,
                    height: 400,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ReactiveTextField(
                            formControlName: 'email',
                            showErrors: (fc) => false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          PasswordField(
                            formControlName: 'password',
                            showErrors: false,
                            hintText: 'Password',
                            textInputAction: TextInputAction.done,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FutureButton(
                            controller: _btnController,
                            onPressed: handleLogin,
                            text: 'Login',
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          TextButton(
                            onPressed: () {
                              getIt<NavigationService>().push(Routes.signup);
                            },
                            child: Text('Create Account'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(String.fromEnvironment('env')),
                        ],
                      ),
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
