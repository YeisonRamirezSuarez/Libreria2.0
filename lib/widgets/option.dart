import 'package:flutter/material.dart';

class Option {
  final Icon icon;
  final String title;
  final VoidCallback onTap;

  Option({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
