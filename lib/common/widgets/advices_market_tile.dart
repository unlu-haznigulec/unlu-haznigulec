import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AdvicesMarketTile extends StatelessWidget {
  //final AdviceModel advice;
  const AdvicesMarketTile({
    super.key,
    // required this.advice
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.pColorScheme.transparent,
      child: Column(
        children: [
          Row(
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
                  // color: advice.adviceSideId == 1 ? context.pColorScheme.success500 : context.pColorScheme.critical500
                  color: context.pColorScheme.critical,
                ),
              ),
              SvgPicture.asset(
                'assets/images/advice_side.svg',
                width: 28,
                height: 29,
                // color: advice.adviceSideId == 1 ? context.pColorScheme.success500 : context.pColorScheme.critical500,
                color: context.pColorScheme.critical,
              )
            ],
          ),
          const SizedBox(
            height: Grid.s,
          ),
          const Text(
            //advice.description ?? '',
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incidid. Lorem ipsum dolor sit amet.',
            style: TextStyle(
              fontFamily: 'Inter-Regular',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xff35384B),
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _info(
                L10n.tr('opening_price'),
                MoneyUtils().readableMoney(
                  // advice.openingPrice,
                  12,
                ),
                context,
              ),
              _info(
                L10n.tr('target_price'),
                MoneyUtils().readableMoney(
                  //advice.targetPrice
                  10,
                ),
                context,
                textAlign: TextAlign.center,
              ),
              _info(
                L10n.tr('stop_loss'),
                // advice.stopLoss == null ? '-' : MoneyUtils().readableMoney(advice.stopLoss!),
                '15',
                context,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(
    String title,
    String data,
    BuildContext context, {
    TextAlign textAlign = TextAlign.left,
  }) {
    return Expanded(
      child: RichText(
        textAlign: textAlign,
        text: TextSpan(
          text: title,
          style: const TextStyle(
            fontFamily: 'Inter-Medium',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xff737586),
          ),
          children: [
            TextSpan(
              text: data.isNotEmpty ? ' $data' : ' -',
              style: const TextStyle(
                fontFamily: 'Inter-Medium',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xff35384B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
