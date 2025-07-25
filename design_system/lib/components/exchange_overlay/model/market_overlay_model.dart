abstract class MarketOverlayModel {
  final int index;
  final String label;
  final String assetPath;

  MarketOverlayModel({
    required this.label,
    required this.index,
    required this.assetPath,
  });
}

class TopMarketOverlayModel extends MarketOverlayModel {
  TopMarketOverlayModel({
    required int index,
    required String label,
    required String assetPath,
  }) : super(
          index: index,
          label: label,
          assetPath: assetPath,
        );
}

class BottomMarketOverlayModel extends MarketOverlayModel {
  BottomMarketOverlayModel({
    required int index,
    required String label,
    required String assetPath,
  }) : super(
          index: index,
          label: label,
          assetPath: assetPath,
        );
}
