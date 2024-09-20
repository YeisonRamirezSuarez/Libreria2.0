import 'package:flutter/material.dart';
import 'option.dart';

class OverlayMenu extends StatelessWidget {
  final List<Option> options;
  final RenderBox renderBox;
  final VoidCallback onClose;

  const OverlayMenu({
    super.key,
    required this.options,
    required this.renderBox,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            color: Colors.black54,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        Positioned(
          left: offset.dx - 140,
          top: offset.dy,
          width: 200,
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
              child: Container(
                color: Colors.redAccent,
                width: 180,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: options.map((option) {
                    return ListTile(
                      leading: option.icon,
                      iconColor: Colors.white,
                      title: Text(option.title,
                          style: const TextStyle(color: Colors.white)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      onTap: option.onTap,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
