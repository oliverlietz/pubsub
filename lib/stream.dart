part of pubsub;

/**
 * creates one (broadcasting) Stream per Symbol
 */
class StreamPerSymbolMessageBus implements MessageBus {

  /**
   * StreamControllers by Symbol to get EventSink for Symbol
   * @see #publish
   */
  final Map<Symbol, StreamController> _streamControllers = new Map<Symbol, StreamController>();

  /**
   * (broadcasting) Streams by Symbol
   * @see #register
   */
  final Map<Symbol, Stream> _broadcastStreams = new Map<Symbol, Stream>();

  // TODO remove (only exists to access broadcastStreams in unit tests)
  Map<Symbol, Stream> get broadcastStreams => _broadcastStreams;

  /**
   * StreamSubscriptions by Object (subscriber) to allow canceling StreamSubscription
   * @see #unregister
   */
  final Map<Object, List<StreamSubscription>> _streamSubscriptions = new Map<Object, List<StreamSubscription>>();

  /**
   * returns a (broadcast) Stream for the given Symbol
   * creates Streamcontroller and (broadcast) Stream on demand
   */
  Stream broadcastStream(Symbol symbol) {
    _streamControllers.putIfAbsent(symbol, () => new StreamController());
    _broadcastStreams.putIfAbsent(symbol, () => _streamControllers[symbol].stream.asBroadcastStream());
    return _broadcastStreams[symbol];
  }

  /**
   * returns an EventSink for the given Symbol
   * creates Streamcontroller and (broadcast) Stream on demand
   */
  EventSink sink(Symbol symbol) {
    _streamControllers.putIfAbsent(symbol, () => new StreamController());
    _broadcastStreams.putIfAbsent(symbol, () => _streamControllers[symbol].stream.asBroadcastStream());
    return _streamControllers[symbol].sink;
  }

  /**
   * registers an Object (subscriber), does nothing if Object is already registered
   */
  @override
  void register(Object subscriber) {
    if (!_streamSubscriptions.containsKey(subscriber)) {
      final InstanceMirror im = reflect(subscriber);
      final List<MethodMirror> methods = findMessageHandlersOnInstanceMirror(im);
      methods.forEach((MethodMirror method) {
        final Symbol symbol = method.parameters.first.type.qualifiedName;
        final StreamSubscription streamSubscription = broadcastStream(symbol).listen((event) {
          im.invoke(method.simpleName, [event]);
        });
        _streamSubscriptions.putIfAbsent(subscriber, () => new List<StreamSubscription>());
        _streamSubscriptions[subscriber].add(streamSubscription);
      });
    }
  }

  /**
   * cancels all StreamSubscriptions for given Object
   */
  @override
  void unregister(Object subscriber) {
    if (_streamSubscriptions.containsKey(subscriber)) {
      final List<StreamSubscription> list = _streamSubscriptions[subscriber];
      list.forEach((streamSubscription) => streamSubscription.cancel());
      _streamSubscriptions.remove(subscriber);
    }
  }

  /**
   * publishs an Object (message)
   */
  @override
  void publish(Object message) {
    final Symbol symbol = reflect(message).type.qualifiedName;
    sink(symbol).add(message);
  }

}
