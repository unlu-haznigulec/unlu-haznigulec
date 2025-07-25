import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/expansion_tile/expansion_tile.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class ExpansionTileCatalogPage extends StatelessWidget {
  const ExpansionTileCatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<PExpansionTile> tiles = [
      const PExpansionTile(
        title: 'Question 1 ?',
        children: <Widget>[Text('Answer 1')],
      ),
      const PExpansionTile(
        title: 'Long title that exceeds one line which is fine along with long answer',
        children: <Widget>[
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id gravida neque. Mauris non odio eget augue congue suscipit vel id ligula.',
          ),
        ],
      ),
      PExpansionTile(
        title: 'Can we answer with a image?',
        children: <Widget>[
          const Text('YES!'),
          const SizedBox(height: Grid.m),
          Image.asset(
            'res/assets/icon/google-light.png',
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Expansion Tile'),
      body: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return tiles[index];
        },
        itemCount: tiles.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: Grid.m),
      ),
    );
  }
}
