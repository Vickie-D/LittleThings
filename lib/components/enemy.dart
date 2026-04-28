import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:little_things_game/littleThings.dart';

enum EnemyState {
  warriorIdle("idle", 8),
  warriorAttack("attack", 4),
  slimeIdle("idle", 8),
  slimeAttack("attack", 10);

  final String assetName;
  final int frameCount;

  const EnemyState(this.assetName, this.frameCount);
}

class Enemy extends SpriteAnimationComponent
    with HasGameReference<littleThings>, CollisionCallbacks {

  final String name;

  Enemy({
    this.name = "",
    super.position,
    super.size,
  }) : super(anchor: Anchor.center);

  late final SpriteAnimation warriorIdleAnimation;
  late final SpriteAnimation warriorAttackAnimation;
  late final SpriteAnimation slimeIdleAnimation;
  late final SpriteAnimation slimeAttackAnimation;


  bool _isAttacking = false;
  double _attackCooldown = 0;
  final double attackRange = 30; 
  final double attackDelay = 1.0; 


  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimations();

    add(
      RectangleHitbox(
        position: Vector2.zero(),
        size: size,
        collisionType: CollisionType.passive,
      ),
    );

    animation = warriorIdleAnimation;

    return super.onLoad();
  }


  @override
  void update(double dt) {
    _attackCooldown -= dt;

    final distance = position.distanceTo(game.player.position);

    if (distance <= attackRange && _attackCooldown <= 0) {
      _attack();
      if (distance < 20) {
        game.player.takeDamage(20);
    }
    } else if (!_isAttacking) {
      _idle();
    }

    super.update(dt);
  }


  void _attack() {
    _isAttacking = true;
    _attackCooldown = attackDelay;

    if (name == "Slime") {
      animation = slimeAttackAnimation;
    } else {
      animation = warriorAttackAnimation;
    }

    Future.delayed(const Duration(milliseconds: 400), () {
      _isAttacking = false;
    });
  }

  void _idle() {
    if (_isAttacking) return;

    if (name == "Slime") {
      animation = slimeIdleAnimation;
    } else {
      animation = warriorIdleAnimation;
    }
  }
  // @override
  // void update(double dt) {
  //   _updateWarriorState(dt);
  //   _updateSlimeState(dt);
  //   super.update(dt);
  // }

  // void _updateWarriorState(double dt) {
  // }

  // void _updateSlimeState(double dt) {
  // }


  void _loadAllAnimations() {
    warriorIdleAnimation = _spriteAnimation(EnemyState.warriorIdle);
    warriorAttackAnimation = _spriteAnimation(EnemyState.warriorAttack);
    slimeIdleAnimation = _spriteAnimation(EnemyState.slimeIdle);
    slimeAttackAnimation = _spriteAnimation(EnemyState.slimeAttack);
  }

  SpriteAnimation _spriteAnimation(EnemyState state) {
    final path = "enemy/$name/${state.assetName}.png";

    return SpriteAnimation.fromFrameData(
      game.images.fromCache(path),
      SpriteAnimationData.sequenced(
        amount: state.frameCount,
        stepTime: 0.08,
        textureSize: _getTextureSize(),
      ),
    );
  }

  Vector2 _getTextureSize() {
    if (name == "Slime") {
      return Vector2(32, 32);
    }
    return Vector2(192, 192); 
  }
}