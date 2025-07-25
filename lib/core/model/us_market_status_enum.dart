import 'package:piapiri_v2/common/utils/images_path.dart';

enum UsMarketStatus {
  open('open_market', ImagesPath.sun),
  preMarket('pre_market', ImagesPath.yellowCloud),
  afterMarket('post_market', ImagesPath.cloud),
  closed('close_market', ImagesPath.moon),
  weekend('weekend_market', ImagesPath.moon);

  final String localizationKey;
  final String iconPath;
  const UsMarketStatus(
    this.localizationKey,
    this.iconPath,
  );
}
