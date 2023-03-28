import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'enter_name_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var fontStyle = const TextStyle(
    decoration: TextDecoration.none,
    fontSize: 40,
    color: Colors.white,
    fontFamily: 'FredokaOne',
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepOrangeAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WELCOME',
              style: fontStyle,
            ),
            Text(
              'TIC TAC TOE\n      GAME',
              style: fontStyle,
            ),
            const Icon(
              Icons.videogame_asset,
              size: 120,
              color: Colors.white,
            ),
            ElevatedButton(
              child: const Text(
                'START',
                style: TextStyle(fontSize: 20, fontFamily: 'FredokaOne'),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EnterNamePage()),
                );
                final player = AudioCache();
                player.play('comedy_pop_finger_in_mouth_001.mp3');
              },
            )
          ],
        ),
      ),
    );
  }
}
