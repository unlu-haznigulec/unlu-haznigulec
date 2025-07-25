import 'package:design_system/components/rich_text_field/rich_text_controller.dart';
import 'package:design_system/components/text_field/text_field.dart';
import 'package:flutter/material.dart';

class PRichTextField extends StatefulWidget {
  final String? initialValue;
  final String? label;
  final String? hint;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final double bottomDistance;
  final FocusNode? focusNode;
  final bool autoFocus;
  final PRichTextController? controller;
  final List<PRichTextPattern>? patterns;
  final List<Mentionable>? mentionables;
  final void Function(String)? onChanged;
  final Widget Function(
    BuildContext context,
    String filter,
    Function(String) onSelect,
    List<Mentionable>? mentionables,
  ) mentionablesListBuilder;

  const PRichTextField({
    Key? key,
    this.initialValue,
    this.label,
    this.hint,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.bottomDistance = 0.0,
    this.focusNode,
    this.autoFocus = false,
    this.controller,
    this.patterns,
    this.mentionables,
    this.onChanged,
    required this.mentionablesListBuilder,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PRichTextFieldState();
}

class PRichTextFieldState extends State<PRichTextField> {
  static OverlayEntry? _overlayEntry;

  late PRichTextController _controller;
  late FocusNode _focusNode;
  late GlobalKey _textFieldKey;
  final LayerLink _layerLink = LayerLink();
  TextEditingValue? _previousTextEditingValue;
  String _mentionListFilter = '';

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PRichTextController(text: widget.initialValue, patterns: widget.patterns);
    _focusNode = widget.focusNode ?? FocusNode();
    _textFieldKey = GlobalKey();
    _controller.addListener(_onFormTextChange);
  }

  PRichTextController get controller => _controller;

  FocusNode get focusNode => _focusNode;

  String get text => _controller.text;

  set text(String value) => _updateControllerValue(text, text.characters.length - 1);

  void _updateControllerValue(String text, int offset) {
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection(baseOffset: offset, extentOffset: offset),
    );
  }

  set mentionListFilter(String value) {
    _mentionListFilter = value;
    if (_overlayEntry != null) {
      _showMentionList(context, recreate: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: PTextField.multiline(
        key: _textFieldKey,
        focusNode: _focusNode,
        autoFocus: widget.autoFocus,
        label: widget.label,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines ?? 5,
        hint: widget.hint,
        controller: _controller,
        minLines: widget.minLines ?? 1,
        onChanged: widget.onChanged,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _removeMentionList();
  }

  void _pickMention(String employeeId) {
    final position = findClosestAtSign(_controller.value.selection.baseOffset, _controller.value.text.characters);
    if (position != -1) {
      setState(() {
        final String newText =
            '${_controller.value.text.substring(0, position)}@$employeeId ${_controller.value.text.substring(_controller.selection.baseOffset)}';
        _updateControllerValue(newText, position + 38);
        _removeMentionList();
        mentionListFilter = '';
      });
    }
  }

  void _onFormTextChange() {
    final TextEditingValue? previous = _previousTextEditingValue;
    final TextEditingValue current = _controller.value.copyWith();
    _previousTextEditingValue = current;

    final bool potentialBackspace =
        previous != null && previous.text.characters.length == current.text.characters.length + 1;

    int nearestAtIndex = -1;
    nearestAtIndex = findClosestAtSign(_controller.value.selection.baseOffset, _controller.value.text.characters);

    if (nearestAtIndex != -1) {
      final String filterWord = current.text.characters.getRange(nearestAtIndex + 1, nearestAtIndex + 36).toString();

      if (filterWord.length == 35 && potentialBackspace) {
        final String cleanedText =
            _controller.value.text.substring(0, nearestAtIndex) + _controller.value.text.substring(nearestAtIndex + 36);
        _updateControllerValue(cleanedText, nearestAtIndex);
        mentionListFilter = '';
        _removeMentionList();
      } else {
        mentionListFilter = filterWord;
        _showMentionList(context);
      }
    } else {
      mentionListFilter = '';
      _removeMentionList();
    }
  }

  void _showMentionList(BuildContext context, {bool recreate = false}) {
    if (_overlayEntry != null && !recreate) {
      return;
    } else if (recreate) {
      _overlayEntry?.remove();
    }
    final OverlayState overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(-(_layerLink.leader?.offset.dx ?? 0), -384),
          child: Stack(
            // TODO(Sita): Check why do we need a Stack here
            children: [
              widget.mentionablesListBuilder(
                context,
                _mentionListFilter,
                _pickMention,
                widget.mentionables,
              ),
            ],
          ),
        );
      },
    );
    overlayState.insert(_overlayEntry!);
  }

  void _removeMentionList() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}

class Mentionable {
  final String name;
  final String id;
  final String? position;
  final bool? isActive;
  final bool? isDeleted;

  Mentionable({
    required this.name,
    required this.id,
    this.position,
    this.isActive,
    this.isDeleted,
  });
}
