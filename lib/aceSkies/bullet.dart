import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart' as flame_image;
import 'package:flutter/material.dart';

class Bullet extends PositionComponent with CollisionCallbacks, HasGameRef {
  // color of the bullet
  static final _paint = Paint()..color = Colors.white;
  // the bullet speed in pixles per second
  final double _speed = 750;
  // velocity vector for the bullet.
  late Vector2 velocity;
  // Damage that it deals when it hits the player
  final int damage = 5;
  bool hasBeenHit = false;
  final bool isMine;

  // default constructor with default values
  Bullet({
    required this.isMine,
    required this.velocity,
    required Vector2 initialPosition,
  }) : super(
            position: initialPosition,
            size: Vector2.all(4),
            anchor: Anchor.center);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    velocity = (velocity)..scaleTo(_speed);

    add(CircleHitbox()
      ..collisionType = CollisionType.passive
      ..anchor = Anchor.center);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    if (position.y < 0 || position.y > gameRef.size.y) {
      removeFromParent();
    }
  }
}
