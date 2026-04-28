import 'package:flutter/material.dart';
import 'package:little_things_game/littleThings.dart';

class HealthDisplay extends StatelessWidget {
  final littleThings game;

  const HealthDisplay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(

        child: Container(
          padding: const EdgeInsets.all(25),
          child: LinearProgressIndicator(
            value: game.player.currentHealth / game.player.maxHealth,
            backgroundColor: Colors.grey,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          )
        )
      )
    );
  }
}