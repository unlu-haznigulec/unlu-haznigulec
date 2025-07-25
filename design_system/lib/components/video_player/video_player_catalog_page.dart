import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/video_player/video_player.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class VideoPlayerCatalogPage extends StatelessWidget {
  const VideoPlayerCatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Video Player catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          Text(
            'Simple Video Player Usage:',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.m),
          const PVideoPlayer(
            videoUrl: 'videoUrl',
          ),
        ],
      ),
    );
  }
}
