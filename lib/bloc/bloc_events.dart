import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvents {
  const AppEvents();
}

@immutable
class LoadNextUrlEvent implements AppEvents {
  const LoadNextUrlEvent();
}
