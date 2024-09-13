import 'package:flutter/material.dart';

class CardLibroView extends StatelessWidget {
  const CardLibroView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500.0,
      color: Colors.grey[700], // Fondo para el RecyclerView
      child: const Center(
        child: Text(
          'RecyclerView Placeholder',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
