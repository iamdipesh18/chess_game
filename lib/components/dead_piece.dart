// lib/components/dead_piece.dart

import 'package:flutter/material.dart';

/// Widget to display a captured chess piece.
/// Uses the piece image and optionally shows a subtle opacity to differentiate.
class DeadPiece extends StatelessWidget {
  final String imagePath;
  final bool isWhite; // true if the piece captured is white, false if black

  const DeadPiece({Key? key, required this.imagePath, required this.isWhite})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Slight opacity to make it look "captured"
    final opacity = 0.7;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          color: isWhite ? Colors.white : Colors.black,
          colorBlendMode: BlendMode.modulate,
        ),
      ),
    );
  }
}
