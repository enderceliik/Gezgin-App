import 'package:flutter/material.dart';

class ConsolePage extends StatefulWidget {
  const ConsolePage({super.key});

  @override
  State<ConsolePage> createState() => _ConsolePageState();
}

class _ConsolePageState extends State<ConsolePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Konsol Ekranı',
              ),
            ),
            body: Column(
              children: [
                const SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Sistemde kayıtlı kullanıcı sayısı: 6', style: TextStyle(fontSize: 16,),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Firestore storage\'deki veri adedi: 6 ve boyutu: 198.66 KB', style: TextStyle(fontSize: 16,),
                    ),
                  ),
                ),
              ],
            )));
  }
}
