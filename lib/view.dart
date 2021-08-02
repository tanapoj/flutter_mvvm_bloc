import 'package:bloc_builder/commons/bloc_livedata.dart' as bloc;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_live_data/flutter_live_data.dart';
import 'controller.dart';
import 'vm.dart';

/// View
abstract class View<VM extends ViewModel> extends StatelessWidget {
  View(VM viewModel) : this._viewModel = viewModel;

  final VM _viewModel;

  VM get $vm => _viewModel;

  final _ChildrenController children = _ChildrenController();

  void onInit() {}

  void onPlug<VM extends ViewModel>(HierarchyMVVMWidget<VM> hierarchyMVVMWidget, [Symbol name]) {}

  Widget plug<T extends ViewModel>(Widget controller, [Symbol name]) {
    name ??= Symbol('$T');
    if (controller is HierarchyMVVMWidget) {
      children.set(name, controller as HierarchyMVVMWidget);
      Future.delayed(Duration(seconds: 0), () {
        onPlug(controller as HierarchyMVVMWidget, name);
      });
    } else {
      throw TypeError();
    }
    return controller;
  }

  Widget $<T>(
    LiveData<T> $vm, {
    Symbol id,
    @required Widget Function(BuildContext context, T value) builder,
  }) {
    return bloc.$watch($vm, id: id, builder: builder);
  }
}

class WidgetHolder<W extends Widget> {
  final _WidgetHolder<W> widgetHolder = _WidgetHolder();

  W get widget => widgetHolder.widget;

  BuildContext get context => widgetHolder.context;
}

class _WidgetHolder<W extends Widget> {
  W widget;
  BuildContext context;
}

class _ChildrenController {
  final Map<Symbol, HierarchyMVVMWidget> _controllers = {};

  void set(Symbol name, HierarchyMVVMWidget controller) => _controllers[name] = controller;

  T widget<T extends HierarchyMVVMWidget>([Symbol name]) => _controllers[name ?? Symbol('$T')] as T;

  T vm<T extends ViewModel>([Symbol name]) => widget(name)?.viewModel as T;

  @override
  String toString() {
    return '_ChildrenController{_controllers: $_controllers}';
  }
}
