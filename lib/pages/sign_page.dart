// Kullanıcı kayıt ol ekranı: 'SignPage'
// ignore_for_file: file_names, library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yuruyus_app/models/user.dart' as UserModel;

class SignPage extends StatefulWidget {
  final VoidCallback showloginPage;
  const SignPage({Key? key, required this.showloginPage}) : super(key: key);
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final _textControllerEmail = TextEditingController();
  final _textControllerPassword = TextEditingController();
  final _textControllerUsername = TextEditingController();
  final _textControllerPasswordConfirmed = TextEditingController();
  //String dropdownValue = list.first;

  @override
  void dispose() {
    //Bellek yönetimi için
    _textControllerEmail.dispose();
    _textControllerPassword.dispose();
    _textControllerPasswordConfirmed.dispose();
    _textControllerUsername.dispose();
    super.dispose();
  }

  Future signUp() async {
    try {
      if (isPasswordConfirmed()) { // Şifre doğrulaması true gelir ise gidip Firebase Authentication gerçekleşiyor mail ve parola ile
        UserCredential cred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _textControllerEmail.text.trim(),
          password: _textControllerPassword.text.trim(),
        );

        UserModel.User user = UserModel.User(
          uid: cred.user!.uid,  //Benzersiz id'yi o belgeye ad olarak verdik. Artık o kullanıcı bizim için bu metin ve sayı karışımı anahtardan ibaret.
          email: _textControllerEmail.text.trim(),
          username: _textControllerUsername.text, //Önce oluşturduğumuz map'e işledik aşağıda ise fonksiyona uzun uzun parametre vermeksizin direkt bu map'i verdik.
          name: '',
          followers: [],
          following: [],
          gunce: '',
          profilePhotoURL: '',
          distance: 0,
          requests: [],
          team: '',
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      }
    } on Exception catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            exception.toString(),
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Tamam',
            onPressed: () {},
          ),
        ),
      );
      // TODO
    }
  }

  bool isPasswordConfirmed() {
    if (_textControllerPassword.text.trim() ==
        _textControllerPasswordConfirmed.text.trim()) {
      return true;
    } else {
      return false;
    }
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
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.white,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: 150,
                  height: 150,
                  child: Image.asset('lib/images/walk2.png'),
                ),
              ),
              const Expanded(
                child: Text(
                  'Aramıza Katıl!',
                  style: TextStyle(
                    fontFamily: 'Shadows_Into_Light',
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    //username TextField
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: TextField(
                      controller: _textControllerUsername,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.lightBlue),
                        hintText: 'Kullanıcı adı',
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 5,
                    ),
                    child: GestureDetector(
                      child: TextField(
                        controller: _textControllerEmail,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Colors.lightBlue),
                          hintText: 'E-Posta',
                          hintStyle: const TextStyle(color: Colors.lightBlue),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _textControllerEmail.clear();
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
                    //Password TextField
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 5,
                    ),
                    child: TextField(
                      obscureText: true,
                      controller: _textControllerPassword,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.lock, color: Colors.lightBlue),
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
                  Padding(
                    //Confirm Password TextField
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 5,
                    ),
                    child: TextField(
                      obscureText: true,
                      controller: _textControllerPasswordConfirmed,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.check_rounded,
                            color: Colors.lightBlue),
                        hintText: 'Parola tekrar',
                        hintStyle: const TextStyle(color: Colors.lightBlue),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _textControllerPasswordConfirmed.clear();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              // DropdownButton<String>(
              //   value: dropdownValue,
              //   elevation: 16,
              //   style: const TextStyle(color: Colors.deepPurple),
              //   underline: Container(
              //     height: 2,
              //     color: Colors.deepPurpleAccent,
              //   ),
              //   onChanged: (String? value) {
              //     // This is called when the user selects an item.
              //     setState(() {
              //       dropdownValue = value!;
              //     });
              //   },
              //   items: list.map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              // ),

              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: MaterialButton(
                  onPressed: () => signUp(),
                  color: Colors.lightBlue,
                  child: const Text(
                    'Kayıt Ol',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    'Hesabın var mı? ',
                    style: TextStyle(color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: widget.showloginPage,
                    child: const Text(
                      'Giriş Yap!',
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
