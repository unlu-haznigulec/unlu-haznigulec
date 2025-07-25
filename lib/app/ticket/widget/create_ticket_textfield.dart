import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:design_system/extension/theme_context_extension.dart';

//Ticket oluşturma ekranındaki textfield
class CreateTicketTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final double height;
  final Function(String)? onChanged;

  const CreateTicketTextField({
    super.key,
    required this.height,
    this.controller,
    required this.hintText,
    this.keyboardType,
    this.maxLength,
    this.onChanged,
  });

  @override
  State<CreateTicketTextField> createState() => _CreateTicketTextFieldState();
}

class _CreateTicketTextFieldState extends State<CreateTicketTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: context.pColorScheme.card,
        borderRadius: BorderRadius.circular(Grid.m),
      ),
      height: widget.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Grid.m),
        child: TextField(
          cursorColor: context.pColorScheme.primary,
          maxLength: widget.maxLength ?? 200,
          controller: widget.controller,
          keyboardType: widget.keyboardType ?? TextInputType.multiline,
          onEditingComplete: () => FocusScope.of(context).unfocus(),
          onSubmitted: (value) => FocusScope.of(context).unfocus(),
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          textInputAction: TextInputAction.done,
          onChanged: widget.onChanged,
          style: context.pAppStyle.labelReg16textPrimary,
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            hintText: widget.hintText,
            fillColor: context.pColorScheme.card,
            hintStyle: context.pAppStyle.labelReg16textSecondary,
          ),
          maxLines: null,
        ),
      ),
    );
  }
}
