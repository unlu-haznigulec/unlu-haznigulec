import 'package:design_system/components/image/p_cached_network_image.dart';
import 'package:design_system/components/lozenge/lozenge.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

/// A card that displays a user's profile information.
///
/// This is a standard UI element that is used throughout the app to display a user's profile information.
/// It displays a user's name, title, and image. It also displays a badge with the user's status, and
/// an optional button that can be used to initiate a chat with the user.
class PProfileCard extends StatefulWidget {
  /// The user's name.
  final String name;

  /// The user's title.
  final String? title;

  /// The user's profile image URL.
  final String? imageUrl;

  /// The placeholder profile image to display while the user's profile image is loading.
  final Icon? placeholderImage;

  /// The color of the badge that displays the user's status.
  final Color? badgeColor;

  /// The text to display on the badge that displays the user's status.
  final String? badgeText;

  /// A callback that is called when the user taps the button that can be used to initiate a chat with the user.
  final VoidCallback? onPressed;

  /// Creates a new [PProfileCard].
  const PProfileCard({
    Key? key,
    required this.name,
    this.title,
    required this.imageUrl,
    this.placeholderImage,
    this.badgeColor,
    this.badgeText,
    this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PProfileCardState();
}

class _PProfileCardState extends State<PProfileCard> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Grid.xs)),
        clipBehavior: Clip.hardEdge,
        child: Container(
          height: double.infinity,
          color: context.pColorScheme.iconPrimary.shade400,
          child: InkWell(
            hoverColor: context.pColorScheme.iconPrimary,
            onTap: widget.onPressed,
            child: Stack(
              children: <Widget>[
                SizedBox(
                  height: double.infinity,
                  child: PCachedNetworkImage(
                    imageUrl: widget.imageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          context.pColorScheme.darkHigh,
                          context.pColorScheme.darkHigh,
                          context.pColorScheme.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.badgeText != null,
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: Grid.s, top: Grid.s),
                      child: Container(
                        color: widget.badgeColor ?? context.pColorScheme.lightHigh,
                        child: PLozenge.custom(
                          text: widget.badgeText ?? '',
                          backgroundColor: widget.badgeColor ?? context.pColorScheme.lightHigh,
                          textColor: context.pColorScheme.lightHigh,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Container(
                    padding: const EdgeInsets.only(left: Grid.s, bottom: Grid.s, right: Grid.s),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.name,
                          maxLines: 2,
                          style: context.pAppStyle.interRegularBase.copyWith(
                            fontSize: Grid.m + Grid.xxs,
                            color: context.pColorScheme.lightHigh,
                            height: lineHeight150,
                          ),
                        ),
                        const SizedBox(height: Grid.xs),
                        Visibility(
                          visible: widget.title != null,
                          child: Text(
                            widget.title ?? '',
                            maxLines: 2,
                            style: context.pAppStyle.interRegularBase.copyWith(
                              fontSize: Grid.m - Grid.xxs,
                              color: context.pColorScheme.lightHigh,
                              height: lineHeight125,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
