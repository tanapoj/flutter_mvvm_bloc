import 'package:flutter/widgets.dart';

/// Base Widget Class
abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({Key key}) : super(key: key);
}

/// Foo View
class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(); //SizedBox.shrink();
}
