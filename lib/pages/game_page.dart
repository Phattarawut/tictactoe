// ignore_for_file: must_be_immutable

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
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] != '' || _gameOver) {
      return;
    }
    setState(() {
      _board[row][col] = _currentPlayer;
      // check for winner
      if (_board[row][0] == _currentPlayer &&
          _board[row][1] == _currentPlayer &&
          _board[row][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][col] == _currentPlayer &&
          _board[1][col] == _currentPlayer &&
          _board[2][col] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][0] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][2] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][0] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      }
      // switch player
      _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';

      // check for a tie
      if (!_board.any((row) => row.any((cell) => cell == ''))) {
        _gameOver = true;
        _winner = "It's a Tie";
      }
      if (_winner != '') {
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
        } else if (_winner == 'O') {
          scoreP2++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  height: 120,
                  child: Column(
                    children: [
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
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            'Score : $scoreP1',
                            textAlign: TextAlign.center,
                            style: miniFontStyle,
                          )),
                          Expanded(
                              child: Text(
                            'Score : $scoreP2',
                            textAlign: TextAlign.center,
                            style: miniFontStyle,
                          )),
                        ],
                      ),
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 400,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(5),
                  child: GridView.builder(
                    itemCount: 9,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ 3;
                      int col = index % 3;
                      return GestureDetector(
                        onTap: () => _makeMove(row, col),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              _board[row][col],
                              style: TextStyle(
                                fontSize: 100,
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
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: _resetGame,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 20),
                        child: Text(
                          'Reset Game',
                          style: miniFontStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EnterNamePage()),
                          );
                        },
                        child: const Text(
                          '<--- Back',
                          style:
                              TextStyle(fontSize: 20, fontFamily: 'FredokaOne'),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
