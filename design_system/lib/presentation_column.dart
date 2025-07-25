import 'package:flutter/material.dart';

// TODO(SK): Add header as parameter
class PresentationColumn extends StatelessWidget {
  final List<Widget> children;
  final Color? backgroundColor;

  const PresentationColumn({
    Key? key,
    required this.children,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
