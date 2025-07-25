import 'package:piapiri_v2/app/banner/repository/banner_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class BannerRepositoryImpl extends BannerRepository {
  @override
  Future<ApiResponse> getBanners() async {
    return getIt<PPApi>().bannerService.getBanners();
  }

  @override
  Future<ApiResponse> getMemberBanners({
    required String phoneNumber,
  }) async {
    return getIt<PPApi>().bannerService.getMemberBanners(
          phoneNumber: phoneNumber,
        );
  }
}
