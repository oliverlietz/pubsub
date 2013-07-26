part of pubsub;

/**
 * finds methods annotated (metadata) with 'subscribe' and a single method parameter (the message object)
 */
List<MethodMirror> findMessageHandlers(Object object) {
  return findMessageHandlersOnInstanceMirror(reflect(object));
}

List<MethodMirror> findMessageHandlersOnInstanceMirror(InstanceMirror instance) {
  final ClassMirror clazz = reflect(subscribe).type;
  final List<MethodMirror> methods = new List<MethodMirror>();

  instance.type.methods.values.forEach((MethodMirror method) {
    if (method.isRegularMethod && method.parameters.length == 1) {
      for (InstanceMirror metadata in method.metadata) {
        if (metadata.type == clazz) {
          methods.add(method);
          break;
        }
      }
    }
  });

  return methods;
}
