import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onClear;

  const SearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Buscar por nombre o autor',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: GestureDetector(
          onTap: onClear,
          child: const Icon(Icons.close),
        ),
      ),
    );
  }
}
