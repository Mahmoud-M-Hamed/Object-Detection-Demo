import 'dart:async';

class Mutex {
  Completer<void>? _completer;

  Future<void> acquire() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
  }

  void release() {
    _completer?.complete();
    _completer = null;
  }
}