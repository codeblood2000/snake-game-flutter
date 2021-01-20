import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];
  var direction = 'down';
  static var randomNumber = Random();

  var food = randomNumber.nextInt(700);

  void generateNewFood() {
    food = randomNumber.nextInt(700);
  }

  void startGame() {
    snakePosition = [45, 65, 85, 105, 125];
    const duration = const Duration(milliseconds: 300);
    Timer.periodic(duration, (Timer timer) {
      if (gameOver()) {
        timer.cancel();
        _showGameOverDilog();
      } else {
        updateSnake();
      }
    });
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > 740) {
            snakePosition.add(snakePosition.last - 740);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;

        case 'up':
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last + 740);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;

        case 'left':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;

        case 'right':
          if (snakePosition.last + 1 % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;
      }

      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count++;
        }
        if (count >= 2) {
          return true;
        }
      }
    }
    return false;
  }

  _showGameOverDilog() {
    showDialog(
        context: (context),
        builder: (ctx) {
          return AlertDialog(
            title: Text('GAME OVER!!'),
            content:
                Text('Your score ${(snakePosition.length - 5).toString()}'),
            actions: [
              FlatButton(
                  onPressed: () {
                    startGame();
                    Navigator.of(context).pop();
                  },
                  child: Text('Play Again'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                } else if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                }
              },
              // onVerticalDragUpdate: (details) {
              //   print('vertical $details');
              // },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: Container(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 720,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 20),
                    itemBuilder: (context, index) {
                      if (snakePosition.contains(index)) {
                        return Container(
                          padding: EdgeInsets.all(3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else if (index == food) {
                        return Container(
                          padding: EdgeInsets.all(3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.green,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: EdgeInsets.all(3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.grey[900],
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 30.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: startGame,
                  child: Text(
                    's t a r t',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
