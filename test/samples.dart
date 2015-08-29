import 'package:pubsub/pubsub.dart';

const dummy = const _Dummy();

class _Dummy {

  const _Dummy();

}

class MessageA extends Message {

  MessageA(Object source) : super(source);

}

class MessageB extends Message {

  MessageB(Object source) : super(source);

}

class PublisherA {

  final MessageBus messageBus;

  PublisherA(this.messageBus);

  void publishMessageA() {
    Message message = new MessageA(this);
    messageBus.publish(message);
  }

  void publishMessageB() {
    Message message = new MessageB(this);
    messageBus.publish(message);
  }

}

class SubscriberA {

  List<MessageA> messageAList = new List<MessageA>();

  int countMessageA() {
    return messageAList.length;
  }

  @subscribe // valid handler
  void onMessageA(MessageA message) {
    messageAList.add(message);
  }

  @subscribe // valid handler
  void onMessageAAlso(MessageA message) {
    messageAList.add(message);
  }

  @subscribe
  @subscribe // valid handler
  void onMessageADouble(MessageA message) {
    messageAList.add(message);
  }

  @subscribe
  @dummy // valid handler
  void onMessageADummyAlso(MessageA message) {
    messageAList.add(message);
  }

  @dummy // invalid handler
  void onMessageADummyOnly(MessageA message) {
    messageAList.add(message);
  }

}
