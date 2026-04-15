import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget body;
  final List<Widget>? actions;

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
