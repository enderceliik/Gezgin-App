// @dart=2.9
// E-Posta ve şifre girilerek giriş yapılan ekran: 'loginScreen'

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showSignPage;
  const LoginPage({key, this.showSignPage}) : super(key: key);
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Username and Password text controller variables defining:
  final _textControllerUsername = TextEditingController();
  final _textControllerPassword = TextEditingController();

  String userName = '';
  String password = '';

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _textControllerUsername.text.trim(),
        password: _textControllerPassword.text.trim(),
      );
    } on FirebaseAuthException catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(exception.message.toString(),
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Tamam',
            onPressed: (){},
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    //Memory management
    _textControllerUsername.dispose();
    _textControllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.1,
                0.5,
                0.9,
              ],
              colors: [
                Color.fromARGB(1, 153, 226, 255),
                Colors.teal,
                Colors.indigo,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                  ),
                  child: Container(
                    width: 275,
                    height: 275,
                    child: Image.asset(
                      'lib/images/walk2.png',
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    bottom: 30.0,
                    top: 10.0,
                  ),
                  child: Text(
                    'Birlikte Yürüyelim!',
                    style: TextStyle(
                      fontFamily: 'Shadows_Into_Light',
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 5,
                ),
                child: GestureDetector(
                  onTap: signIn,
                  child: TextField(
                    controller: _textControllerUsername,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail, color: Colors.blueAccent),
                      hintText: 'E-Posta',
                      hintStyle: const TextStyle(color: Colors.lightBlue),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      suffixIcon: IconButton(
                              onPressed: () {
                                _textControllerUsername.clear();
                              },
                              icon: const Icon(Icons.clear),
                            ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 5,
                  bottom: 5,
                ),
                child: TextField(
                  obscureText: true,
                  controller: _textControllerPassword,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.lock, color: Colors.blueAccent),
                    hintText: 'Parola',
                    hintStyle: const TextStyle(color: Colors.lightBlue),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _textControllerPassword.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 29.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ForgotPasswordPage();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Şifremi unuttum',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: MaterialButton(
                  onPressed: signIn,
                  color: Colors.lightBlue,
                  child: const Text(
                    'Giriş Yap',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    'Hesabın yok mu?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.showSignPage,
                    child: const Text(
                      ' Kayıt ol',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
