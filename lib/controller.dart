import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_live_data/flutter_live_data.dart';
import 'package:provider/provider.dart';
import 'commons/life_cycle_listener.dart';
import 'view.dart';
import 'vm.dart';
import 'base.dart';

/// ViewController
class MVVMWidget<VM extends ViewModel, W extends Widget> extends BaseStatefulWidget with LifeCycleListener implements LifeCycleObserver {
  MVVMWidget({
    @required Widget Function(BuildContext context, VM viewModel) view,
    @required VM Function(LifeCycleObserver lifeCycleObserver) viewModel,
    Widget widget,
    Key key,
  })  : this.viewBuilder = view,
        this.viewModelBuilder = viewModel,
        this._viewModelHolder = _ViewModelHolder(),
        this._widgetHolder = _WidgetHolder(),
        super(key: key) {
    _viewModelHolder.viewModel = viewModelBuilder(this);
    _widgetHolder.widget = widget;
  }

  final Widget Function(BuildContext, VM) viewBuilder;
  final VM Function(LifeCycleObserver) viewModelBuilder;
  final _ViewModelHolder<VM> _viewModelHolder;
  final _WidgetHolder<W> _widgetHolder;

  String get name => '{{sys.ui.View}}';

  VM get viewModel => _viewModelHolder.viewModel;

  Widget get mvvmWidget => _widgetHolder.widget;

  @override
  State<StatefulWidget> createState() => _VMState<VM, W>();

  @override
  void onDispose() {
    _liveData?.forEach((liveData) {
      liveData?.dispose();
    });
  }

  final List<LiveData> _liveData = <LiveData>[];

  @override
  void observeLiveData<T>(LiveData<T> lv) {
    _liveData.add(lv);
  }
}

/// View State
class _VMState<VM extends ViewModel, W extends Widget> extends State<MVVMWidget<VM, W>> with WidgetsBindingObserver implements LifeCycleObserver {
  ViewModel get vm => widget.viewModel;
  final List<LiveData> _liveData = const <LiveData>[];

  @override
  void observeLiveData<T>(LiveData<T> liveData) {
    _liveData.add(liveData);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      vm?.onResume();
    } else if (state == AppLifecycleState.inactive) {
      vm?.onInactive();
    } else if (state == AppLifecycleState.paused) {
      vm?.onPause();
    } else if (state == AppLifecycleState.detached) {
      vm?.onDetach();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    vm?.onDispose();
    widget.onDispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initVm();
  }

  void _initVm() {
    if (vm != null && !vm.initReady) {
      vm.onInit();
      vm.initReady = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initVm();
    vm?.context = context;

    final view = widget.viewBuilder(context, vm);
    try {
      final _w = view as WidgetHolder;
      _w.widgetHolder.context = context;
      _w.widgetHolder.widget = widget.mvvmWidget;
    } catch (e) {}
    if (view is View) {
      Future.delayed(Duration(seconds: 0), () {
        view.onInit();
      });
    }

    vm?.onBuild();

    return vm.isDisposed
        ? ChangeNotifierProvider(
            create: (context) => vm,
            child: view,
          )
        : ChangeNotifierProvider.value(
            value: vm,
            child: view,
          );
  }
}

class _WidgetHolder<W extends Widget> {
  W widget;
  BuildContext context;
}

class _ViewModelHolder<VM extends ViewModel> {
  VM viewModel;
}

abstract class HierarchyMVVMWidget<VM extends ViewModel> {
  final _ViewModelHolder<VM> controller = _ViewModelHolder();

  VM get viewModel => controller.viewModel;

  Widget build(BuildContext context) {
    var mvvm = render(context);
    controller.viewModel = mvvm.viewModel;
    return mvvm;
  }

  MVVMWidget render(BuildContext context);

  void plug(View view, [Symbol name]) {
    view.plug(this as Widget, name);
  }
}
