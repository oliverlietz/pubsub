import 'dart:async';
import 'dart:math';
import 'package:pubsub/pubsub.dart';
import 'package:test/test.dart';
import 'samples.dart';

void main() {

  group("register", () {

    test("register object with message handlers for type MessageA", () {
      final StreamPerSymbolMessageBus messageBus = new StreamPerSymbolMessageBus();
      final Object subscriber = new SubscriberA();
      messageBus.register(subscriber);
      expect(messageBus.broadcastStreams.length, 1);
    });

  });

  group("publish", () {

    test("random publishing with two subscribers", () {
      final MessageBus messageBus = new StreamPerSymbolMessageBus();
      final SubscriberA subscriber1 = new SubscriberA();
      messageBus.register(subscriber1);
      final SubscriberA subscriber2 = new SubscriberA();
      messageBus.register(subscriber2);
      PublisherA publisher = new PublisherA(messageBus);
      Random random = new Random();
      final int number = random.nextInt(10000);
      for (int i = 0; i < number; i++) {
        publisher.publishMessageA();
      }
      void checkSubscriber1() => expect(subscriber1.countMessageA(), number * 4);
      void checkSubscriber2() => expect(subscriber2.countMessageA(), number * 4);
      new Timer(new Duration(milliseconds: 100), expectAsync(checkSubscriber1));
      new Timer(new Duration(milliseconds: 100), expectAsync(checkSubscriber2));
    });

  });

}
