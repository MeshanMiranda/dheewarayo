import 'package:flutter/material.dart';

// BaseScreen is a reusable layout wrapper used by almost all screens
// It provides a consistent Scaffold and AppBar (top navigation bar)
class BaseScreen extends StatelessWidget {
  final String? title; // The text to show in the top bar
  final Widget? titleWidget; // Alternatively, a custom widget for the top bar
  final Widget body; // The main content of the screen
  final List<Widget>? actions; // Buttons to show on the right side of the top bar

  const BaseScreen({
    super.key,
    this.title,
    this.titleWidget,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleWidget ?? (title != null ? Text(title!) : null),
        actions: actions,
      ),
      body: body,
    );
  }
}
