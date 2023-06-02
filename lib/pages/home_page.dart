// Giriş yapılınca karşılayacak sayfa: 'homePage'
// ignore_for_file: file_names

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:yuruyus_app/pages/console.dart';
import 'package:yuruyus_app/pages/gunce_page.dart';
import 'package:yuruyus_app/pages/profile_page.dart';
import 'package:yuruyus_app/pages/settings.dart';
import 'gezgin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  final user = FirebaseAuth.instance.currentUser!;
  // late Stream<StepCount> _stepCountStream;

  // String _steps = '?';
  // int _stepsStartValue = 0;
  // void onStepCount(StepCount event) {
  //   log(event.toString());
  //   setState(() {
  //     if (_stepsStartValue == 0) {
  //       _stepsStartValue = event.steps;
  //     }
  //     _steps = (event.steps - _stepsStartValue).toString();
  //   });
  // }

  // void onStepCountError(error) {
  //   log('onStepCountError: $error');
  //   setState(() {
  //     _steps = 'Step Count not available';
  //   });
  // }

  // void initPlatformState() {
  //   _stepCountStream = Pedometer.stepCountStream;
  //   _stepCountStream.listen(onStepCount).onError(onStepCountError);
  //   if (!mounted) return;
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  //   WidgetsBinding.instance.addObserver(this);
  // }
  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }
  
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);

  //   if (state == AppLifecycleState.detached) {
  //     fonksiyonuCalistir();
  //   }
  // }

  // void fonksiyonuCalistir() {
  //   // Uygulama tamamen kapatıldığında yapılacak işlemler burada yer alır
  //   print("Uygulama tamamen kapatıldı");
  //   // ...
  // }
  int _selectedIndex = 1; // for the BottomNavigationBarItem
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _childeren = [
    const UserGezgin(),
    const UserGunce(),
    ProfilePage(uid: FirebaseAuth.instance.currentUser!.uid),
    //const UserProfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //appBar: AppBar(backgroundColor: Colors.lightBlue,),
        body: _childeren[_selectedIndex],
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   log('ender');

        // },
        // child: Text('deded'),),
        drawer: Container(
          width: 205,
          child: Drawer(
            //drawer Code
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: ListTile(
                      hoverColor: Colors.blue,
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'Ayarlar',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SettingsPage();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: ListTile(
                      hoverColor: Colors.blue,
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: const Icon(
                        Icons.content_paste_search_outlined,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'Konsol',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ConsolePage();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ListTile(
                        hoverColor: Colors.blue,
                        dense: true,
                        visualDensity: const VisualDensity(vertical: -4),
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        title: const Text(
                          'Çıkış',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.data_usage_sharp,
              ),
              label: 'gezgin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.all_inclusive_outlined),
              label: 'Günce',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'profil',
            ),
          ],
        ),
      ),
    );
  }
}
