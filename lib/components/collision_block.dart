import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent{
  bool isSpawnCollision;
  CollisionBlock({
    super.position, 
    super.size,
    this.isSpawnCollision = false,  // added this
  });
}