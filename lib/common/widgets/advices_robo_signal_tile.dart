import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:design_system/extension/theme_context_extension.dart';

class AdvicesRoboSignalTile extends StatelessWidget {
  //final AdviceModel advice;
  const AdvicesRoboSignalTile({
    super.key,
    // required this.advice
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.pColorScheme.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.abc,
            size: 28,
          ),
          const SizedBox(
            width: Grid.s,
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  //advice.symbolName
                  'THYAO',
                  style: TextStyle(
                    fontFamily: 'Inter-Regular',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff35384B),
                  ),
                ),
                SizedBox(
                  height: Grid.xs,
                ),
                Text(
                  // DateTimeUtils.dateFormat(
                  //   DateTime.parse(
                  //     advice.created,
                  //   ),
                  // ),
                  '08.07.2024, 10:18',
                  style: TextStyle(
                    fontFamily: 'Inter-Medium',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff737586),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'SAT',
            style: TextStyle(
              fontFamily: 'Inter-Medium',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: context.pColorScheme.critical,
              // color: advice.adviceSideId == 1 ? PColor.success500 : PColor.critical500
            ),
          ),
          const Icon(
            Icons.plus_one,
            size: 28,
          )
        ],
      ),
    );
  }
}
