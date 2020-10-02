import 'package:flutter/material.dart';
import 'package:flutter_live_data/flutter_live_data.dart';
import 'package:mvvm_bloc/mvvm_bloc.dart' as ui;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomeViewController(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomeViewController extends ui.ViewControllerWidget {
  MyHomeViewController({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ui.View getView() => _MyMainView();
}

class _MyMainView extends ui.View<MyHomeViewController, _MyMainViewModel> {
  _MyMainView() {
    $viewModel = _MyMainViewModel(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            $watch($viewModel.counter, id: #counter1, builder: (BuildContext context, count) {
              return Text(
                '$count',
              );
            }),
            $watch($viewModel.counter, id: #counter2, builder: (BuildContext context, count) {
              return Text(
                '$count',
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: $viewModel.incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class _MyMainViewModel extends ui.ViewModel {
  final LiveData<int> counter;

  _MyMainViewModel(LifeCycleObserver observer)
      : counter = LiveData(initValue: 1);

  @override
  void dispose() {
    counter.dispose();
    super.dispose();
  }

  void incrementCounter() {
    counter.value++;
  }
}
