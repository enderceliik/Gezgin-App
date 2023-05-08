import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void profilePhotoSelecterFunction() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Ayarlar',
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            // HESAP BİLGİLERİ
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              onTap: () {
                print(
                  'tryy',
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 5.0,
                ),
                child: Text(
                  'Hesap bilgileri',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
          const Divider(height: 10),
          Container(
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              onTap: () {
                print(
                  'profil düzeneleme',
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 5.0,
                ),
                child: Text(
                  'Profil Düzenleme',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
