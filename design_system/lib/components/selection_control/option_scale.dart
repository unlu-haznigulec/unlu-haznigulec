import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/icon/streamline_icons.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/platform_utils.dart';

typedef OptionScaleRatingChangeCallback = void Function(int index);
typedef NpsScaleRatingChangeCallback = void Function(int rating);

enum ScaleType { star, emoji, numerical }

List<String> moodIcons = [
  '/mood-0.png',
  '/mood-1.png',
  '/mood-2.png',
  '/mood-3.png',
  '/mood-4.png',
];

class POptionScale extends StatelessWidget {
  final int optionCount;
  final ScaleType scaleType;
  final double rating;
  final OptionScaleRatingChangeCallback? onRatingChanged;
  final Color? color;
  final Color? borderColor;
  final double size;
  final bool allowHalfRating;
  final bool allowDragRate;
  final IconData? filledIconData;
  final IconData? halfFilledIconData;
  final IconData? defaultIconData; //this is needed only when having fullRatedIconData && halfRatedIconData
  final double? spacing;

  const POptionScale({
    super.key,
    this.optionCount = 5,
    this.scaleType = ScaleType.star,
    this.spacing,
    this.rating = -1.0,
    this.defaultIconData,
    this.onRatingChanged,
    this.color,
    this.borderColor,
    this.size = 40,
    this.filledIconData,
    this.halfFilledIconData,
    this.allowHalfRating = false,
    this.allowDragRate = false,
  });

  /// Migrating for feedback components which were using third party library
  const POptionScale.rate({
    Key? key,
    required this.rating,
    required this.size,
    this.allowHalfRating = false,
    this.borderColor,
    this.onRatingChanged,
    this.optionCount = 5,
    this.scaleType = ScaleType.star,
    this.color,
    this.allowDragRate = true,
    this.filledIconData,
    this.halfFilledIconData,
    this.defaultIconData,
    this.spacing,
  }) : super(key: key);

  Widget _buildStar(BuildContext context, int index) {
    Icon icon;
    if (index < rating.toInt()) {
      icon = Icon(
        filledIconData ?? StreamlineIcons.rating_star,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    } else if (allowHalfRating && index <= rating.toInt()) {
      icon = Icon(
        halfFilledIconData ?? StreamlineIcons.rating_half_star,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    } else {
      icon = Icon(
        defaultIconData ?? StreamlineIcons.rating_star_alternate,
        color: borderColor ?? context.pColorScheme.textSecondary,
        size: size,
      );
    }

    return GestureDetector(
      onTap: () {
        if (onRatingChanged != null) {
          onRatingChanged!(index);
        }
      },
      onHorizontalDragUpdate: (dragDetails) {
        if (allowDragRate) {
          final RenderBox box = context.findRenderObject()! as RenderBox;
          final _pos = box.globalToLocal(dragDetails.globalPosition);
          final i = _pos.dx / size;
          var newRating = allowHalfRating ? i : i.round().toDouble();
          if (newRating > optionCount) {
            newRating = optionCount.toDouble();
          }
          if (newRating < 0) {
            newRating = 0.0;
          }
          if (onRatingChanged != null) {
            onRatingChanged!(index);
          }
        }
      },
      child: icon,
    );
  }

  Widget _buildEmoji(BuildContext context, int index) {
    Widget emoji;
    if (!moodIcons.first.contains('res/')) {
      for (int i = 0; i < moodIcons.length; i++) {
        if (PlatformUtils.isMobile) {
          moodIcons[i] = 'res/assets/social-profile${moodIcons[i]}';
        } else {
          moodIcons[i] = 'res/assets/images${moodIcons[i]}';
        }
      }
    }
    if (index + 1 == rating) {
      emoji = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: context.pColorScheme.darkLow,
              blurRadius: 2.0,
              offset: const Offset(0.0, 5.0),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(moodIcons[index], width: size, height: size),
        ),
      );
    } else {
      emoji = ClipOval(
        child: Opacity(
          opacity: 0.5,
          child: Material(
            elevation: 2,
            child: Image.asset(moodIcons[index], width: size, height: size),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (onRatingChanged != null) {
          onRatingChanged!(index);
        }
      },
      child: emoji,
    );
  }

  Widget _buildNumerical(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        if (onRatingChanged != null) {
          onRatingChanged!(index);
        }
      },
      child: NumericScaleOptionItem(
        text: '${index + 1}',
        selected: index == rating,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultSpacing = optionCount != 10 ? Grid.m : 12.0;

    return Material(
      color: Colors.transparent,
      child: Wrap(
        spacing: spacing ?? defaultSpacing,
        runSpacing: Grid.m,
        alignment: WrapAlignment.center,
        children: List.generate(
          optionCount,
          (index) => _buildOptionWidgets(context, index, scaleType),
        ),
      ),
    );
  }

  Widget _buildOptionWidgets(BuildContext context, index, scaleType) {
    switch (scaleType) {
      case ScaleType.star:
        return _buildStar(context, index);
      case ScaleType.emoji:
        return _buildEmoji(context, index);
      case ScaleType.numerical:
        return _buildNumerical(context, index);
    }
    return const SizedBox();
  }
}

class PNpsScale extends StatelessWidget {
  final int optionCount;
  final int? rating;
  final NpsScaleRatingChangeCallback? onRatingChanged;
  final Color? color;
  final Color? borderColor;
  final double size;
  final double spacing;

  const PNpsScale({
    super.key,
    this.optionCount = 11,
    this.rating = -1,
    this.onRatingChanged,
    this.color,
    this.borderColor,
    this.size = 40,
    this.spacing = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Wrap(
        spacing: spacing,
        alignment: WrapAlignment.center,
        children: List.generate(
          optionCount,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: Grid.s),
            child: GestureDetector(
              onTap: () {
                if (onRatingChanged != null) {
                  onRatingChanged!(index);
                }
              },
              child: NumericScaleOptionItem(
                selected: index == rating,
                text: '$index',
                size: size,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NumericScaleOptionItem extends StatelessWidget {
  final bool selected;
  final String text;
  final double size;

  const NumericScaleOptionItem({
    Key? key,
    required this.selected,
    required this.text,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selected ? context.pColorScheme.primary : context.pColorScheme.lightHigh,
        shape: BoxShape.circle,
        border: Border.all(
          color: context.pColorScheme.iconPrimary.shade200,
        ),
      ),
      child: Text(
        text,
        style: context.pAppStyle.interRegularBase.copyWith(
          fontSize: Grid.s + Grid.xs + Grid.xxs,
          color: selected ? context.pColorScheme.lightHigh : context.pColorScheme.darkHigh,
        ),
      ),
    );
  }
}
