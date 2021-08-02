library mvvm_bloc;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_live_data/flutter_live_data.dart';
import 'controller.dart';
import 'vm.dart';

export 'controller.dart';
export 'vm.dart';
export 'view.dart';
export 'commons/builder.dart';

class MVVMBLoC<VM extends ViewModel> {
  MVVMBLoC({
    @required Widget Function(BuildContext context, VM viewModel) view,
    @required VM Function(LifeCycleObserver lifeCycleObserver) viewModel,
  })  : this.viewBuilder = view,
        this.viewModelBuilder = viewModel;

  final Widget Function(BuildContext, VM) viewBuilder;
  final VM Function(LifeCycleObserver) viewModelBuilder;

  MVVMWidget<VM, W> build<W extends Widget>([Widget widget]) => MVVMWidget<VM, W>(
        view: viewBuilder,
        viewModel: viewModelBuilder,
        widget: widget,
      );
}
