import 'package:chess_game/models/chess_piece.dart';
import 'package:chess_game/models/game_state.dart';

/// Responsible for setting up the initial chessboard state.
/// Places all pieces in their standard starting positions.
class BoardInitializer {
  /// Initializes the chess board inside [gameState].
  /// Sets pieces for both black and white on correct starting squares.
  static void initializeBoard(GameState gameState) {
    // Create empty 8x8 board filled with nulls (no pieces)
    List<List<ChessPiece?>> newBoard = List.generate(8, (_) => List.filled(8, null));

    // Place black major pieces on the first rank (row 0)
    newBoard[0] = [
      ChessPiece(type: ChessPieceType.rook, isWhite: false, imagePath: "assets/rook_black.png"),
      ChessPiece(type: ChessPieceType.knight, isWhite: false, imagePath: "assets/knight_black.png"),
      ChessPiece(type: ChessPieceType.bishop, isWhite: false, imagePath: "assets/bishop_black.png"),
      ChessPiece(type: ChessPieceType.queen, isWhite: false, imagePath: "assets/queen_black.png"),
      ChessPiece(type: ChessPieceType.king, isWhite: false, imagePath: "assets/king_black.png"),
      ChessPiece(type: ChessPieceType.bishop, isWhite: false, imagePath: "assets/bishop_black.png"),
      ChessPiece(type: ChessPieceType.knight, isWhite: false, imagePath: "assets/knight_black.png"),
      ChessPiece(type: ChessPieceType.rook, isWhite: false, imagePath: "assets/rook_black.png"),
    ];

    // Place black pawns on the second rank (row 1)
    newBoard[1] = List.generate(
      8,
      (_) => ChessPiece(type: ChessPieceType.pawn, isWhite: false, imagePath: "assets/pawn_black.png"),
    );

    // Place white major pieces on the eighth rank (row 7)
    newBoard[7] = [
      ChessPiece(type: ChessPieceType.rook, isWhite: true, imagePath: "assets/rook_white.png"),
      ChessPiece(type: ChessPieceType.knight, isWhite: true, imagePath: "assets/knight_white.png"),
      ChessPiece(type: ChessPieceType.bishop, isWhite: true, imagePath: "assets/bishop_white.png"),
      ChessPiece(type: ChessPieceType.queen, isWhite: true, imagePath: "assets/queen_white.png"),
      ChessPiece(type: ChessPieceType.king, isWhite: true, imagePath: "assets/king_white.png"),
      ChessPiece(type: ChessPieceType.bishop, isWhite: true, imagePath: "assets/bishop_white.png"),
      ChessPiece(type: ChessPieceType.knight, isWhite: true, imagePath: "assets/knight_white.png"),
      ChessPiece(type: ChessPieceType.rook, isWhite: true, imagePath: "assets/rook_white.png"),
    ];

    // Place white pawns on the seventh rank (row 6)
    newBoard[6] = List.generate(
      8,
      (_) => ChessPiece(type: ChessPieceType.pawn, isWhite: true, imagePath: "assets/pawn_white.png"),
    );

    // Update the game state's board to the newly initialized board
    gameState.board = newBoard;

    // Reset other state details as well (optional here)
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
