library mvvm_arch;

import 'package:flutter/widgets.dart';
import 'package:flutter_live_data/flutter_live_data.dart';
import 'package:meta/meta.dart';

import 'commons/bloc.dart' as bloc;

/// Base Widget Class
abstract class _BaseStatefulWidget extends StatefulWidget {
  const _BaseStatefulWidget({Key key}) : super(key: key);

  @override
  State createState() => getView();

  View getView();
}

/// ViewController
abstract class ViewControllerWidget extends _BaseStatefulWidget {
  const ViewControllerWidget({Key key}) : super(key: key);
}

/// Fragment
abstract class FragmentWidget extends ViewControllerWidget {
  const FragmentWidget({Key key}) : super(key: key);
}

/// ViewModel
abstract class ViewModel {
  String get name => '{{sys.ui.ViewModel}}';

  void dispose() {}
}

/// Foo View
class EmptyView extends Container {}

/// View
abstract class View<Base extends _BaseStatefulWidget, VM extends ViewModel> extends State<Base>
    implements LifeCycleObserver {
  final List<LiveData> _liveData = [];

  VM $viewModel;

  String get name => '{{sys.ui.View}}';

  @override
  void dispose() {
    super.dispose();
    _liveData.forEach((liveData) {
      liveData?.dispose();
    });
    $viewModel?.dispose();
  }

  @override
  void observeLiveData<T>(LiveData<T> lv) {
    _liveData.add(lv);
  }

  @override
  Widget build(BuildContext context);

  Widget $watch<T>(
    LiveData<T> $viewModel, {
    Symbol id,
    @required Widget Function(BuildContext context, T value) builder,
  }) {
    return bloc.$watch($viewModel, id: id, builder: builder);
  }

  Widget $if<T extends bool>(
    LiveData<T> $viewModel, {
    Symbol id,
    bool Function(T) predicate,
    @required Widget Function(BuildContext context, T value) builder,
    Widget Function(BuildContext context, T value) $else,
  }) {
    return bloc.$if($viewModel, id: id, predicate: predicate, builder: builder, $else: $else);
  }

  Widget $switch<T>(
    LiveData<T> $viewModel, {
    Symbol id,
    @required Map<T, Widget Function(BuildContext context, T value)> builders,
    Widget Function(BuildContext context, T value) $default,
  }) {
    return bloc.$switch($viewModel, id: id, builders: builders, $default: $default);
  }

  Widget $guard<T>(
    LiveData<T> $viewModel, {
    Symbol id,
    bool Function(T) check,
    @required Widget Function(BuildContext context, T value) $else,
    @required Widget Function(BuildContext context, T value) builder,
  }) {
    return bloc.$guard($viewModel, id: id, check: check, $else: $else, builder: builder);
  }
}
