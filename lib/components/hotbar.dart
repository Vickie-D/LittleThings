import 'package:flutter/material.dart';
import 'package:little_things_game/littleThings.dart';


class Hotbar extends StatelessWidget {
  final littleThings game;
  
  Hotbar({
    super.key,
    required this.game,
  });


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(10, (index) {
            final isSelected = game.selectedIndex == index;
            return GestureDetector(
              onTap: () {
                game.selectSlot(index);
              },
              child: Container(
                width: 55,
                height: 55,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(246, 226, 179, 1),
                  border: isSelected ? Border.all(width: 5.0, color: Color.fromRGBO(242, 183, 41, 1)) : Border.all(width: 4.5, color: Color.fromRGBO(174, 103, 6, .9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 5.0),
                  child: Stack(
                    children: [
                      if (game.hotbarItems[index] != "")
                        Center(
                          child: Image.asset(
                            "assets/images/items/${game.hotbarItems[index]}/${game.hotbarItems[index]}.png",
                            width: 30,
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                        ),
                      Positioned(
                        top: 2,
                        left: 4,
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            color: Color.fromRGBO(197, 139, 25, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }



}