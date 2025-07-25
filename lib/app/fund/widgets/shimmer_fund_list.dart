import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class ShimmerFundList extends StatelessWidget {
  const ShimmerFundList({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return ListView.separated(
      itemCount: 3,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const PDivider(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
        ),
      ),
      itemBuilder: (context, index) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: Grid.xs,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: floatingColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      Grid.s,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Grid.xs,
                children: [
                  Container(
                    width: 80,
                    height: 20,
                    decoration: BoxDecoration(
                      color: floatingColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          Grid.s,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 20,
                    decoration: BoxDecoration(
                      color: floatingColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          Grid.s,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            width: 80,
            height: 20,
            decoration: BoxDecoration(
              color: floatingColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  Grid.s,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
