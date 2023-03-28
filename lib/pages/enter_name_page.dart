import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/pages/game_page.dart';

class EnterNamePage extends StatefulWidget {
  const EnterNamePage({Key? key}) : super(key: key);

  @override
  State<EnterNamePage> createState() => _EnterNamePageState();
}

class _EnterNamePageState extends State<EnterNamePage> {
  var fontStyle = const TextStyle(
    decoration: TextDecoration.none,
    fontSize: 40,
    color: Colors.white,
    fontFamily: 'FredokaOne',
  );
  var miniFontStyle = const TextStyle(
    decoration: TextDecoration.none,
    fontSize: 25,
    color: Colors.white,
    fontFamily: 'FredokaOne',
  );
  final TextEditingController _nameP1 = TextEditingController();
  final TextEditingController _nameP2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepOrangeAccent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Center(
                child: Text(
                  'ENTER YOUR NAME',
                  style: fontStyle,
                ),
              ),
              const Icon(
                Icons.videogame_asset,
                size: 60,
                color: Colors.white,
              ),
              const SizedBox(height: 100),
              Text(
                'PLAYER 1',
                style: miniFontStyle,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _nameP1,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Enter Name',
                  ),
                  maxLines: 1,
                  maxLength: 12,
                ),
              ),
              const SizedBox(height: 100),
              Text(
                'PLAYER 2',
                style: miniFontStyle,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _nameP2,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Enter Name',
                  ),
                  maxLines: 1,
                  maxLength: 12,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GamePage(
                            nameP1: _nameP1.text, nameP2: _nameP2.text)),
                  );
                  final player = AudioCache();
                  player.play('comedy_pop_finger_in_mouth_001.mp3');
                },
                child: const Text(
                  "let's go",
                  style: TextStyle(fontSize: 20, fontFamily: 'FredokaOne'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text(
                    'GOOD LUCK HAVE FUN',
                    style: TextStyle(fontSize: 16, fontFamily: 'FredokaOne'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}