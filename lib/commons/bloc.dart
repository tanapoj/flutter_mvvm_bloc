import 'package:flutter/material.dart';
import 'package:flutter_live_data/flutter_live_data.dart';

import '../mvvm_bloc.dart' as core;

/// BLoC Builder watch
Widget $watch<T>(
  LiveData<T> liveData, {
  Symbol id,
  @required Widget Function(BuildContext context, T value) builder,
}) {
  assert(
    liveData != null,
    '\$watch on null, If you create View and run it before create ViewModel, maybe hot-reload fail to bind LiveData from ViewModel --> try run app again',
  );
  return StreamBuilder(
    stream: liveData.stream$(id),
    initialData: liveData.initialValue,
    builder: (BuildContext context, snapshot) {
      var value = snapshot.data ?? liveData.value ?? liveData.initialValue;
      //assert(value is T);
      return builder(context, value);
    },
  );
}

/// BLoC Builder if
Widget $if<T extends bool>(
  LiveData<T> liveData, {
  Symbol id,
  bool Function(T) predicate,
  @required Widget Function(BuildContext context, T value) builder,
  Widget Function(BuildContext context, T value) $else,
}) {
  assert(
    liveData != null,
    '\$if on null, If you create View and run it before create ViewModel, maybe hot-reload fail to bind LiveData from ViewModel --> try run app again',
  );
  return StreamBuilder(
    stream: liveData.stream$(id),
    initialData: liveData.initialValue,
    builder: (BuildContext context, snapshot) {
      var value = snapshot.data ?? liveData.value ?? liveData.initialValue;
      assert(value is T);
      if (predicate == null && value) {
        return builder(context, value);
      }
      if (predicate != null && predicate(value)) {
        return builder(context, value);
      }
      if ($else != null) {
        return $else(context, value);
      }
      return core.EmptyView();
    },
  );
}

/// BLoC Builder switch
Widget $switch<T>(
  LiveData<T> liveData, {
  Symbol id,
  @required Map<T, Widget Function(BuildContext context, T value)> builders,
  Widget Function(BuildContext context, T value) $default,
}) {
  assert(
    liveData != null,
    '\$switch on null, If you create View and run it before create ViewModel, maybe hot-reload fail to bind LiveData from ViewModel --> try run app again',
  );
  return StreamBuilder(
    stream: liveData.stream$(id),
    initialData: liveData.initialValue,
    builder: (BuildContext context, snapshot) {
      var value = snapshot.data ?? liveData.value ?? liveData.initialValue;

      if (builders.containsKey(value)) {
        return builders[value](context, value);
      } else if ($default != null) {
        return $default(context, value);
      }
      return core.EmptyView();
    },
  );
}

/// BLoC Builder guard
Widget $guard<T>(
  LiveData<T> liveData, {
  Symbol id,
  bool Function(T) check,
  @required Widget Function(BuildContext context, T value) $else,
  @required Widget Function(BuildContext context, T value) builder,
}) {
  assert(
    liveData != null,
    '\$guard on null, If you create View and run it before create ViewModel, maybe hot-reload fail to bind LiveData from ViewModel --> try run app again',
  );

  check ??= (T t) {
    if (t != null && t is List) {
      return t.isNotEmpty;
    }
    return false;
  };

  return StreamBuilder(
    stream: liveData.stream$(id),
    initialData: liveData.initialValue,
    builder: (BuildContext context, snapshot) {
      var value = snapshot.data ?? liveData.value ?? liveData.initialValue;
      if (check(value)) {
        return builder(context, value);
      } else {
        return $else(context, value);
      }
    },
  );
}
