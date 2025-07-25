import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/constant.dart';

class EditColumnIcon extends StatelessWidget {
  final Function()? onTap;
  const EditColumnIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        Icons.tune,
        size: tabPageIconSize,
        color: Theme.of(context).dividerColor.withOpacity(0.3),
      ),
    );
  }
}
