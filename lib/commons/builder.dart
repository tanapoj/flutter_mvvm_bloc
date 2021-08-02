import 'package:flutter/widgets.dart';

class CacheBuilder<T> {
  Widget _c;
  T _state;

  Widget buildCache({
    @required T state,
    @required Widget body,
  }) {
    if (_c == null || _state != state) {
      _state = state;
      _c = body;
    }
    return _c;
  }
}

extension nestedBuilder on Widget {
  Widget into(Widget Function(Widget widget) wrapper) => wrapper(this);
}
