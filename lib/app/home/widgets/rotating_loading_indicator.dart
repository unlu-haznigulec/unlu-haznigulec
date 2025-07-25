import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class RotatingLoadingIcon extends StatefulWidget {
  const RotatingLoadingIcon({super.key});

  @override
  State<RotatingLoadingIcon> createState() => _RotatingLoadingIconState();
}

class _RotatingLoadingIconState extends State<RotatingLoadingIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // sürekli döndür
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SvgPicture.asset(
        ImagesPath.refresh,
        width: Grid.m,
        height: Grid.m,
        colorFilter: ColorFilter.mode(
          context.pColorScheme.textQuaternary,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
