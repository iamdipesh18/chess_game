import 'package:chess_game/models/chess_piece.dart';
import 'package:chess_game/models/game_state.dart';
import 'package:chess_game/helper/helper_methods.dart';

/// Generates all raw possible moves for a given piece on the board.
/// These moves do NOT consider checks or king safety.
/// This class focuses purely on how each piece moves.
class MoveGenerator {
  final GameState gameState;

  MoveGenerator(this.gameState);

  /// Returns list of all possible raw moves (row, col) for piece at [row], [col].
  /// Ignores king safety and check conditions.
  List<List<int>> generateRawValidMoves(int row, int col) {
    ChessPiece? piece = gameState.board[row][col];
    if (piece == null) return [];

    List<List<int>> candidateMoves = [];
    int direction = piece.isWhite ? -1 : 1; // White moves up, black moves down

    switch (piece.type) {
      case ChessPieceType.pawn:
        candidateMoves.addAll(_pawnMoves(row, col, piece, direction));
        break;

      case ChessPieceType.rook:
        candidateMoves.addAll(
          _linearMoves(row, col, piece, [
            [1, 0],
            [-1, 0],
            [0, 1],
            [0, -1],
          ]),
        );
        break;

      case ChessPieceType.bishop:
        candidateMoves.addAll(
          _linearMoves(row, col, piece, [
            [1, 1],
            [1, -1],
            [-1, 1],
            [-1, -1],
          ]),
        );
        break;

      case ChessPieceType.knight:
        candidateMoves.addAll(_knightMoves(row, col, piece));
        break;

      case ChessPieceType.queen:
        candidateMoves.addAll(
          _linearMoves(row, col, piece, [
            [1, 0],
            [-1, 0],
            [0, 1],
            [0, -1],
            [1, 1],
            [1, -1],
            [-1, 1],
            [-1, -1],
          ]),
        );
        break;

      case ChessPieceType.king:
        candidateMoves.addAll(_kingMoves(row, col, piece));
        break;
    }

    return candidateMoves;
  }

  /// Pawn move logic including forward moves and captures.
  List<List<int>> _pawnMoves(
    int row,
    int col,
    ChessPiece piece,
    int direction,
  ) {
    List<List<int>> moves = [];

    // Forward 1
    int oneStepRow = row + direction;
    if (isInBoard(oneStepRow, col) &&
        gameState.board[oneStepRow][col] == null) {
      moves.add([oneStepRow, col]);

      // Forward 2 from starting position
      int twoStepRow = row + 2 * direction;
      if ((piece.isWhite && row == 6) || (!piece.isWhite && row == 1)) {
        if (isInBoard(twoStepRow, col) &&
            gameState.board[twoStepRow][col] == null) {
          moves.add([twoStepRow, col]);
        }
      }
    }

    // Capture diagonally left and right
    for (int dx in [-1, 1]) {
      int newRow = row + direction;
      int newCol = col + dx;
      if (isInBoard(newRow, newCol)) {
        final target = gameState.board[newRow][newCol];
        if (target != null && target.isWhite != piece.isWhite) {
          moves.add([newRow, newCol]);
        }
      }
    }

    return moves;
  }

  /// Linear sliding moves used by rook, bishop, queen.
  /// Moves in each direction until blocked or captures.
  List<List<int>> _linearMoves(
    int row,
    int col,
    ChessPiece piece,
    List<List<int>> directions,
  ) {
    List<List<int>> moves = [];

    for (var dir in directions) {
      int r = row + dir[0];
      int c = col + dir[1];

      while (isInBoard(r, c)) {
        final target = gameState.board[r][c];

        if (target == null) {
          moves.add([r, c]);
        } else {
          if (target.isWhite != piece.isWhite) {
            moves.add([r, c]); // Capture
          }
          break; // blocked further movement
        }

        r += dir[0];
        c += dir[1];
      }
    }

    return moves;
  }

  /// Knight moves: 8 possible L-shaped moves.
  List<List<int>> _knightMoves(int row, int col, ChessPiece piece) {
    List<List<int>> moves = [];
    List<List<int>> knightOffsets = [
      [2, 1],
      [2, -1],
      [-2, 1],
      [-2, -1],
      [1, 2],
      [1, -2],
      [-1, 2],
      [-1, -2],
    ];

    for (var offset in knightOffsets) {
      int r = row + offset[0];
      int c = col + offset[1];
      if (isInBoard(r, c)) {
        final target = gameState.board[r][c];
        if (target == null || target.isWhite != piece.isWhite) {
          moves.add([r, c]);
        }
      }
    }

    return moves;
  }

  /// King moves: one step in any direction.
  List<List<int>> _kingMoves(int row, int col, ChessPiece piece) {
    List<List<int>> moves = [];

    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue;

        int r = row + dx;
        int c = col + dy;

        if (isInBoard(r, c)) {
          final target = gameState.board[r][c];
          if (target == null || target.isWhite != piece.isWhite) {
            moves.add([r, c]);
          }
        }
      }
    }

    return moves;
  }
}
