// lib/components/square.dart

import 'package:flutter/material.dart';
import '../models/chess_piece.dart';

/// A single tile on the chessboard.
/// Shows background color (white/black),
/// optional highlights for selection and valid moves,
/// and the chess piece image if present.
class Square extends StatelessWidget {
  final bool isWhite; // Whether tile is white or black (background color)
  final ChessPiece? piece; // The chess piece on this tile, if any
  final bool isSelected; // If this tile is currently selected by player
  final bool isValidMove; // If this tile is a valid move highlight
  final VoidCallback onTap; // Called when user taps this tile

  const Square({
    Key? key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.isValidMove,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Background color of tile (white or black)
    final backgroundColor = isWhite ? Colors.white : Colors.grey.shade700;

    // Overlay color for selection/highlighting
    Color? overlayColor;
    if (isSelected) {
      overlayColor = Colors.blue.withOpacity(0.5);
    } else if (isValidMove) {
      overlayColor = Colors.green.withOpacity(0.5);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: Stack(
          children: [
            if (piece != null)
              Center(child: Image.asset(piece!.imagePath, fit: BoxFit.contain)),
            if (overlayColor != null) Container(color: overlayColor),
          ],
        ),
      ),
    );
  }
}
