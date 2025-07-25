import 'package:cached_network_image/cached_network_image.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/icon/streamline_icons.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class PCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final Map<String, String>? httpHeaders;
  final ImageWidgetBuilder? imageBuilder;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;

  const PCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.httpHeaders,
    this.imageBuilder,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      httpHeaders: httpHeaders,
      imageBuilder: imageBuilder,
      placeholder: placeholder,
      errorWidget: errorWidget ??
          (_, __, ___) {
            return Padding(
              padding: const EdgeInsets.all(Grid.s),
              child: Icon(
                StreamlineIcons.image_file_warning,
                color: context.pColorScheme.darkLow,
              ),
            );
          },
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }

  static Future evictImageFromCache(String imageUrl) async {
    await CachedNetworkImage.evictFromCache(imageUrl);
  }
}
