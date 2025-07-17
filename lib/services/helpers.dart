/// Checks if the given [row] and [col] are valid indices on the 8x8 chessboard.
bool isInBoard(int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}
