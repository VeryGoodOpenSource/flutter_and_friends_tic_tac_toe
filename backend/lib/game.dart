import 'dart:async';

import 'package:backend/redis.dart';

/// A game server that manages a specific game and its state.
/// TODO(workshopper): We will change the stream type.
class Game extends StreamView<int> {
  Game._(
    int id, 
    List<int?> fields, {
    int player = 0,
  }) : this.__(
          id,
          fields,
          player,
          StreamController<int>.broadcast(sync: true),
        );

  Game.__(
    this.id,
    this.fields,
    this.player,
    this._controller,
  ) : super(_controller.stream);

  /// The player id of the current player.
  ///  0 = no player
  ///  1 = player 1
  ///  2 = player 2
  final int player;


  /// Null = no player moved.
  /// 1 = player 1 moved.
  /// 2 = player 2 moved.
  final List<int?> fields;

  /// A unique identifier for the game.
  /// This is currently just a incrementing number from Redis.
  /// It's not unguessable, but it's not a secret either.
  final int id;

  // Internal StreamController used to broadcast game status updates.
  final StreamController<int> _controller;

  /// Start new game and return the game id.
  /// Joining the game is done by calling [joinGame] separately.
  static Future<int> newGame() async {
    final id = await getRedisGameId();
    // TODO(workshopper): Make our initial game state and store it in Redis.
    return id;
  }

  /// Join a game by game id.
  /// This will return a [Game] instance that represents the game.
  /// If the game doesn't exist, this will return null.
  static Future<Game?> joinGame(int id) async {
    final gameStateJson = await getRedisValue('game:state:$id');
    if (gameStateJson == null) return null;

    // TODO(workshopper): Implement determine player number.
    int player = 1;

    // TODO(workshopper): Parse the game state from Redis and return a Game
    // instance.
    // TODO(workshopper): Subscribe to Redis for updates.
    return Game._(id, player: player);
  }

  /// Validate and make move.
  /// Triggers a game won status if the result is a player has got 3 in a row.
  Future<void> move(int index) async {
    // TODO(workshopper):
    //     - Implement move validation and update game state in Redis.
    //     - Trigger a game won status if the result is that a player has won.
  }

  bool _hasThreeInARow(int player) {
    if (fields[0] == player && fields[1] == player && fields[2] == player ||
        fields[3] == player && fields[4] == player && fields[5] == player ||
        fields[6] == player && fields[7] == player && fields[8] == player ||
        fields[0] == player && fields[3] == player && fields[6] == player ||
        fields[1] == player && fields[4] == player && fields[7] == player ||
        fields[2] == player && fields[5] == player && fields[8] == player ||
        fields[0] == player && fields[4] == player && fields[8] == player ||
        fields[2] == player && fields[4] == player && fields[6] == player) {
      return true;
    }
    return false;
  }
}
