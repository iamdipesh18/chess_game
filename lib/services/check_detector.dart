import 'package:chess_game/models/game_state.dart';
import 'package:chess_game/services/chess_game_service.dart';
import 'package:chess_game/services/move_generator.dart';

/// Service to detect if a king is in check or checkmate.
class CheckDetector {
  final GameState gameState;
  final MoveGenerator moveGenerator;

  /// Requires game state and move generator for threat detection.
  CheckDetector({required this.gameState, required this.moveGenerator});

  /// Returns true if the king of [isWhiteKing] is under threat.
  bool isKingInCheck(bool isWhiteKing) {
    final kingPos = isWhiteKing
        ? gameState.whiteKingPosition
        : gameState.blackKingPosition;

    // Scan all opponent pieces for threats to the king.
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = gameState.board[row][col];

        if (piece == null || piece.isWhite == isWhiteKing) continue;

        final threatMoves = moveGenerator.generateRawValidMoves(row, col);

        for (final move in threatMoves) {
          if (move[0] == kingPos[0] && move[1] == kingPos[1]) {
            return true;
          }
        }
      }
    }

    return false;
  }

  /// Returns true if the player of [isWhiteKing] is in checkmate.
  ///
  /// Depends on legal move generation from ChessGameService.
  bool isCheckmate(bool isWhiteKing, ChessGameService chessService) {
    if (!isKingInCheck(isWhiteKing)) return false;

    // If no piece has any legal moves, it's checkmate.
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = gameState.board[row][col];
        if (piece == null || piece.isWhite != isWhiteKing) continue;

        final legalMoves = chessService.calculateRealValidMoves(row, col);
        if (legalMoves.isNotEmpty) return false;
      }
    }

    return true;
  }
}
