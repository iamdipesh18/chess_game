import 'package:chess_game/models/game_state.dart';
import 'package:chess_game/models/chess_piece.dart';
import 'move_generator.dart';

/// Validates chess moves by filtering out moves that would
/// leave own king in check. Relies on MoveGenerator for raw moves.
class MoveValidator {
  final GameState gameState;
  final MoveGenerator moveGenerator;

  MoveValidator(this.gameState) : moveGenerator = MoveGenerator(gameState);

  /// Returns list of legal moves (row, col) for piece at [row], [col].
  /// Filters out any moves that expose own king to check.
  List<List<int>> calculateLegalMoves(int row, int col) {
    List<List<int>> legalMoves = [];

    // Get all raw moves without considering checks
    List<List<int>> rawMoves = moveGenerator.generateRawValidMoves(row, col);

    // Filter moves by simulating them and checking king safety
    for (var move in rawMoves) {
      int toRow = move[0];
      int toCol = move[1];

      if (_simulatedMoveIsSafe(row, col, toRow, toCol)) {
        legalMoves.add(move);
      }
    }

    return legalMoves;
  }

  /// Simulates a move from (fromRow, fromCol) to (toRow, toCol) and returns
  /// true if own king is safe (not in check) after the move.
  bool _simulatedMoveIsSafe(int fromRow, int fromCol, int toRow, int toCol) {
    final board = gameState.board;
    final movingPiece = board[fromRow][fromCol];
    final capturedPiece = board[toRow][toCol];

    if (movingPiece == null) return false;

    // Save original king position if moving king
    List<int>? originalKingPos;
    if (movingPiece.type == ChessPieceType.king) {
      originalKingPos = movingPiece.isWhite
          ? List.from(gameState.whiteKingPosition)
          : List.from(gameState.blackKingPosition);

      if (movingPiece.isWhite) {
        gameState.whiteKingPosition = [toRow, toCol];
      } else {
        gameState.blackKingPosition = [toRow, toCol];
      }
    }

    // Make the move on the board
    board[toRow][toCol] = movingPiece;
    board[fromRow][fromCol] = null;

    // Check if own king is in check after move
    bool kingSafe = !_isKingInCheck(movingPiece.isWhite);

    // Undo the move
    board[fromRow][fromCol] = movingPiece;
    board[toRow][toCol] = capturedPiece;

    // Restore king position if changed
    if (movingPiece.type == ChessPieceType.king) {
      if (movingPiece.isWhite) {
        gameState.whiteKingPosition = originalKingPos!;
      } else {
        gameState.blackKingPosition = originalKingPos!;
      }
    }

    return kingSafe;
  }

  /// Returns true if the king of color [isWhiteKing] is currently in check.
  bool _isKingInCheck(bool isWhiteKing) {
    final kingPos = isWhiteKing
        ? gameState.whiteKingPosition
        : gameState.blackKingPosition;

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final piece = gameState.board[r][c];
        if (piece == null || piece.isWhite == isWhiteKing) continue;

        // Opponent’s raw moves
        List<List<int>> opponentMoves = moveGenerator.generateRawValidMoves(
          r,
          c,
        );
        for (var m in opponentMoves) {
          if (m[0] == kingPos[0] && m[1] == kingPos[1]) {
            return true; // King can be captured → in check
          }
        }
      }
    }
    return false;
  }
}
