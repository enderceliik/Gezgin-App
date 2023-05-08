import 'package:flutter/material.dart';
import 'package:yuruyus_app/pages/sign_page.dart';
import 'package:yuruyus_app/pages/login_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;
  void toggleScreens()
  {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if(showLoginPage) 
    {
      //return loginPage();
      return LoginPage(showSignPage: toggleScreens);
    }
    else
    {
      return SignPage(showloginPage: toggleScreens);
    }
  }
}