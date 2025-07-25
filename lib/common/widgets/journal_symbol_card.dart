import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class JournalSymbolCard extends StatelessWidget {
  final String symbolCode;
  const JournalSymbolCard({
    super.key,
    required this.symbolCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23,
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.s,
      ),
      margin: const EdgeInsets.only(
        right: Grid.s,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            Grid.m,
          ),
        ),
        border: Border.all(
          color: context.pColorScheme.stroke,
        ),
      ),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkSVGImage(
              '${getIt<AppInfo>().cdnUrl}icons/news/$symbolCode.svg',
              placeholder: CircularProgressIndicator(color: context.pColorScheme.primary),
              errorWidget: Utils.generateCapitalFallback(
                context,
                symbolCode,
                size: Grid.s + Grid.xs,
              ),
              width: Grid.s + Grid.xs,
              height: Grid.s + Grid.xs,
              fadeDuration: const Duration(milliseconds: 500),
            ),
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          Text(
            symbolCode,
            textAlign: TextAlign.left,
            style: context.pAppStyle.labelReg14textPrimary,
          ),
        ],
      ),
    );
  }
}
