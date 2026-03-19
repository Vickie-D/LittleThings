import 'package:little_things_game/components/collision_block.dart';
import 'package:little_things_game/components/player.dart';

// multiplied everything by 1.5 due to the character image scaling

bool checkCollision(Player player, CollisionBlock block) {
  final hitbox = player.hitbox;

  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;


  return (
    playerY < blockY + blockHeight && 
    playerY + playerHeight > blockY && 
    playerX < blockX + blockWidth && 
    playerX + playerWidth > blockX
  );
}