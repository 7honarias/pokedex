import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/home.dart';

var users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

Duration get loginTime => Duration(milliseconds: 2250);

Future<String> _authUser(LoginData data) {
  print('Name: ${data.name}, Password: ${data.password}');
  return Future.delayed(loginTime).then((_) {
    if (!users.containsKey(data.name)) {
      return 'Username not exists';
    }
    if (users[data.name] != data.password) {
      return 'Password does not match';
    }
    return null;
  });
}

Future<String> _regisUser(LoginData data) {
  print('Name: ${data.name}, Password: ${data.password}');
  return Future.delayed(loginTime).then((_) {
    if (users.containsKey(data.name)) {
      return 'Username exists';
    }
    users[data.name] = data.password;
    print(users);
    return null;
  });
}

Future<String> _recoverPassword(String name) {
  print('Name: $name');
  return Future.delayed(loginTime).then((_) {
    if (!users.containsKey(name)) {
      return 'Username not exists';
    }
    return null;
  });
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'POKEDEX',
      logo: 'assets/pokemon.png',
      onLogin: _authUser,
      onSignup: _regisUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
        usernameHint: 'Username',
        passwordHint: 'Pass',
        confirmPasswordHint: 'Confirm',
        loginButton: 'LOG IN',
        signupButton: 'REGISTER',
        forgotPasswordButton: 'Forgot huh?',
        recoverPasswordButton: 'HELP ME',
        goBackButton: 'GO BACK',
        confirmPasswordError: 'Not match!',
        recoverPasswordDescription:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
        recoverPasswordSuccess: 'Password rescued successfully',
      ),
    );
  }
}
