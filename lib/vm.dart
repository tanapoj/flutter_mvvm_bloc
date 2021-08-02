import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_live_data/flutter_live_data.dart';
import 'commons/life_cycle_listener.dart';

/// ViewModel
abstract class ViewModel extends ChangeNotifier with LifeCycleListener {
  String get name => '{{sys.ui.ViewModel}}';

  BuildContext context;
  bool _disposed = false;
  bool initReady = false;

  bool get isDisposed => _disposed;

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    this._disposed = true;
    this.onDispose();
    super.dispose();
  }
}
