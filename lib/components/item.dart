import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:little_things_game/littleThings.dart';
import 'package:little_things_game/components/player.dart';

class Item extends SpriteAnimationComponent with HasGameReference<littleThings>, CollisionCallbacks {
  
  final String itemName;
  final double stepTime = 0.05;
  final String iconPath;
  // bool collected = false;
  bool collected;

  Item({
    required this.itemName,
    required Vector2 position,
    required this.iconPath,
    required this.collected,
  }) : super(
          position: position,
        );

  @override
  Future<void> onLoad() async {
    
    add(RectangleHitbox(
      position: Vector2(0, 0),
      size: Vector2(20, 20),
      collisionType: CollisionType.passive,
    ),);

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache("$iconPath/$itemName.png"),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.05,
        textureSize: Vector2(20, 20),
      )
    );
    
    return super.onLoad();
  }



  void collect() {
    collected = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('items/$itemName/disappear.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: stepTime,
        textureSize: Vector2(20, 20),
        loop: false,
    ));
    Future.delayed(Duration(milliseconds: 600), () {
      removeFromParent();
    });  
  }
}