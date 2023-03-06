import 'package:flutter/material.dart';
import 'package:lab/services/http_service.dart';

import 'home_page.dart';

class LoginView extends StatefulWidget {
  const LoginView({this.autologin = false, super.key});

  final bool autologin;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _userCtrl = TextEditingController(text: "damaro");
  final TextEditingController _passCtrl =
      TextEditingController(text: "Iop**123");
  final HttpService _httpService = HttpService();

  _LoginViewState();

  _showSnackBar(
      {bool isSuccess = true,
      required String text,
      required BuildContext context}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    ));
  }

  _login(BuildContext context) {
    String user = _userCtrl.text;
    String pass = _passCtrl.text;

    FocusManager.instance.primaryFocus?.unfocus();
    _httpService.login(username: user, password: pass).then((bool value) {
      if (value) {
        /// NAVEGAR
        // _showSnackBar(context: context, text: 'tostabien');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MyHomePage(
                    title: 'Flutter Demo Home Page',
                  )),
        );
      } else {
        _showSnackBar(
            context: context, text: 'contraseña incorrecta', isSuccess: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.autologin) {
      _httpService
          .getMe()
          .then((value) => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyHomePage(
                            title: 'Flutter Demo Home Page',
                          )),
                )
              })
          .onError((error, stacktrace) => _showSnackBar(
              context: context, text: 'can\'t autologin', isSuccess: false));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          children: [
            TextFormField(
                controller: _userCtrl,
                decoration: const InputDecoration(label: Text('Username'))),
            TextFormField(
                controller: _passCtrl,
                decoration: const InputDecoration(label: Text('Password')),
                obscureText: true),
            ElevatedButton(
                onPressed: () => _login(context), child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
