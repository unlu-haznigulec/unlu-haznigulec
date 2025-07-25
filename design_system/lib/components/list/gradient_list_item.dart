import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

class PGradientListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String action;
  final String imageUrl;
  final Color color;
  final double rightPadding;
  final VoidCallback onTap;

  const PGradientListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.action,
    required this.imageUrl,
    required this.color,
    this.rightPadding = Grid.m,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Grid.m),
        child: Container(
          padding: EdgeInsetsDirectional.only(
            start: Grid.m,
            end: rightPadding,
            top: Grid.m,
            bottom: Grid.m,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            gradient: LinearGradient(
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
              colors: <Color>[
                context.pColorScheme.lightHigh,
                context.pColorScheme.lightHigh,
                context.pColorScheme.lightHigh,
                color,
              ],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.pAppStyle.interMediumBase.copyWith(
                        fontSize: Grid.m + Grid.xxs,
                        color: context.pColorScheme.darkHigh,
                        height: lineHeight125,
                      ),
                    ),
                    const SizedBox(height: Grid.xs),
                    Text(
                      subtitle,
                      style: context.pAppStyle.interRegularBase.copyWith(
                        fontSize: Grid.s + Grid.xs + Grid.xxs,
                        color: context.pColorScheme.darkMedium,
                        height: lineHeight150,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: Grid.l,
                    ),
                    Text(
                      action,
                      style: context.pAppStyle.labelMed16primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: Grid.m,
              ),
              Image.asset(
                imageUrl,
                height: 66,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
