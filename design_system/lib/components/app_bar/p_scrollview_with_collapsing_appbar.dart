import 'dart:ui';

import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class PScrollViewWithCollapsingAppbar extends StatefulWidget {
  final SliverChildDelegate sliverChildDelegate;
  final Widget? flexibleSpaceBarBackground;
  final Widget flexibleSpaceBarTitle;
  final double appBarExpandedHeight;
  final Curve flexibleSpaceBarChildCollapseCurve;

  final Tween<double>? titlePaddingStartTween;
  final Tween<double>? titlePaddingEndTween;
  final Tween<double>? titlePaddingTopTween;
  final Tween<double>? titlePaddingBottomTween;

  final double appbarBackgroundStartPadding;
  final double appbarBackgroundEndPadding;
  final double appbarBackgroundBottomPadding;
  final double appbarBackgroundTopPadding;

  const PScrollViewWithCollapsingAppbar({
    Key? key,
    required this.sliverChildDelegate,
    this.flexibleSpaceBarBackground,
    required this.flexibleSpaceBarTitle,
    this.appBarExpandedHeight = 245,
    this.flexibleSpaceBarChildCollapseCurve = Curves.easeInOutQuad,
    this.titlePaddingStartTween,
    this.titlePaddingEndTween,
    this.titlePaddingTopTween,
    this.titlePaddingBottomTween,
    this.appbarBackgroundStartPadding = 0,
    this.appbarBackgroundEndPadding = 0,
    this.appbarBackgroundBottomPadding = 0,
    this.appbarBackgroundTopPadding = Grid.m,
  }) : super(key: key);

  @override
  State<PScrollViewWithCollapsingAppbar> createState() => _PScrollViewWithCollapsingAppbarState();
}

class _PScrollViewWithCollapsingAppbarState extends State<PScrollViewWithCollapsingAppbar> {
  static const double minExtent = 0.0;
  double _currentExtent = 0.0;

  final ScrollController _scrollController = ScrollController();
  late double _deltaExtent;
  late Curve _curve;

  late double _titlePaddingStart;
  late double _titlePaddingEnd;
  late double _titlePaddingBottom;
  late double _titlePaddingTop;

  Tween<double>? _titlePaddingStartTween;
  Tween<double>? _titlePaddingEndTween;
  Tween<double>? _titlePaddingTopTween;
  Tween<double>? _titlePaddingBottomTween;

  late double _backgroundStartPadding;
  late double _backgroundEndPadding;
  late double _backgroundBottomPadding;
  late double _backgroundTopPadding;

  @override
  void initState() {
    super.initState();
    _deltaExtent = widget.appBarExpandedHeight - minExtent - kToolbarHeight;
    _curve = widget.flexibleSpaceBarChildCollapseCurve;

    _backgroundStartPadding = widget.appbarBackgroundStartPadding;
    _backgroundEndPadding = widget.appbarBackgroundEndPadding;
    _backgroundBottomPadding = widget.appbarBackgroundBottomPadding;
    _backgroundTopPadding = widget.appbarBackgroundTopPadding;

    _titlePaddingStartTween = widget.titlePaddingStartTween;
    _titlePaddingEndTween = widget.titlePaddingEndTween;
    _titlePaddingTopTween = widget.titlePaddingTopTween;
    _titlePaddingBottomTween = widget.titlePaddingBottomTween;

    _titlePaddingStart = _titlePaddingStartTween?.begin! ?? 0;
    _titlePaddingEnd = _titlePaddingEndTween?.begin! ?? 0;
    _titlePaddingBottom = _titlePaddingBottomTween?.begin! ?? 0;
    _titlePaddingTop = _titlePaddingTopTween?.begin! ?? 0;

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _scrollListener() {
    setState(() {
      _currentExtent = _scrollController.offset;
      _titlePaddingStart = _remapCurrentExtent(_titlePaddingStartTween);
      _titlePaddingEnd = _remapCurrentExtent(_titlePaddingEndTween);
      _titlePaddingBottom = _remapCurrentExtent(_titlePaddingBottomTween);
      _titlePaddingTop = _remapCurrentExtent(_titlePaddingTopTween);
    });
  }

  double _remapCurrentExtent(Tween<double>? target) {
    if (target != null) {
      if (target.begin != target.end) {
        final double deltaTarget = target.end! - target.begin!;
        double t = 0.0;

        if (_currentExtent >= _deltaExtent) {
          t = 1.0;
        } else {
          final double currentTarget = (((_currentExtent - minExtent) * deltaTarget) / _deltaExtent) + target.begin!;
          t = (currentTarget - target.begin!) / deltaTarget;
        }
        final double curveT = _curve.transform(t);
        return lerpDouble(target.begin, target.end, curveT)!;
      }
      return target.begin!;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          expandedHeight: widget.appBarExpandedHeight,
          collapsedHeight: kToolbarHeight,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: EdgeInsetsDirectional.only(
                top: kToolbarHeight + MediaQuery.of(context).viewPadding.top + _backgroundTopPadding,
                start: _backgroundStartPadding,
                end: _backgroundEndPadding,
                bottom: _backgroundBottomPadding,
              ),
              child: widget.flexibleSpaceBarBackground,
            ),
            titlePadding: EdgeInsetsDirectional.only(
              top: _titlePaddingTop,
              bottom: _titlePaddingBottom,
              start: _titlePaddingStart,
              end: _titlePaddingEnd,
            ),
            centerTitle: true,
            expandedTitleScale: 1.0,
            title: widget.flexibleSpaceBarTitle,
          ),
          pinned: true,
        ),
        SliverList(delegate: widget.sliverChildDelegate),
      ],
    );
  }
}
