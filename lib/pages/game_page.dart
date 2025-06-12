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

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  int scoreP1 = 0;
  int scoreP2 = 0;
  
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  
  var headerStyle = const TextStyle(
    decoration: TextDecoration.none,
    fontSize: 28,
    color: Colors.white,
    fontFamily: 'FredokaOne',
    fontWeight: FontWeight.bold,
  );
  
  var scoreStyle = const TextStyle(
    decoration: TextDecoration.none,
    fontSize: 22,
    color: Colors.white70,
    fontFamily: 'FredokaOne',
  );
  
  var turnStyle = const TextStyle(
    decoration: TextDecoration.none,
    fontSize: 24,
    color: Colors.yellowAccent,
    fontFamily: 'FredokaOne',
    fontWeight: FontWeight.bold,
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
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
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

    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Header Section with Player Info
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00D4FF),
                          Color(0xFF091E3A),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Player Names
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: _currentPlayer == 'X' 
                                    ? Colors.red.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: _currentPlayer == 'X'
                                    ? Border.all(color: Colors.red, width: 2)
                                    : Border.all(color: Colors.white24),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      widget.nameP1,
                                      textAlign: TextAlign.center,
                                      style: headerStyle.copyWith(
                                        color: _currentPlayer == 'X' ? Colors.red : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Score: $scoreP1',
                                      textAlign: TextAlign.center,
                                      style: scoreStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.yellowAccent,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.yellowAccent.withOpacity(0.5),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'VS',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily: 'FredokaOne',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: _currentPlayer == 'O' 
                                    ? Colors.blue.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: _currentPlayer == 'O'
                                    ? Border.all(color: Colors.blue, width: 2)
                                    : Border.all(color: Colors.white24),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      widget.nameP2,
                                      textAlign: TextAlign.center,
                                      style: headerStyle.copyWith(
                                        color: _currentPlayer == 'O' ? Colors.blue : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Score: $scoreP2',
                                      textAlign: TextAlign.center,
                                      style: scoreStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Current Turn
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellowAccent.withOpacity(0.2),
                                Colors.orange.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.yellowAccent, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.yellowAccent,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Turn: ',
                                style: turnStyle.copyWith(fontSize: 20),
                              ),
                              Text(
                                _currentPlayer == 'X'
                                    ? "${widget.nameP1} ($_currentPlayer)"
                                    : "${widget.nameP2} ($_currentPlayer)",
                                style: turnStyle.copyWith(
                                  fontSize: 20,
                                  color: _currentPlayer == 'X' ? Colors.red : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Game Board
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          height: 350,
                          width: 350,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2D4A75),
                                Color(0xFF1A1A2E),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: GridView.builder(
                            itemCount: 9,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (context, index) {
                              int row = index ~/ 3;
                              int col = index % 3;
                              bool isEmpty = _board[row][col] == '';
                              
                              return GestureDetector(
                                onTap: () => _makeMove(row, col),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    gradient: isEmpty 
                                      ? LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.9),
                                            Colors.grey.withOpacity(0.3),
                                          ],
                                        )
                                      : LinearGradient(
                                          colors: [
                                            _board[row][col] == 'X' 
                                              ? Colors.red.withOpacity(0.8)
                                              : Colors.blue.withOpacity(0.8),
                                            Colors.white.withOpacity(0.9),
                                          ],
                                        ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isEmpty 
                                          ? Colors.white.withOpacity(0.3)
                                          : (_board[row][col] == 'X' 
                                              ? Colors.red.withOpacity(0.4)
                                              : Colors.blue.withOpacity(0.4)),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 300),
                                      style: TextStyle(
                                        fontSize: isEmpty ? 0 : 80,
                                        fontFamily: 'FredokaOne',
                                        fontWeight: FontWeight.bold,
                                        color: _board[row][col] == 'X'
                                            ? Colors.white
                                            : Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: _board[row][col] == 'X' 
                                              ? Colors.red.withOpacity(0.8)
                                              : Colors.blue.withOpacity(0.8),
                                            blurRadius: 10,
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(_board[row][col]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Action Buttons
                  Row(
                    children: [
                      // Back Button
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EnterNamePage()),
                              );
                              final player = AudioCache();
                              player.play('comedy_pop_finger_in_mouth_001.mp3');
                            },
                            icon: const Icon(Icons.arrow_back_rounded, size: 24),
                            label: const Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 18, 
                                fontFamily: 'FredokaOne',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.grey[700],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                            ),
                          ),
                        ),
                      ),
                      
                      // Reset Button
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton.icon(
                            onPressed: _resetGame,
                            icon: const Icon(Icons.refresh_rounded, size: 24),
                            label: const Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 18, 
                                fontFamily: 'FredokaOne',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.deepOrange,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                              shadowColor: Colors.deepOrange.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}