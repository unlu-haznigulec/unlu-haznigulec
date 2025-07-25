import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PSkeletonCard extends StatelessWidget {
  final bool haveLeading;
  final bool isCircularImage;
  final bool isBottomLinesActive;
  final double? height, width;
  final double padding;

  const PSkeletonCard({
    Key? key,
    this.haveLeading = true,
    this.isCircularImage = true,
    this.isBottomLinesActive = true,
    this.height,
    this.width,
    this.padding = Grid.m,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = this.width ?? MediaQuery.of(context).size.width;
    final height = this.height ?? MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Grid.m),
          color: context.pColorScheme.lightHigh,
        ),
        padding: const EdgeInsets.all(Grid.m),
        child: PShimmer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  if (haveLeading) _leadingAvatar(context, width),
                  _topLines(context, width, height),
                ],
              ),
              if (isBottomLinesActive)
                _bottomLines(
                  context,
                  height,
                  width,
                )
              else
                const Offstage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topLines(BuildContext context, double width, double height) {
    return SizedBox(
      height: width * 0.13,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: height * 0.008,
            width: width * 0.3,
            color: context.pColorScheme.lightHigh,
          ),
          Container(
            height: height * 0.007,
            width: width * 0.2,
            color: context.pColorScheme.lightHigh,
          ),
        ],
      ),
    );
  }

  Widget _leadingAvatar(BuildContext context, double width) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: Grid.m),
      child: Container(
        height: width * 0.13,
        width: width * 0.13,
        decoration: BoxDecoration(
          shape: isCircularImage ? BoxShape.circle : BoxShape.rectangle,
          color: context.pColorScheme.lightHigh,
        ),
      ),
    );
  }

  Widget _bottomLines(BuildContext context, double height, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: Grid.l,
        ),
        Container(
          height: height * 0.007,
          width: width * 0.7,
          color: context.pColorScheme.lightHigh,
        ),
        const SizedBox(
          height: Grid.s,
        ),
        Container(
          height: height * 0.007,
          width: width * 0.8,
          color: context.pColorScheme.lightHigh,
        ),
        const SizedBox(
          height: Grid.s,
        ),
        Container(
          height: height * 0.007,
          width: width * 0.5,
          color: context.pColorScheme.lightHigh,
        ),
      ],
    );
  }
}

class PSkeletonCardList extends StatelessWidget {
  final bool haveLeading;
  final bool isCircularImage;
  final bool isBottomLinesActive;
  final int length;

  const PSkeletonCardList({
    super.key,
    this.haveLeading = false,
    this.isCircularImage = true,
    this.length = 10,
    this.isBottomLinesActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int index) {
        return PSkeletonCard(
          haveLeading: haveLeading,
          isCircularImage: isCircularImage,
          isBottomLinesActive: isBottomLinesActive,
        );
      },
    );
  }
}

class PShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor, highlightColor;
  final Duration? period;

  const PShimmer({
    Key? key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? context.pColorScheme.stroke.shade100,
      highlightColor: highlightColor ?? context.pColorScheme.stroke.shade300,
      period: period ?? const Duration(milliseconds: 1500),
      child: child,
    );
  }
}
