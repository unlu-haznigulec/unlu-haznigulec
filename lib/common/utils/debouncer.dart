import 'dart:async';
import 'dart:ui';

class Debouncer {
  Duration delay;
  Timer? _timer;
  VoidCallback? _callback;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void debounce(VoidCallback callback) {
    _callback = callback;

    cancel();
    _timer = Timer(delay, flush);
  }

  void cancel() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void flush() {
    if (_callback != null) {
      _callback!();
      cancel();
    }
  }
}
