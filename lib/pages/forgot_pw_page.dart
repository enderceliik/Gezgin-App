import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
        
      );
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              '${_emailController.text} adresine şifre sıfırlama linki gönderildi!',
            ),
          );
        },
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'Sıfırlama linkini gönderebilmemiz için E-Posta adresinizi girin:',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 5,
            ),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'E-Posta',
                hintStyle: const TextStyle(color: Colors.lightBlue),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _emailController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: MaterialButton(
              onPressed: passwordReset,
              color: Colors.blue,
              child:  const Text(
                'Şifremi sıfırla',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
