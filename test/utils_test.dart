import 'dart:mirrors';
import 'package:pubsub/pubsub.dart';
import 'package:test/test.dart';
import 'samples.dart';

void main() {

  group("findMessageHandlers", () {

    test("find message handlers for class 'Object'", () {
      final Object object = new Object();
      final List<MethodMirror> methodMirrors = findMessageHandlers(object);
      expect(methodMirrors.length, 0);
    });

    test("find message handlers for sample class 'SubscriberA'", () {
      final Object object = new SubscriberA();
      final List<MethodMirror> methodMirrors = findMessageHandlers(object);
      expect(methodMirrors.length, 4);
    });

  });

}
