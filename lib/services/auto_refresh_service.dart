import 'dart:async';

class AutoRefreshService {
  static Timer? _timer;

  static void start(void Function() onRefresh) {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(minutes: 10),
      (timer) => onRefresh(),
    );
  }

  static void stop() {
    _timer?.cancel();
  }
}