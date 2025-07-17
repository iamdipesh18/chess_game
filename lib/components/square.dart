import 'package:flutter/material.dart';
import '../models/chess_piece.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final bool isCheckSquare;
  final VoidCallback onTap;

  const Square({
    Key? key,
    required this.isWhite,
    this.piece,
    this.isSelected = false,
    this.isValidMove = false,
    this.isCheckSquare = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color baseColor = isWhite ? Colors.brown[200]! : Colors.brown[700]!;
    final Color highlightColor = Colors.amberAccent.withOpacity(0.7);

    Color squareColor = baseColor;
    if (isSelected) {
      squareColor = Colors.blueAccent.withOpacity(0.8);
    } else if (isValidMove) {
      squareColor = Colors.greenAccent.withOpacity(0.6);
    } else if (isCheckSquare) {
      squareColor = Colors.redAccent.withOpacity(0.7);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: squareColor,
          border: Border.all(
            color: isSelected ? Colors.yellowAccent : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.yellowAccent.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Center(
          child: _buildPiece(),
        ),
      ),
    );
  }

  Widget _buildPiece() {
    if (piece == null) {
      return const SizedBox.shrink();
    }

    final ChessPiece nonNullPiece = piece!;

    return Hero(
      tag: 'piece_${nonNullPiece.type}_${nonNullPiece.isWhite}_$hashCode',
      child: Image.asset(
        nonNullPiece.imagePath,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
