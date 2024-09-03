import 'dart:async';
import 'dart:io';

import 'package:redis/redis.dart';

// TODO(workshopper): replace these with credentials from:
// https://gist.github.com/Salakar/eee8594682c0672f4d3d7ba57268655a
final _redisHost = Platform.environment['REDIS_HOST'];
final _redisPort = Platform.environment['REDIS_PORT'] ?? '6379';
final _redisPassword = Platform.environment['REDIS_PASSWORD'];

/// Connect to the Redis server and return a [Command] instance.
/// This is used to send commands to the Redis server.
/// This is not a singleton, we need multiple connections to the Redis server
/// for different purposes, e.g. one for running commands, one for pub/sub.
Future<Command> getRedisClient() async {
  // Get an instance of the Command class, we use this to send commands to
  // the Redis server. Using [connectSecure] here is the easiest way to
  // connect to the Redis server, as it will automatically use TLS.
  final commander =
      await RedisConnection().connectSecure(_redisHost, int.parse(_redisPort));
  // Our Redis server is secured with a password, so we need to pass it
  // to authenticate once connected.
  await commander.send_object(['AUTH', _redisPassword]);
  return commander;
}

Command? _cachedClient;
Timer? _disconnectTimer;

/// A cached redis client that disconnects after 3 minutes of inactivity.
/// This is used to prevent the redis server from being spammed with
/// many open connections, especially bad in a serverless environment.
Future<Command> getCachedRedisClient() async {
  _cachedClient ??= await getRedisClient();
  _disconnectTimer?.cancel();
  _disconnectTimer = Timer(const Duration(minutes: 3), () async {
    _cachedClient = null;
    _disconnectTimer = null;
    await _cachedClient?.get_connection().close();
  });
  return _cachedClient!;
}

/// Connect to the Redis server and return a [PubSub] instance.
/// This is used to subscribe to channels and listen for messages.
Future<PubSub> getRedisPubSub() async {
  // Note that a Redis connection that is initialized for pub/sub is
  // unable to send commands, so we need to use a new redis connection
  // for that.
  final pubsub = PubSub(await getRedisClient());
  return pubsub;
}

/// Get a value from Redis.
Future<dynamic> getRedisValue(String key) async {
  final client = await getCachedRedisClient();
  final result = await client.get(key);
  return result;
}

/// Get a unique game id from Redis.
Future<int> getRedisGameId() async {
  final client = await getCachedRedisClient();
  final result = await client.send_object(['INCR', 'game:id']);
  return result as int;
}

/// Set a value in Redis.
Future<void> setRedisValue(String key, String value) async {
  final client = await getCachedRedisClient();
  final result = await client.set(key, value);
  return result;
}

/// Publish a message to a pub/sub channel.
Future<void> publishRedisMessage(String pubSubChannel, String message) async {
  final client = await getCachedRedisClient();
  final result = await client.send_object(['PUBLISH', pubSubChannel, message]);
  return result;
}

/// Subscribe to a pub/sub channel and return a stream of messages.
Future<Stream<String>> getRedisStream(String pubSubChannel) async {
  final client = await getRedisClient();
  final pubsub = PubSub(client)..subscribe([pubSubChannel]);
  final redisStream = pubsub.getStream();
  final streamController = StreamController<String>(
    sync: true,
    onCancel: () async {
      pubsub.unsubscribe([pubSubChannel]);
      await client.get_connection().close();
    },
  );
  redisStream.listen((message) {
    // Format is ['message' | subscribe, channelName, message]
    if ((message as List)[0] != 'message') return;
    streamController.add(message[2] as String);
  });
  return streamController.stream;
}
