// Giriş yapılınca karşılayacak sayfa: 'homePage'
// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

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
