import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:little_things_game/components/npc.dart';
import 'package:little_things_game/components/rock.dart';
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

  walkLeftSword("male_WalkLeft", 6),
  walkRightSword("male_WalkRight", 6),
  walkDownSword("male_WalkDown", 6),
  walkUpSword("male_WalkUp", 6),
  idleSword("male_Idle", 1),

  attack("male_Attack", 6),
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

  late final SpriteAnimation walkUpSwordAnimation;
  late final SpriteAnimation walkDownSwordAnimation;
  late final SpriteAnimation walkLeftSwordAnimation;
  late final SpriteAnimation walkRightSwordAnimation;
  late final SpriteAnimation idleSwordAnimation;

  late final SpriteAnimation attackAnimation;

  late final Vector2 startingPosition;
  final double stepTime = 0.05;
  double moveSpeed = 150;
  double horizontalMovement = 0;
  double verticalMovement = 0;

  double maxHealth = 100;
  late double currentHealth = 100;

  bool _isAttacking = false;
  double _attackCooldown = 0;
  final double attackRange = 30; 
  final double attackDelay = 1.0; 

  late String itemPath = "";
  bool reachedCheckpoint = false;
  bool action = false;
  bool npcCollision = false;
  String currentNpcCollision = "";




  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];


  CustomHitbox hitbox = CustomHitbox(
    offsetX: 4,
    offsetY: -1,
    width: 12,
    height: 21,
  );


  @override
  FutureOr<void> onLoad() {
    priority = 1;

    startingPosition = Vector2(position.x, position.y);
    currentHealth = maxHealth;

    _loadAllAnimations();
    
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY), 
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.active,
    ));
    
    return super.onLoad();
  }

  void _attack(){
    if (_attackCooldown > 0) return;

    _isAttacking = true;
    _attackCooldown = attackDelay;

    _dealDamageIfInRange();

    Future.delayed(const Duration(milliseconds: 400), () {
      _isAttacking = false;
    });
  }

  void _dealDamageIfInRange() {
    final enemies = game.children;

    for (final e in enemies) {
      if (e == this) continue;

      final distance = position.distanceTo((e as dynamic).position);

      if (distance <= attackRange) {
        try {
          (e as dynamic).takeDamage(20);
        } catch (_) {
          // ignore objects without health
        }
      }
    }
  }


  void takeDamage(double amount) {
    currentHealth = (currentHealth - amount).clamp(0, maxHealth);
    game.updateHealth();
    if (currentHealth == 0){
      game.reset();
      currentHealth = maxHealth;
    }
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
    

  // actions
    if (keysPressed.contains(LogicalKeyboardKey.keyN)) { 
      action = true;
    } else {
      action = false;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyM)) { 
      _attack();
    }


    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {

      if (game.dialogAppear){
        game.overlays.remove('TextOverlay');
        game.dialogAppear = false;
      }


      if (npcCollision && currentNpcCollision.isNotEmpty && !game.dialogAppear){
        if (game.rockObtained && game.stickObtained && !game.pickaxeObtained && currentNpcCollision == "Boy") { 
          game.npcGetMessage("Boy");
        } else {
          game.npcGetMessage(currentNpcCollision);
        }
      }
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

    if (_isAttacking) { 
      playerState = PlayerState.attack;
    }


    if (itemPath == "Sword"){
      if(velocity.x < 0) { playerState = PlayerState.walkLeftSword; }
      if(velocity.x > 0) { playerState = PlayerState.walkRightSword; }
      if(velocity.y > 0) { playerState = PlayerState.walkDownSword; }
      if(velocity.y < 0) { playerState = PlayerState.walkUpSword; }
      if(velocity.y == 0 && velocity.x ==0) { playerState = PlayerState.idleSword; }
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


    idleSwordAnimation = _spriteAnimation(PlayerState.idleSword, "/Sword");
    walkUpSwordAnimation = _spriteAnimation(PlayerState.walkUpSword, "/Sword");
    walkDownSwordAnimation = _spriteAnimation(PlayerState.walkDownSword, "/Sword");
    walkLeftSwordAnimation = _spriteAnimation(PlayerState.walkLeftSword, "/Sword");
    walkRightSwordAnimation = _spriteAnimation(PlayerState.walkRightSword, "/Sword");

    attackAnimation = _specialSpriteAnimation(PlayerState.attack);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.walkUp: walkUpAnimation,
      PlayerState.walkDown: walkDownAnimation,
      PlayerState.walkLeft: walkLeftAnimation,
      PlayerState.walkRight: walkRightAnimation,
      
      PlayerState.idleSword: idleSwordAnimation,
      PlayerState.walkUpSword: walkUpSwordAnimation,
      PlayerState.walkDownSword: walkDownSwordAnimation,
      PlayerState.walkLeftSword: walkLeftSwordAnimation,
      PlayerState.walkRightSword: walkRightSwordAnimation,

      PlayerState.attack: attackAnimation,
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

   SpriteAnimation _specialSpriteAnimation(PlayerState state) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("character$itemPath/${state.assetName}.png"),
      SpriteAnimationData.sequenced(
        amount: state.frameCount,
        stepTime: 0.08,
        textureSize: Vector2(20, 20),
        loop: false,
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
      if (other is mapTeleport) {
        if (other.name != "deep-forest-biome" || game.unlockedDeepForest) {
          _reachedCheckpoint(other.name);
        }
      }
      if (other is Item) {
        if (!other.collected){
          game.addToHotbar(other.itemName);
          other.collect();
          if (other.itemName == "Stick") { 
            game.stickObtained = true;
          }
        }
      }
      if (other is Rock && game.hotbarItems[game.selectedIndex] == "Pickaxe") { 
        velocity = Vector2(0, 0);

        if (action) { 
          other.removeFromParent();
          game.unlockedDeepForest = true;
        }
      }
      super.onCollision(intersectionPoints, other);
    }
  }


  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other is Npc) {
      npcCollision = true;
      currentNpcCollision = other.name;
    }

    super.onCollisionStart(points, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Npc) {
      npcCollision = false;
      currentNpcCollision = "";
    }

    super.onCollisionEnd(other);
  }


  void _reachedCheckpoint(String nextMap) {
    reachedCheckpoint = true;

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