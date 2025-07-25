import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/avatar/avatar.dart';
import 'package:design_system/components/list/gradient_list_item.dart';
import 'package:design_system/components/list/list_item.dart';
import 'package:design_system/components/list/selection_list_item.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/platform_utils.dart';

class ListItemCatalogPage extends StatefulWidget {
  const ListItemCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _ListItemCatalogPageState();
}

class _ListItemCatalogPageState extends State<ListItemCatalogPage> {
  bool _singleCheckboxVal = false;
  bool _doubleCheckboxVal = true;
  String _radioVal = 'None yet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'List catalog'),
      body: ListView(
        children: <Widget>[
          const PListItem(
            title: 'Line list item only text',
          ),
          PListItem(
            title: 'With trailing icon',
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          PListItem(
            title: 'With title icon',
            titleIcon: Icon(
              Icons.info,
              size: 14,
              color: context.pColorScheme.iconPrimary.shade400,
            ),
          ),
          PListItem(
            title: 'With leading icon',
            leading: Icon(
              Icons.filter_drama,
              color: context.pColorScheme.iconPrimary.shade900,
              size: 24,
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          const PListItem(
            title: 'With trailing text',
            trailingText: 'Trailing Text',
          ),
          PListItem(
            title: 'With trailing text and icon',
            trailingText: 'Trailing Text',
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          PListItem(
            title: 'Disabled list item',
            leading: Icon(
              Icons.filter_drama,
              color: context.pColorScheme.iconPrimary.shade900,
              size: 24,
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
            disabled: true,
          ),
          PListItem(
            title: 'Text which does not move on to the next line. No matter how long it may get.',
            leading: Icon(
              Icons.filter_drama,
              color: context.pColorScheme.iconPrimary.shade900,
              size: 24,
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          PListItem(
            title:
                'Text which is long and does move on to the next line. You can make it as long as you want. Text which is long and does move on to the next line. You can make it as long as you want. Text which is long and does move on to the next line. You can make it as long as you want. ',
            allowOverflow: true,
            leading: Icon(
              Icons.filter_drama,
              color: context.pColorScheme.iconPrimary.shade900,
              size: 24,
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          PListItem(
            title: 'With doctor image',
            leading: const PImageAvatar(
              imageUrl:
                  'https://png.pngtree.com/thumb_back/fw800/back_our/20190619/ourmid/pngtree-cute-doctor-cartoon-medical-doctors-day-advertisement-background-image_141631.jpg',
              text: 'DN',
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          PListItem(
            title: 'With initials avatar',
            leading: const PImageAvatar(
              text: 'DN',
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          const Divider(height: Grid.l),
          const PListItem(
            title: 'Double line list item only text',
            subtitle: 'Double line list item subtitle',
          ),
          PListItem(
            title: 'With trailing icon',
            subtitle: 'Double line list item subtitle',
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          PListItem(
            title: 'With leading icon',
            subtitle: 'Double line list item subtitle',
            leading: Icon(
              Icons.filter_drama,
              color: context.pColorScheme.iconPrimary.shade900,
              size: 24,
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          PListItem(
            title: 'Text which is long and does move on to the next line. You can make it as long as you want.',
            subtitle: 'Text which is long and does move on to the next line. You can make it as long as you want.',
            leading: Icon(
              Icons.filter_drama,
              color: context.pColorScheme.iconPrimary.shade900,
              size: 24,
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          PListItem(
            title: 'Text which is long and does move on to the next line. You can make it as long as you want.',
            subtitle: 'Text which is long and does move on to the next line. You can make it as long as you want.',
            leading: Icon(
              Icons.filter_drama,
              color: context.pColorScheme.iconPrimary.shade900,
              size: 24,
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
            allowOverflow: true,
          ),
          PListItem(
            title: 'With doctor image',
            subtitle: 'Double line list item subtitle',
            leading: const PImageAvatar(
              imageUrl:
                  'https://png.pngtree.com/thumb_back/fw800/back_our/20190619/ourmid/pngtree-cute-doctor-cartoon-medical-doctors-day-advertisement-background-image_141631.jpg',
              text: 'DN',
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          PListItem(
            title: 'With initials avatar',
            subtitle: 'Double line list item subtitle',
            leading: const PImageAvatar(
              text: 'DN',
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          const Divider(height: Grid.l),
          PRadioButtonListItem<String>(
            title: 'Single line with radio button - $_radioVal',
            value: 'Single',
            groupValue: _radioVal,
            onChanged: (val) => setState(() => _radioVal = val!),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          PCheckboxListItem(
            title: 'Single line with checkbox',
            value: _singleCheckboxVal,
            onChanged: (bool? newVal) => setState(() => _singleCheckboxVal = newVal!),
          ),
          PRadioButtonListItem<String>(
            title: 'Double line - $_radioVal',
            subtitle: 'with radio button',
            value: 'Double',
            groupValue: _radioVal,
            onChanged: (String? val) => setState(() => _radioVal = val!),
          ),
          PCheckboxListItem(
            title: 'Double line',
            subtitle: 'with checkbox',
            value: _doubleCheckboxVal,
            onChanged: (bool? newVal) => setState(() => _doubleCheckboxVal = newVal!),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
          ),
          PRadioButtonListItem<String>(
            title: 'Disabled single line with radio button - $_radioVal',
            value: 'Single',
            groupValue: _radioVal,
            onChanged: (String? val) => setState(() => _radioVal = val!),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: context.pColorScheme.iconPrimary.shade700,
            ),
            disabled: true,
          ),
          PCheckboxListItem(
            title: 'Single line with checkbox',
            value: _singleCheckboxVal,
            onChanged: (bool? newVal) => setState(() => _singleCheckboxVal = newVal!),
            disabled: true,
          ),
          const Divider(height: Grid.l),
          const PFacilityListItem(
            leading: PImageAvatar(
              imageUrl:
                  'https://png.pngtree.com/thumb_back/fw800/back_our/20190619/ourmid/pngtree-cute-doctor-cartoon-medical-doctors-day-advertisement-background-image_141631.jpg',
              text: 'DN',
              width: 64,
            ),
            title: 'The name. Only a single line. No matter how long it can get.',
            firstSubtitle: 'First set of details. Again, single line. No matter how long it can get.',
            secondSubtitle: 'Second set of details. Single line again. No matter how long it can get.',
          ),
          const PFacilityListItem(
            leading: PImageAvatar(
              imageUrl:
                  'https://png.pngtree.com/thumb_back/fw800/back_our/20190619/ourmid/pngtree-cute-doctor-cartoon-medical-doctors-day-advertisement-background-image_141631.jpg',
              text: 'DN',
              width: 64,
            ),
            title: 'The name. Only a single line. No matter how long it can get.',
            firstSubtitle: 'First set of details. Again, single line. No matter how long it can get.',
            secondSubtitle: 'Second set of details. Single line again. No matter how long it can get.',
            rating: 3,
            onlineBookingAvailable: true,
          ),
          const PFacilityListItem(
            leading: PImageAvatar(
              imageUrl:
                  'https://png.pngtree.com/thumb_back/fw800/back_our/20190619/ourmid/pngtree-cute-doctor-cartoon-medical-doctors-day-advertisement-background-image_141631.jpg',
              text: 'DN',
              width: 64,
            ),
            title: 'A disabled doctor.',
            firstSubtitle: 'First set of details. Again, single line. No matter how long it can get.',
            secondSubtitle: 'Second set of details. Single line again. No matter how long it can get.',
            rating: 3,
            onlineBookingAvailable: true,
            disabled: true,
          ),
          const PTimesheetListItem(
            title: 'Make an item',
            firstSubtitle: 'Coding',
            secondSubtitle: '10:00 AM - 12:17 AM, 2:17:00',
          ),
          const PTimesheetListItem(
            title: 'Call the HR manager',
            firstSubtitle: 'Call customers',
            secondSubtitle: '10:00 AM - 12:17 AM, 2:17:00',
            billable: true,
          ),
          PGradientListItem(
            title: "What's Bayzat Coins/Rewards?",
            subtitle: 'Learn how you can earn coins',
            action: 'Learn more',
            imageUrl: PlatformUtils.isMobile
                ? 'res/assets/employee-benefits/coin-logo.png'
                : 'res/assets/images/coin-logo.png',
            color: context.pColorScheme.warning.shade100,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
