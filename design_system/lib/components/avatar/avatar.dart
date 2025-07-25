import 'package:design_system/components/image/p_cached_network_image.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class PTextAvatar extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double width;
  final Color? color;

  const PTextAvatar({
    Key? key,
    this.text = '',
    this.textStyle,
    this.width = Grid.xl,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color ?? context.pColorScheme.iconPrimary.shade900,
      radius: width / 2,
      child: Text(
        text,
        style: textStyle ??
            context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
              color: context.pColorScheme.lightHigh,
            ),
      ),
    );
  }
}

// TODO(selcukguvel): text.substring(0, 2) usages need to be fixed in this class and in all the callers.
// TODO(selcukguvel): We need to have a validation to check whether text is long enough to apply substring(0, 2).
class PImageAvatar extends StatefulWidget {
  final String? text;
  final TextStyle? textStyle;
  final double width;
  final Color? color;
  final String imageUrl;
  final Widget? placeholder;
  final bool? useLocalImage;
  final bool? hasBorder;
  final VoidCallback? onTap;

  const PImageAvatar({
    Key? key,
    this.text = '',
    this.textStyle,
    this.width = Grid.xl,
    this.color,
    this.imageUrl = '',
    this.placeholder,
    this.onTap,
    useLocalImage,
    hasBorder,
  })  : useLocalImage = useLocalImage ?? false,
        hasBorder = hasBorder ?? true,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _PImageAvatarState();
}

class _PImageAvatarState extends State<PImageAvatar> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        height: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.width / 2)),
          border: widget.hasBorder == true
              ? Border.all(
                  color: context.pColorScheme.iconPrimary.shade300,
                )
              : null,
        ),
        child: ClipOval(
          child: widget.useLocalImage == true
              ? Image.asset(
                  widget.imageUrl,
                  width: widget.width,
                  height: widget.width,
                )
              : PCachedNetworkImage(
                  width: widget.width,
                  height: widget.width,
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.fitWidth,
                  placeholder: (_, __) =>
                      widget.placeholder ??
                      PTextAvatar(
                        text: widget.text?.substring(0, 2).toUpperCase() ?? '',
                        textStyle: widget.textStyle ??
                            context.pAppStyle.interMediumBase.copyWith(
                              fontSize: Grid.m + Grid.xxs,
                              color: context.pColorScheme.lightHigh,
                            ),
                        width: widget.width,
                        color: widget.color ?? context.pColorScheme.iconPrimary.shade900,
                      ),
                  errorWidget: (_, __, ___) {
                    if (widget.placeholder != null) {
                      return widget.placeholder!;
                    } else if (widget.text != null && widget.text!.length >= 2) {
                      return PTextAvatar(
                        text: widget.text?.substring(0, 2).toUpperCase() ?? '',
                        textStyle: widget.textStyle ??
                            context.pAppStyle.interMediumBase.copyWith(
                              fontSize: Grid.m + Grid.xxs,
                              color: context.pColorScheme.lightHigh,
                            ),
                        width: widget.width,
                        color: widget.color ?? context.pColorScheme.iconPrimary.shade900,
                      );
                    } else {
                      return Icon(
                        Icons.broken_image,
                        color: context.pColorScheme.darkLow,
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
