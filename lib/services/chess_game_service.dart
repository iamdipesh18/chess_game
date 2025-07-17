import 'package:chess_game/models/chess_piece.dart';
import 'package:chess_game/models/game_state.dart';
import 'package:chess_game/helper/helper_methods.dart';

/// Core chess game logic handler.
/// Contains move validation, board initialization,
/// check and checkmate detection, and piece movement.
class ChessGameService {
  final GameState gameState;

  /// Initialize service with current game state.
  ChessGameService(this.gameState);

  /// Sets up the chess board with pieces in starting positions.
  void initializeBoard() {
    // Create empty 8x8 board filled with null
    List<List<ChessPiece?>> newBoard = List.generate(8, (_) => List.filled(8, null));

    // Place black major pieces on first row
    newBoard[0] = [
      ChessPiece(type: ChessPieceType.rook, isWhite: false, imagePath: "lib/assets/rook_black.png"),
      ChessPiece(type: ChessPieceType.knight, isWhite: false, imagePath: "lib/assets/knight_black.png"),
      ChessPiece(type: ChessPieceType.bishop, isWhite: false, imagePath: "lib/assets/bishop_black.png"),
      ChessPiece(type: ChessPieceType.queen, isWhite: false, imagePath: "lib/assets/queen_black.png"),
      ChessPiece(type: ChessPieceType.king, isWhite: false, imagePath: "lib/assets/king_black.png"),
      ChessPiece(type: ChessPieceType.bishop, isWhite: false, imagePath: "lib/assets/bishop_black.png"),
      ChessPiece(type: ChessPieceType.knight, isWhite: false, imagePath: "lib/assets/knight_black.png"),
      ChessPiece(type: ChessPieceType.rook, isWhite: false, imagePath: "lib/assets/rook_black.png"),
    ];

    // Place black pawns on second row
    newBoard[1] = List.generate(
      8,
      (_) => ChessPiece(type: ChessPieceType.pawn, isWhite: false, imagePath: "lib/assets/pawn_black.png"),
    );

    // Place white major pieces on last row
    newBoard[7] = [
      ChessPiece(type: ChessPieceType.rook, isWhite: true, imagePath: "lib/assets/rook_white.png"),
      ChessPiece(type: ChessPieceType.knight, isWhite: true, imagePath: "lib/assets/knight_white.png"),
      ChessPiece(type: ChessPieceType.bishop, isWhite: true, imagePath: "lib/assets/bishop_white.png"),
      ChessPiece(type: ChessPieceType.queen, isWhite: true, imagePath: "lib/assets/queen_white.png"),
      ChessPiece(type: ChessPieceType.king, isWhite: true, imagePath: "lib/assets/king_white.png"),
      ChessPiece(type: ChessPieceType.bishop, isWhite: true, imagePath: "lib/assets/bishop_white.png"),
      ChessPiece(type: ChessPieceType.knight, isWhite: true, imagePath: "lib/assets/knight_white.png"),
      ChessPiece(type: ChessPieceType.rook, isWhite: true, imagePath: "lib/assets/rook_white.png"),
    ];

    // Place white pawns on second last row
    newBoard[6] = List.generate(
      8,
      (_) => ChessPiece(type: ChessPieceType.pawn, isWhite: true, imagePath: "lib/assets/pawn_white.png"),
    );

    // Update game state board
    gameState.board = newBoard;
  }

  /// Handles selecting a piece or moving the selected piece.
  /// If no piece selected, select the piece if it belongs to current player.
  /// If piece already selected, tries to move to the tapped square if valid.
  void selectPiece(int row, int col) {
    final selected = gameState.selectedPiece;

    if (selected == null) {
      // No piece selected yet - try to select one
      final piece = gameState.board[row][col];
      if (piece != null && piece.isWhite == gameState.isWhiteTurn) {
        // Select piece
        gameState.selectedPiece = piece;
        gameState.selectedRow = row;
        gameState.selectedCol = col;
        // Calculate valid moves for this piece
        gameState.validMoves = calculateRealValidMoves(row, col);
      }
    } else {
      // Piece already selected - try to move
      final validMoves = gameState.validMoves;
      final tappedMove = validMoves.firstWhere(
        (move) => move[0] == row && move[1] == col,
        orElse: () => [],
      );

      if (tappedMove.isNotEmpty) {
        // Move piece to tapped square
        movePiece(row, col);
      } else {
        // Invalid move tapped, deselect piece
        gameState.selectedPiece = null;
        gameState.selectedRow = -1;
        gameState.selectedCol = -1;
        gameState.validMoves.clear();
      }
    }
  }

  /// Returns all possible raw moves for a piece at [row], [col].
  /// Does NOT check for king safety or check conditions.
  List<List<int>> calculateRawValidMoves(int row, int col) {
    ChessPiece? piece = gameState.board[row][col];
    if (piece == null) return [];

    List<List<int>> candidateMoves = [];
    int direction = piece.isWhite ? -1 : 1; // White moves up, black moves down

    switch (piece.type) {
      case ChessPieceType.pawn:
        // Move forward if empty
        if (isInBoard(row + direction, col) && gameState.board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);

          // Allow double step on initial position
          if ((piece.isWhite && row == 6) || (!piece.isWhite && row == 1)) {
            if (gameState.board[row + 2 * direction][col] == null) {
              candidateMoves.add([row + 2 * direction, col]);
            }
          }
        }
        // Capture diagonally
        for (int dx in [-1, 1]) {
          int newRow = row + direction;
          int newCol = col + dx;
          if (isInBoard(newRow, newCol)) {
            final target = gameState.board[newRow][newCol];
            if (target != null && target.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
          }
        }
        break;

      case ChessPieceType.rook:
        // Horizontal and vertical sliding moves
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, 1, 0));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, -1, 0));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, 0, 1));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, 0, -1));
        break;

      case ChessPieceType.bishop:
        // Diagonal sliding moves
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, 1, 1));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, 1, -1));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, -1, 1));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, -1, -1));
        break;

      case ChessPieceType.knight:
        // L-shaped jumps
        List<List<int>> knightMoves = [
          [2, 1], [2, -1], [-2, 1], [-2, -1],
          [1, 2], [1, -2], [-1, 2], [-1, -2]
        ];
        for (var m in knightMoves) {
          int newRow = row + m[0];
          int newCol = col + m[1];
          if (isInBoard(newRow, newCol)) {
            final target = gameState.board[newRow][newCol];
            if (target == null || target.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
          }
        }
        break;

      case ChessPieceType.queen:
        // Queen combines rook and bishop moves
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, 1, 0));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, -1, 0));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, 0, 1));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, 0, -1));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, 1, 1));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, 1, -1));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, -1, 1));
        candidateMoves.addAll(_getMovesInDirection(row, col, piece, -1, -1));
        break;

      case ChessPieceType.king:
        // One step in any direction
        for (int dx = -1; dx <= 1; dx++) {
          for (int dy = -1; dy <= 1; dy++) {
            if (dx == 0 && dy == 0) continue;
            int newRow = row + dx;
            int newCol = col + dy;
            if (isInBoard(newRow, newCol)) {
              final target = gameState.board[newRow][newCol];
              if (target == null || target.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
            }
          }
        }
        break;
    }

    return candidateMoves;
  }

  /// Filters out moves that leave own king in check.
  List<List<int>> calculateRealValidMoves(int row, int col) {
    List<List<int>> realMoves = [];

    for (var move in calculateRawValidMoves(row, col)) {
      int endRow = move[0];
      int endCol = move[1];

      if (simulatedMoveIsSafe(row, col, endRow, endCol)) {
        realMoves.add(move);
      }
    }

    return realMoves;
  }

  /// Moves selected piece to [newRow], [newCol], captures if needed,
  /// updates king positions and toggles turn.
  void movePiece(int newRow, int newCol) {
    final piece = gameState.selectedPiece;
    if (piece == null) return;

    final captured = gameState.board[newRow][newCol];

    // Add captured piece to taken list
    if (captured != null) {
      if (captured.isWhite) {
        gameState.whitePiecesTaken.add(captured);
      } else {
        gameState.blackPiecesTaken.add(captured);
      }
    }

    // Update board
    gameState.board[newRow][newCol] = piece;
    gameState.board[gameState.selectedRow][gameState.selectedCol] = null;

    // Update king position if needed
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        gameState.whiteKingPosition = [newRow, newCol];
      } else {
        gameState.blackKingPosition = [newRow, newCol];
      }
    }

    // Clear selection
    gameState.selectedPiece = null;
    gameState.selectedRow = -1;
    gameState.selectedCol = -1;
    gameState.validMoves.clear();

    // Check if opponent is in checkmate after move
    if (isCheckmate(!gameState.isWhiteTurn)) {
      gameState.checkStatus = true;
    } else {
      gameState.checkStatus = false;
    }

    // Toggle turn
    gameState.isWhiteTurn = !gameState.isWhiteTurn;
  }

  /// Simulates moving a piece and returns true if own king is safe after move.
  bool simulatedMoveIsSafe(int fromRow, int fromCol, int toRow, int toCol) {
    final board = gameState.board;

    final movingPiece = board[fromRow][fromCol];
    final capturedPiece = board[toRow][toCol];

    if (movingPiece == null) return false;

    // Save king position in case it changes (for king moves)
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

    // Check if own king is in check
    bool kingInCheck = isKingInCheck(movingPiece.isWhite);

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

    // Return true if king is safe (not in check)
    return !kingInCheck;
  }

  /// Returns true if king of color [isWhiteKing] is currently in check.
  bool isKingInCheck(bool isWhiteKing) {
    final kingPos = isWhiteKing ? gameState.whiteKingPosition : gameState.blackKingPosition;

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final piece = gameState.board[r][c];
        if (piece == null || piece.isWhite == isWhiteKing) continue;

        // Opponent piece moves
        final moves = calculateRawValidMoves(r, c);
        for (var m in moves) {
          if (m[0] == kingPos[0] && m[1] == kingPos[1]) {
            return true; // King can be captured
          }
        }
      }
    }
    return false;
  }

  /// Returns true if the player with color [isWhiteKing] has no legal moves and king is in check.
bool isCheckmate(bool isWhiteKing) {
  if (!isKingInCheck(isWhiteKing)) return false;

  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      final piece = gameState.board[r][c];
      if (piece == null || piece.isWhite != isWhiteKing) continue;

      if (calculateRealValidMoves(r, c).isNotEmpty) {
        return false; // Player has a valid move
      }
    }
  }

  return true; // No moves available → checkmate
}


  /// Helper function to get sliding moves (used by rook, bishop, queen).
  /// Moves in one direction until blocked or capture.
  List<List<int>> _getMovesInDirection(
    int row,
    int col,
    ChessPiece piece,
    int rowOffset,
    int colOffset,
  ) {
    List<List<int>> moves = [];

    int r = row + rowOffset;
    int c = col + colOffset;

    while (isInBoard(r, c)) {
      final target = gameState.board[r][c];

      if (target == null) {
        moves.add([r, c]);
      } else {
        if (target.isWhite != piece.isWhite) {
          moves.add([r, c]); // Capture opponent
        }
        break; // Stop moving further in this direction
      }

      r += rowOffset;
      c += colOffset;
    }

    return moves;
  }

  /// Resets the game state and re-initializes the board.
  void resetGame() {
    gameState.reset();
    initializeBoard();
  }
}
