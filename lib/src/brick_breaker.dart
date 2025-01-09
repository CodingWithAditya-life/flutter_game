import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_new_games/src/components/ball.dart';
import 'package:flutter_new_games/src/components/bat.dart';
import 'package:flutter_new_games/src/components/brick.dart';
import 'package:flutter_new_games/src/components/play_area.dart';
import 'package:flutter_new_games/src/config.dart';

class BrickBreaker extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  BrickBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
              width: gameWidth, height: gameHeight),
        );

  int remainingBricks = 0;

  final rand = math.Random();

  double get width => size.x;

  double get height => size.y;

  @override
  FutureOr<void> load() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(PlayArea());
    world.add(
      Ball(
          velocity:
              Vector2((rand.nextDouble() - 0.5) * width, height).normalized()
                ..scale(height / 5),
          position: size / 2,
          radius: ballRadius,
          difficultyModifier: difficultyModifier),
    );

    world.add(
      Bat(
        cornerRadius: Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.95),
        size: Vector2(batWidth, batHeight),
      ),
    );

    remainingBricks = 0;
    await world.addAll(
      [
        for (var i = 0; i < brickColors.length; i++)
          for (var j = 0; j <= 5; j++)
            Brick(
              position: Vector2(
                  ((i + 0.5) * brickWidth + (i + 1) * brickGutter),
                  (j + 2.0) * brickHeight + j * brickGutter),
              color: brickColors[i],
            )
      ],
    );

    debugMode = false;
  }

  // void checkGameOver() {
  //   if (remainingBricks <= 0) {
  //     showGameOver();
  //   }
  // }
  //
  // void showGameOver() {
  //   add(
  //     TextComponent(
  //       text: 'Game Over',
  //       textRenderer: TextPaint(
  //         style: const TextStyle(
  //           fontSize: 48,
  //           color: Color(0xFFFFFFFF),
  //         ),
  //       ),
  //       position: Vector2(gameWidth / 2, gameHeight / 2),
  //       anchor: Anchor.center,
  //     ),
  //   );
  //
  //   pauseEngine();
  // }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children
            .query<Bat>()
            .first
            .moveBy(-batStep);
      case LogicalKeyboardKey.arrowRight:
        world.children
            .query<Bat>()
            .first
            .moveBy(batStep);
    }
    return KeyEventResult.handled;
  }
}
