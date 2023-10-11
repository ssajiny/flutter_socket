import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter_socket/aceSkies/bullet.dart';
import 'package:flutter_socket/aceSkies/player.dart';
import 'package:flutter_socket/utils/joystick_player.dart';

class AceSkies extends FlameGame with PanDetector, HasCollisionDetection {
  late final JoystickPlayer player;
  late final JoystickComponent joystick;

  AceSkies({
    required this.onGameOver,
    required this.onGameStateUpdate,
  });

  static const _initialHealthPoints = 100;

  final void Function(bool didWin) onGameOver;

  final void Function(Vector2 position, int health) onGameStateUpdate;

  // `Player` instance of the player
  late Player _player;

  // `Player` instance of the opponent
  late Player _opponent;

  bool isGameOver = true;

  int _playerHealthPoint = _initialHealthPoints;

  @override
  Future<void> onLoad() async {
    final playerImage = await images.load('player.png');
    _player = Player(isMe: true);
    final spriteSize = Vector2.all(Player.radius * 2);
    _player.add(SpriteComponent(sprite: Sprite(playerImage), size: spriteSize));
    add(_player);

    final opponentImage = await images.load('opponent.png');
    _opponent = Player(isMe: false);
    _opponent.add(SpriteComponent.fromImage(opponentImage, size: spriteSize));
    add(_opponent);

    await super.onLoad();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _player.move(info.delta.global);
    final mirroredPosition = _player.getPlayerPosition();
    onGameStateUpdate(mirroredPosition, _playerHealthPoint);
    super.onPanUpdate(info);
  }

  void startNewGame() {
    isGameOver = false;
    _playerHealthPoint = _initialHealthPoints;

    for (final child in children) {
      if (child is Player) {
        child.position = child.initialPosition;
      } else if (child is Bullet) {
        child.removeFromParent();
      }
    }

    _shootBullets();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) {
      return;
    }
    for (final child in children) {
      if (child is Bullet && child.hasBeenHit && !child.isMine) {
        _playerHealthPoint = _playerHealthPoint - child.damage;
        final mirroredPosition = _player.getPlayerPosition();
        onGameStateUpdate(mirroredPosition, _playerHealthPoint);
        _player.updateHealth(_playerHealthPoint / _initialHealthPoints);
      }
    }
    if (_playerHealthPoint <= 0) {
      endGame(false);
    }
  }

  Future<void> _shootBullets() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Player's bullet
    final playerBulletInitialPosition = Vector2.copy(_player.position)
      ..y -= Player.radius;
    final playerBulletVelocities = [
      Vector2(0, -100),
      Vector2(60, -80),
      Vector2(-60, -80),
    ];
    for (final bulletVelocity in playerBulletVelocities) {
      add((Bullet(
        isMine: true,
        velocity: bulletVelocity,
        initialPosition: playerBulletInitialPosition,
      )));
    }

    // Opponent's bullet
    final opponentBulletInitialPosition = Vector2.copy(_opponent.position)
      ..y += Player.radius;
    final opponentBulletVelocities = [
      Vector2(0, 100),
      Vector2(60, 80),
      Vector2(-60, 80),
    ];
    for (final bulletVelocity in opponentBulletVelocities) {
      add((Bullet(
        isMine: false,
        velocity: bulletVelocity,
        initialPosition: opponentBulletInitialPosition,
      )));
    }

    _shootBullets();
  }

  void updateOpponent({required Vector2 position, required int health}) {
    _opponent.position = Vector2(size.x * position.x, size.y * position.y);
    _opponent.updateHealth(health / _initialHealthPoints);
  }

  // Called when either the player or the opponent has run out of health points
  void endGame(bool playerWon) {
    isGameOver = true;
    onGameOver(playerWon);
  }
}
