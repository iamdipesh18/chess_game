// lib/helpers/helper_methods.dart

bool isInBoard(int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}

/// Returns true if the index is in a white tile
/// (used for board coloring)
bool isWhiteTile(int row, int col) {
  return (row + col) % 2 == 0;
}

/// Converts a piece type to its readable name (optional helper)
String getPieceName(String path) {
  return path.split('/').last.split('.').first;
}

/// For sorting captured pieces by value
int getPieceValue(String name) {
  switch (name) {
    case 'queen':
      return 9;
    case 'rook':
      return 5;
    case 'bishop':
    case 'knight':
      return 3;
    case 'pawn':
      return 1;
    default:
      return 0;
  }
}
