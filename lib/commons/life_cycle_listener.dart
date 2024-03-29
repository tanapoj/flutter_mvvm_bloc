class LifeCycleListener {
  /// - Event callback after [ViewModel] is constructed.
  /// - The event is called by default every time the [ViewModel] view dependencies are updated.
  /// - Set [initOnce] of the [MVVM] as [true] to ignore dependencies updates.
  void onInit() {}

  /// Event callback when the [build] method is called.
  void onBuild() {}

  /// Event callback when the view disposed.
  void onDispose() {}

  /// Event callback when the application is visible and responding to user input.
  void onResume() {}

  /// Event callback when the application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  void onPause() {}

  /// - Event callback when the application is in an inactive state and is not receiving user input.
  /// - For [IOS] only.
  void onInactive() {}

  /// - Event callback when the application is still hosted on a flutter engine but
  ///   is detached from any host views.
  /// - For [Android] only.
  void onDetach() {}
}
