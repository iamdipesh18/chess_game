import 'package:chess_game/models/game_state.dart';
import 'package:chess_game/models/chess_piece.dart';

/// Handles all game state updates related to moving pieces,
/// capturing, king position updates, turn toggling,
/// and clearing selections.
class GameStateUpdater {
  final GameState gameState;

  GameStateUpdater(this.gameState);

  /// Moves the currently selected piece to the destination (newRow, newCol).
  /// Handles capturing opponent pieces, updates king positions if needed,
  /// clears the selected piece and valid moves, toggles the turn,
  /// and updates check status.
  void moveSelectedPiece(int newRow, int newCol, {required bool isCheckmate}) {
    final selectedPiece = gameState.selectedPiece;
    if (selectedPiece == null) return;

    final capturedPiece = gameState.board[newRow][newCol];

    // Add captured piece to the appropriate list
    if (capturedPiece != null) {
      if (capturedPiece.isWhite) {
        gameState.whitePiecesTaken.add(capturedPiece);
      } else {
        gameState.blackPiecesTaken.add(capturedPiece);
      }
    }

    // Move piece on the board
    gameState.board[newRow][newCol] = selectedPiece;
    gameState.board[gameState.selectedRow][gameState.selectedCol] = null;

    // Update king's position if the moved piece is a king
    if (selectedPiece.type == ChessPieceType.king) {
      if (selectedPiece.isWhite) {
        gameState.whiteKingPosition = [newRow, newCol];
      } else {
        gameState.blackKingPosition = [newRow, newCol];
      }
    }

    // Clear selection and valid moves
    clearSelection();

    // Update check status
    gameState.checkStatus = isCheckmate;

    // Toggle player turn
    gameState.isWhiteTurn = !gameState.isWhiteTurn;
  }

  /// Clears the currently selected piece and valid moves in game state.
  void clearSelection() {
    gameState.selectedPiece = null;
    gameState.selectedRow = -1;
    gameState.selectedCol = -1;
    gameState.validMoves.clear();
  }

  /// Resets the game state to initial values.
  /// Note: This resets only the data fields; the board itself should be reset by separate logic.
  void resetGameState() {
    gameState.selectedPiece = null;
    gameState.selectedRow = -1;
    gameState.selectedCol = -1;
    gameState.validMoves.clear();
    gameState.blackPiecesTaken.clear();
    gameState.whitePiecesTaken.clear();
    gameState.isWhiteTurn = true;
    gameState.whiteKingPosition = [7, 4];
    gameState.blackKingPosition = [0, 4];
    gameState.checkStatus = false;
  }
}
