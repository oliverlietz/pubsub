library pubsub;

import 'dart:async';
import 'dart:mirrors';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'message.dart';
part 'stream.dart';
part 'src/utils.dart';

/**
 * An annotation used to mark a regular method with a single parameter as message handler.
 */
const subscribe = const _Subscribe();

class _Subscribe {
  const _Subscribe();
}

class MessageBus {

  void register(Object listener) {}

  void unregister(Object listener) {}

  void publish(Object message) {}

}
