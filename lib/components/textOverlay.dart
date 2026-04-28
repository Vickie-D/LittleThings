import 'package:flutter/material.dart';
import 'package:little_things_game/littleThings.dart';

class TextOverlay extends StatelessWidget {
  final littleThings game;

  const TextOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * .8,
        height: 220,
        child: Container(
          margin: const EdgeInsets.only(bottom: 120),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                game.speaker,
                style: const TextStyle(
                  color: Color.fromARGB(255, 36, 17, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,  
                ),
              ),
              Text(
                game.textOverlayed,
                style: const TextStyle(
                  color: Color.fromARGB(255, 36, 17, 1),
                  fontSize: 18,
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}