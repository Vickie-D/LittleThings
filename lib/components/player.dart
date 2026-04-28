import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:little_things_game/littleThings.dart';
import 'package:little_things_game/components/collision_block.dart';
import 'package:little_things_game/components/custom_hitbox.dart';
import 'package:little_things_game/components/utils.dart';
import 'package:little_things_game/components/map_teleport.dart';
import 'package:little_things_game/components/item.dart';


enum PlayerState {
  walkLeft("male_WalkLeft", 6),
  walkRight("male_WalkRight", 6),
  walkDown("male_WalkDown", 6),
  walkUp("male_WalkUp", 6),
  idle("male_Idle", 1),

  walkLeft_Sword("male_WalkLeft", 6),
  walkRight_Sword("male_WalkRight", 6),
  walkDown_Sword("male_WalkDown", 6),
  walkUp_Sword("male_WalkUp", 6),
  idle_Sword("male_Idle", 1),
  ;

  final String assetName;
  final int frameCount;
  const PlayerState(this.assetName, this.frameCount);
}


class Player extends SpriteAnimationGroupComponent with HasGameReference<littleThings>, KeyboardHandler, CollisionCallbacks {
  Player({super.position});


  late final SpriteAnimation walkUpAnimation;
  late final SpriteAnimation walkDownAnimation;
  late final SpriteAnimation walkLeftAnimation;
  late final SpriteAnimation walkRightAnimation;
  late final SpriteAnimation idleAnimation;

  late final SpriteAnimation walkUp_SwordAnimation;
  late final SpriteAnimation walkDown_SwordAnimation;
  late final SpriteAnimation walkLeft_SwordAnimation;
  late final SpriteAnimation walkRight_SwordAnimation;
  late final SpriteAnimation idle_SwordAnimation;

  late final Vector2 startingPosition;
  late String itemPath = "";
  final double stepTime = 0.05;
  double moveSpeed = 150;
  double horizontalMovement = 0;
  double verticalMovement = 0;
  bool reachedCheckpoint = false;
  
  Vector2 velocity = Vector2.zero();

  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 0,
    offsetY: 0,
    width: 14,
    height: 19,
  );


  @override
  FutureOr<void> onLoad() {
    priority = 1;

    startingPosition = Vector2(position.x, position.y);

    _loadAllAnimations();
    
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY), 
      size: Vector2(hitbox.width, hitbox.height)
    ));
    
    return super.onLoad();
  }


  @override
  void update(double dt) {
    if (!reachedCheckpoint){
      _updatePlayerState();
      _updatePlayerMovement(dt);  
      _checkHorizontalCollisions();
      _checkVerticalCollisions();
    }
    super.update(dt);
  }
  

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {

// player movement
    horizontalMovement = 0;
    verticalMovement = 0;


    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) 
      || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) 
      || keysPressed.contains(LogicalKeyboardKey.arrowRight);



    if(!isLeftKeyPressed && !isRightKeyPressed){
      final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) 
        || keysPressed.contains(LogicalKeyboardKey.arrowUp);
      final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) 
        || keysPressed.contains(LogicalKeyboardKey.arrowDown);
      verticalMovement += isUpKeyPressed ? -1 : 0;
      verticalMovement += isDownKeyPressed ? 1 : 0;
    }else {

      horizontalMovement += isLeftKeyPressed ? -1 : 0;
      horizontalMovement += isRightKeyPressed ? 1 : 0;
    }


// hotbar
    if (keysPressed.contains(LogicalKeyboardKey.digit0)) {
      game.selectSlot(0);
    } else if (keysPressed.contains(LogicalKeyboardKey.digit1)) {
      game.selectSlot(1);
    } else if (keysPressed.contains(LogicalKeyboardKey.digit2)) {
      game.selectSlot(2);
    } else if (keysPressed.contains(LogicalKeyboardKey.digit3)) {
      game.selectSlot(3);
    } else if (keysPressed.contains(LogicalKeyboardKey.digit4)) {
      game.selectSlot(4);
    } else if (keysPressed.contains(LogicalKeyboardKey.digit5)) {
      game.selectSlot(5);
    } else if (keysPressed.contains(LogicalKeyboardKey.digit6)) {
      game.selectSlot(6);
    } else if (keysPressed.contains(LogicalKeyboardKey.digit7)) {
      game.selectSlot(7);
    } else if (keysPressed.contains(LogicalKeyboardKey.digit8)) {
      game.selectSlot(8);
    } else if (keysPressed.contains(LogicalKeyboardKey.digit9)) {
      game.selectSlot(9);
    }
    

    return super.onKeyEvent(event, keysPressed);
  }

  _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
    
    velocity.y = verticalMovement * moveSpeed;
    position.y += velocity.y * dt;
  }

  _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;



    if (itemPath == "Sword"){
      if(velocity.x < 0) { playerState = PlayerState.walkLeft_Sword; }
      if(velocity.x > 0) { playerState = PlayerState.walkRight_Sword; }
      if(velocity.y > 0) { playerState = PlayerState.walkDown_Sword; }
      if(velocity.y < 0) { playerState = PlayerState.walkUp_Sword; }
      if(velocity.y == 0 && velocity.x ==0) { playerState = PlayerState.idle_Sword; }
    }

    
    else {
      if(velocity.x < 0) { playerState = PlayerState.walkLeft; }
      if(velocity.x > 0) { playerState = PlayerState.walkRight; }
      if(velocity.y > 0) { playerState = PlayerState.walkDown; }
      if(velocity.y < 0) { playerState = PlayerState.walkUp; }
    }

    current = playerState;
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation(PlayerState.idle, "");
    walkUpAnimation = _spriteAnimation(PlayerState.walkUp, "");
    walkDownAnimation = _spriteAnimation(PlayerState.walkDown, "");
    walkLeftAnimation = _spriteAnimation(PlayerState.walkLeft, "");
    walkRightAnimation = _spriteAnimation(PlayerState.walkRight, "");


    idle_SwordAnimation = _spriteAnimation(PlayerState.idle_Sword, "/Sword");
    walkUp_SwordAnimation = _spriteAnimation(PlayerState.walkUp_Sword, "/Sword");
    walkDown_SwordAnimation = _spriteAnimation(PlayerState.walkDown_Sword, "/Sword");
    walkLeft_SwordAnimation = _spriteAnimation(PlayerState.walkLeft_Sword, "/Sword");
    walkRight_SwordAnimation = _spriteAnimation(PlayerState.walkRight_Sword, "/Sword");

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.walkUp: walkUpAnimation,
      PlayerState.walkDown: walkDownAnimation,
      PlayerState.walkLeft: walkLeftAnimation,
      PlayerState.walkRight: walkRightAnimation,
      
      PlayerState.idle_Sword: idle_SwordAnimation,
      PlayerState.walkUp_Sword: walkUp_SwordAnimation,
      PlayerState.walkDown_Sword: walkDown_SwordAnimation,
      PlayerState.walkLeft_Sword: walkLeft_SwordAnimation,
      PlayerState.walkRight_Sword: walkRight_SwordAnimation,
    };

    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(PlayerState state, String itemPath) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("character$itemPath/${state.assetName}.png"),
      SpriteAnimationData.sequenced(
        amount: state.frameCount,
        stepTime: 0.08,
        textureSize: Vector2(20, 20),
      )
    );
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (checkCollision(this, block)) {
        if (velocity.x > 0) {
          velocity.x = 0;
          position.x = block.x - hitbox.width - hitbox.offsetX;
          break;
        }
        if (velocity.x < 0) {
          velocity.x = 0;
          position.x = block.x + block.width - hitbox.offsetX;
          break;
        }
      }
    }
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (checkCollision(this, block)) {
        if (velocity.y > 0) {
          velocity.y = 0;
          position.y = block.y - hitbox.offsetY - hitbox.height;
          break;
        }
        if (velocity.y < 0) {
          velocity.y = 0;
          position.y = block.y + block.height - hitbox.offsetY;
          break;
        }
      }
    }
  }


  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedCheckpoint){
      if (other is mapTeleport) _reachedCheckpoint(other.name);
      if (other is Item) {
        if (!other.collected){
          game.addToHotbar(other.itemName);
          other.collect();
          print("it works here ");
        }
      };
      super.onCollision(intersectionPoints, other);
    }
  }

  void _reachedCheckpoint(String nextMap) {
    reachedCheckpoint = true;
    if(scale.x > 0) {
      position = position - Vector2(20, 20);
    } else if (scale.x < 0) {
      position = position + Vector2(20, -20);
    }

    const reachedCheckpointDuration = Duration(milliseconds: 380);
    Future.delayed(reachedCheckpointDuration, () {
      reachedCheckpoint = false;
      position = Vector2.all(-640);
      
      const waitToChangeDuration = Duration(seconds: 0);
      Future.delayed(waitToChangeDuration, (){
        game.loadMap(nextMap);
      });
    });
  }

}