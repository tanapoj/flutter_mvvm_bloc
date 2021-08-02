# mvvm_bloc

Flutter MVVM Architecture with BLoC Pattern

## Getting Started

### ViewModel

```dart
class CounterVM extends ViewModel {
  final LiveData<int> counter;

  CounterVM(LifeCycleObserver observer) 
    : this.counter = LiveData(1).bind(observer).asBroadcast();

  void increment() {
    counter.value++;
  }

  void decrement() {
    counter.value--;
  }
}
```

### View

```dart
class CounterView extends View<CounterVM> {
  CounterView(CounterVM viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'You have pushed the button this many times:',
        ),
        $watch($vm.counter, builder: (_, value) {
          return Text(
            '$value',
          );
        }),
        RaisedButton(
          child: Text('+'),
          onPressed: () => $vm.increment(),
        ),
        RaisedButton(
          child: Text('-'),
          onPressed: () => $vm.decrement(),
        ),
      ],
    );
  }
}
```

and build with

```dart
var widget = MVVMBLoC(
  view: (context, viewModel) => CounterView(viewModel, id: id),
  viewModel: (lifeCycle) => CounterVM(lifeCycle),
).build();
```

or bind with `HierarchyMVVMWidget`

```dart
var widget = MVVMBLoC(
  view: (context, viewModel) => CounterView(viewModel, id: id),
  viewModel: (lifeCycle) => CounterVM(lifeCycle),
).build(this);
```

## Hierarchy MVVM Widget

wrap with stateful or stateless widget

add `WidgetHolder` to view

```dart
class CounterView extends View<CounterVM> with WidgetHolder<CounterWidget> {
  //...
}
```

then create Widget extends `HierarchyMVVMWidget`, replace `build()` with `render()`. and build MVVM with `this`

```dart
class CounterWidget extends StatelessWidget with HierarchyMVVMWidget<CounterVM> {
  final int id;
  final void Function(int n) notifyCounterChange;

  CounterWidget({Key key, this.notifyCounterChange, this.id = 1}) : super(key: key);

  @override
  MVVMWidget<CounterVM, CounterWidget> render(BuildContext context) {
    return MVVMBLoC(
      view: (context, viewModel) => CounterView(viewModel, id: id),
      viewModel: (lifeCycle) => CounterVM(
        lifeCycle,
        notifyCounterChange: notifyCounterChange,
        id: id,
      ),
    ).build(this);
  }
}
```