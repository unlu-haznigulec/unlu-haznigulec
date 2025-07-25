import 'dart:ui';
import 'package:design_system/components/exchange_overlay/widgets/show_case_view.dart';

class PSlidingSegmentItem {
  final String segmentTitle;
  final Color segmentColor;
  final ShowCaseViewModel? showCase;

  PSlidingSegmentItem({
    required this.segmentTitle,
    required this.segmentColor,
    this.showCase,
  });
}
