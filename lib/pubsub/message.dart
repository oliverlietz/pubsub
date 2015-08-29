import 'package:uuid/uuid.dart';

abstract class Message {

  final Object source;

  final int timestamp = new DateTime.now().millisecondsSinceEpoch;

  final String uuid = new Uuid().v4();

  Message(this.source);

}
