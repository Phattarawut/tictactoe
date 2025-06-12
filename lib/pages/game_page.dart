// ignore_for_file: must_be_immutable

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/pages/enter_name_page.dart';

class GamePage extends StatefulWidget {
  String nameP1, nameP2;

  GamePage({super.key, required this.nameP1, required this.nameP2});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int scoreP1 = 0;
  int scoreP2 = 0;
  
  var miniFontStyle = const TextStyle(
    decoration: TextDecoration.none,
    fontSize: 25,
    color: Colors.white,
    fontFamily: 'FredokaOne',
  );

  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _board = List.generate(3, (_) => List.generate(3, (_) => ''));
    _currentPlayer = 'X';
    _winner = '';
    _gameOver = false;
  }

  // Reset Game
  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ''));
      _currentPlayer = 'X';
      _winner = '';
      _gameOver = false;
      final player = AudioCache();
      player.play('comedy_pop_finger_in_mouth_001.mp3');
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] != '' || _gameOver) {
      return;
    }

    final player = AudioCache();
    player.play('comedy_pop_finger_in_mouth_001.mp3');

    setState(() {
      _board[row][col] = _currentPlayer;

      // check for a win
      if ((_board[row][0] == _currentPlayer &&
              _board[row][1] == _currentPlayer &&
              _board[row][2] == _currentPlayer) ||
          (_board[0][col] == _currentPlayer &&
              _board[1][col] == _currentPlayer &&
              _board[2][col] == _currentPlayer) ||
          (_board[0][0] == _currentPlayer &&
              _board[1][1] == _currentPlayer &&
              _board[2][2] == _currentPlayer) ||
          (_board[0][2] == _currentPlayer &&
              _board[1][1] == _currentPlayer &&
              _board[2][0] == _currentPlayer)) {
        _winner = _currentPlayer;
        _gameOver = true;
      }

      // check for a tie
      if (!_gameOver &&
          !_board.any((row) => row.any((cell) => cell == ''))) {
        _gameOver = true;
        _winner = "It's a Tie";
      }

      // Show result
      if (_gameOver) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          btnOkText: 'Play Again',
          title: _winner == 'X'
              ? '${widget.nameP1} Won!'
              : _winner == 'O'
                  ? '${widget.nameP2} Won!'
                  : "It's a Tie",
          btnOkOnPress: () {
            _resetGame();
          },
        ).show();

        if (_winner == 'X') {
          scoreP1++;
          player.play('winnerchickendinner.mp3');
        } else if (_winner == 'O') {
          scoreP2++;
          player.play('winnerchickendinner.mp3');
        }
      } else {
        // switch player
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header Section
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Player Names
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.nameP1,
                                textAlign: TextAlign.center,
                                style: miniFontStyle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.nameP2,
                                textAlign: TextAlign.center,
                                style: miniFontStyle,
                              ),
                            ),
                          ],
                        ),
                        // Scores
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Score : $scoreP1',
                                textAlign: TextAlign.center,
                                style: miniFontStyle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Score : $scoreP2',
                                textAlign: TextAlign.center,
                                style: miniFontStyle,
                              ),
                            ),
                          ],
                        ),
                        // Current Turn
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Turn : ',
                              style: miniFontStyle,
                            ),
                            Text(
                              _currentPlayer == 'X'
                                  ? "${widget.nameP1} ($_currentPlayer)"
                                  : "${widget.nameP2} ($_currentPlayer)",
                              style: miniFontStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Game Board - Full Screen
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      itemCount: 9,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        int row = index ~/ 3;
                        int col = index % 3;
                        return GestureDetector(
                          onTap: () => _makeMove(row, col),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                _board[row][col],
                                style: TextStyle(
                                  fontSize: 80,
                                  fontFamily: 'FredokaOne',
                                  color: _board[row][col] == 'X'
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Buttons Section
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Reset Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _resetGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Reset Game',
                            style: miniFontStyle,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // Back Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EnterNamePage()),
                            );
                            final player = AudioCache();
                            player.play('comedy_pop_finger_in_mouth_001.mp3');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            '<--- Back',
                            style: TextStyle(
                              fontSize: 20, 
                              fontFamily: 'FredokaOne',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}