// lib/components/piece_image.dart

import '../models/chess_piece.dart';

/// Returns the correct asset path for the given chess piece.
String getPieceImage(ChessPiece piece) {
  final color = piece.isWhite ? 'white' : 'black';

  // Converts enum to lowercase string, e.g., PieceType.rook → rook
  final pieceName = piece.type.toString().split('.').last.toLowerCase();

  return 'lib/assets/${pieceName}_$color.png';
}
