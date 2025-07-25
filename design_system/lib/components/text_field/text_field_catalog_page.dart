import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/text_field/text_field.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class TextFieldCatalogPage extends StatefulWidget {
  const TextFieldCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _TextFieldCatalogPageState();
}

class _TextFieldCatalogPageState extends State<TextFieldCatalogPage> {
  final FocusNode validatorFocusNode = FocusNode();

  @override
  void dispose() {
    validatorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Text field catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          const SizedBox(height: Grid.l),
          PTextField(
            label: 'Label',
            helperText: 'Enabled and optional text field',
            optional: true,
            suffixWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'cms',
                  style: context.pAppStyle.interRegularBase.copyWith(
                    fontSize: Grid.s + Grid.xs + Grid.xxs,
                    color: context.pColorScheme.iconPrimary.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: Grid.m),
          PTextField(
            label: 'Error',
            helperText: 'Will show error if you type',
            focusNode: validatorFocusNode,
            validator: PValidator(
              focusNode: validatorFocusNode,
              validate: (String? input) {
                return 'Error message';
              },
            ),
          ),
          const SizedBox(height: Grid.m),
          const PTextField(
            label: 'Char Limit',
            showCharCount: true,
            maxLength: 10,
            helperText: 'Text field with char limit',
          ),
          const SizedBox(height: Grid.m),
          const PTextField(
            label: 'No helper text',
          ),
          const SizedBox(height: Grid.m),
          const PTextField(
            label: 'Suffix icon',
            suffixIcon: Icons.language,
            helperText: 'Example of text field with suffix icon',
          ),
          const SizedBox(height: Grid.m),
          const PTextField(
            label: 'Prefix icon',
            prefixIcon: Icons.account_circle,
            helperText: 'Example of text field with prefix icon',
          ),
          const SizedBox(height: Grid.m),
          const PTextField(
            label: 'Disabled',
            enabled: false,
            initialValue: 'Disabled Value',
          ),
          const SizedBox(height: Grid.m),
          const PTextField.password(
            helperText: 'Password with visibility button',
          ),
          const SizedBox(height: Grid.m),
          const PTextField.email(
            helperText: 'Field with email keyboard',
          ),
          const SizedBox(height: Grid.m),
          const PTextField.number(
            label: 'Number',
            helperText: 'Field with numeric keyboard',
          ),
          const SizedBox(height: Grid.m),
          const PTextField.number(
            allowDecimal: true,
            label: 'Decimal Number',
            helperText: 'Field with numeric keyboard and decimal support',
          ),
          const SizedBox(height: Grid.m),
          const PTextField.phone(
            label: 'Phone',
            helperText: 'Field with phone keyboard and validation',
          ),
          const SizedBox(height: Grid.m),
          const PTextField.creditCard(
            label: 'Credit Card',
            helperText: 'Credit card field',
          ),
          const SizedBox(height: Grid.m),
          const PTextField.multiline(
            label: 'Multiline',
            minLines: 4,
            hint: 'Some hint',
            helperText: 'Multiline field',
          ),
        ],
      ),
    );
  }
}
