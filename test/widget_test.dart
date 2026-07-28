import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monday_app/core/theme.dart';

// This filename matters: `flutter create --platforms=android .` in CI only
// fills in files that don't already exist. Without a real test/widget_test.dart
// committed here, it injects its own default template referencing a `MyApp`
// class that doesn't exist in this project (our root widget is MondayApp),
// which broke `flutter analyze`. Keeping this file present prevents that.
void main() {
  test('AppTheme.light and AppTheme.dark are valid Material 3 themes', () {
    expect(AppTheme.light.useMaterial3, isTrue);
    expect(AppTheme.dark.useMaterial3, isTrue);
    expect(AppTheme.dark.brightness, Brightness.dark);
  });
}
