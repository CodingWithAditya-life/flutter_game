import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_games/src/brick_breaker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = BrickBreaker();
    return MaterialApp(
      title: 'Flutter Games',
      debugShowCheckedModeBanner: false,
      home: GameWidget(game: game),
    );
  }
}
