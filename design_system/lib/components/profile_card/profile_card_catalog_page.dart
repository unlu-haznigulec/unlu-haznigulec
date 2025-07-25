import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/profile_card/profile_card.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class ProfileCardCatalogPage extends StatelessWidget {
  const ProfileCardCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Profile card catalog'),
      body: ListView(
        children: [
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const <Widget>[
                PProfileCard(
                  name: 'Mridul Bajoria',
                  title: 'Product Manager',
                  imageUrl:
                      'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
                ),
                PProfileCard(
                  name: 'Talal Bayaa',
                  title: 'CEO',
                  imageUrl:
                      'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
                ),
                PProfileCard(
                  name: 'Sophie Alexandra',
                  title: 'March 15',
                  imageUrl:
                      'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
                ),
                PProfileCard(
                  name: 'Antonio Al Asmar',
                  title: 'General Manager',
                  imageUrl:
                      'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
                ),
                PProfileCard(
                  name: 'Antonio Al Asmar',
                  title: 'General Manager',
                  imageUrl:
                      'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
                ),
                PProfileCard(
                  name: 'Antonio Al Asmar',
                  title: 'General Manager',
                  imageUrl:
                      'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
                ),
                PProfileCard(
                  name: 'Antonio Al Asmar',
                  title: 'General Manager',
                  imageUrl:
                      'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
                ),
                PProfileCard(
                  name: 'Antonio Al Asmar',
                  title: 'General Manager',
                  imageUrl:
                      'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
                ),
              ],
            ),
          ),
          const Divider(),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.66,
            shrinkWrap: true,
            padding: const EdgeInsets.all(Grid.xs),
            crossAxisCount: 3,
            mainAxisSpacing: Grid.xs,
            crossAxisSpacing: Grid.xs,
            children: const <Widget>[
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
              PProfileCard(
                name: 'Antonio Al Asmar',
                title: 'General Manager',
                imageUrl:
                    'https://images.pexels.com/photos/3763188/pexels-photo-3763188.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
