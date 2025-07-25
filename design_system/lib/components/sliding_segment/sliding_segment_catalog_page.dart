import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/sliding_segment/model/sliding_segment_item.dart';
import 'package:design_system/components/sliding_segment/sliding_segment.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class SlidingSegmentCatalogPage extends StatefulWidget {
  const SlidingSegmentCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _ButtonCatalogPageCatalogPageState();
}

class _ButtonCatalogPageCatalogPageState extends State<SlidingSegmentCatalogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.darkLow,
      appBar: const PAppBarCoreWidget(title: 'Buy Sell Slider Catalog'),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: Grid.xl,
          ),
          SlidingSegment(
            onValueChanged: (p0) {},
            segmentList: [
              PSlidingSegmentItem(
                segmentTitle: 'Al',
                segmentColor: context.pColorScheme.success,
              ),
              PSlidingSegmentItem(
                segmentTitle: 'Sat',
                segmentColor: context.pColorScheme.critical,
              ),
              PSlidingSegmentItem(
                segmentTitle: 'Aciga Sat',
                segmentColor: context.pColorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
