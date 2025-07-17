import 'package:chess_game/models/game_state.dart';
import 'package:chess_game/models/chess_piece.dart';
import 'package:chess_game/services/move_generator.dart';
import 'package:chess_game/services/move_validator.dart';
import 'package:chess_game/services/game_state_updater.dart';
import 'package:chess_game/services/check_detector.dart';

/// Facade service that manages chess game logic,
/// coordinates move generation, validation,
/// state updates, and check/checkmate detection.
class ChessGameService {
  final GameState gameState;

  late final MoveGenerator _moveGenerator;
  late final MoveValidator _moveValidator;
  late final GameStateUpdater _gameStateUpdater;
  late final CheckDetector _checkDetector;

  ChessGameService(this.gameState) {
    _moveGenerator = MoveGenerator(gameState);
    _moveValidator = MoveValidator(gameState);
    _gameStateUpdater = GameStateUpdater(gameState);
    _checkDetector = CheckDetector(gameState: gameState, moveGenerator: _moveGenerator);
  }

  /// Initializes the board with the standard chess starting position.
  void initializeBoard() {
    // Clear board first
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        gameState.board[r][c] = null;
      }
    }

// Place pawns
for (int c = 0; c < 8; c++) {
  gameState.board[1][c] = ChessPiece(
    type: ChessPieceType.pawn,
    isWhite: false,
    imagePath: 'assets/pawn_black.png',
  );
  gameState.board[6][c] = ChessPiece(
    type: ChessPieceType.pawn,
    isWhite: true,
    imagePath: 'assets/pawn_white.png',
  );
}

// Place Rooks
gameState.board[0][0] = ChessPiece(
  type: ChessPieceType.rook,
  isWhite: false,
  imagePath: 'assets/rook_black.png',
);
gameState.board[0][7] = ChessPiece(
  type: ChessPieceType.rook,
  isWhite: false,
  imagePath: 'assets/rook_black.png',
);
gameState.board[7][0] = ChessPiece(
  type: ChessPieceType.rook,
  isWhite: true,
  imagePath: 'assets/rook_white.png',
);
gameState.board[7][7] = ChessPiece(
  type: ChessPieceType.rook,
  isWhite: true,
  imagePath: 'assets/rook_white.png',
);

// Place Knights
gameState.board[0][1] = ChessPiece(
  type: ChessPieceType.knight,
  isWhite: false,
  imagePath: 'assets/knight_black.png',
);
gameState.board[0][6] = ChessPiece(
  type: ChessPieceType.knight,
  isWhite: false,
  imagePath: 'assets/knight_black.png',
);
gameState.board[7][1] = ChessPiece(
  type: ChessPieceType.knight,
  isWhite: true,
  imagePath: 'assets/knight_white.png',
);
gameState.board[7][6] = ChessPiece(
  type: ChessPieceType.knight,
  isWhite: true,
  imagePath: 'assets/knight_white.png',
);

// Place Bishops
gameState.board[0][2] = ChessPiece(
  type: ChessPieceType.bishop,
  isWhite: false,
  imagePath: 'assets/bishop_black.png',
);
gameState.board[0][5] = ChessPiece(
  type: ChessPieceType.bishop,
  isWhite: false,
  imagePath: 'assets/bishop_black.png',
);
gameState.board[7][2] = ChessPiece(
  type: ChessPieceType.bishop,
  isWhite: true,
  imagePath: 'assets/bishop_white.png',
);
gameState.board[7][5] = ChessPiece(
  type: ChessPieceType.bishop,
  isWhite: true,
  imagePath: 'assets/bishop_white.png',
);

// Place Queens
gameState.board[0][3] = ChessPiece(
  type: ChessPieceType.queen,
  isWhite: false,
  imagePath: 'assets/queen_black.png',
);
gameState.board[7][3] = ChessPiece(
  type: ChessPieceType.queen,
  isWhite: true,
  imagePath: 'assets/queen_white.png',
);

// Place Kings and set their positions
gameState.board[0][4] = ChessPiece(
  type: ChessPieceType.king,
  isWhite: false,
  imagePath: 'assets/king_black.png',
);
gameState.blackKingPosition = [0, 4];

gameState.board[7][4] = ChessPiece(
  type: ChessPieceType.king,
  isWhite: true,
  imagePath: 'assets/king_white.png',
);
gameState.whiteKingPosition = [7, 4];


    // Reset taken pieces and other states
    _gameStateUpdater.resetGameState();
  }

  /// Returns all raw possible moves for a piece at (row, col).
  /// These moves ignore king safety.
  List<List<int>> generateRawMoves(int row, int col) {
    return _moveGenerator.generateRawValidMoves(row, col);
  }

  /// Returns all legal moves for a piece at (row, col),
  /// filtering out moves that leave own king in check.
  List<List<int>> calculateRealValidMoves(int row, int col) {
    return _moveValidator.calculateLegalMoves(row, col);
  }

  /// Attempts to move the selected piece to (newRow, newCol).
  /// Updates game state accordingly, toggles turn,
  /// and updates check/checkmate status.
  ///
  /// Returns true if the move was successful.
  bool moveSelectedPiece(int newRow, int newCol) {
    final selectedPiece = gameState.selectedPiece;
    if (selectedPiece == null) return false;

    // Check if move is legal
    final legalMoves = calculateRealValidMoves(gameState.selectedRow, gameState.selectedCol);
    bool isMoveLegal = legalMoves.any((move) => move[0] == newRow && move[1] == newCol);
    if (!isMoveLegal) return false;

    // Make the move
    _gameStateUpdater.moveSelectedPiece(newRow, newCol, isCheckmate: false);

    // After move, check for check or checkmate on opponent
    bool opponentIsWhite = !selectedPiece.isWhite;
    bool isCheck = _checkDetector.isKingInCheck(opponentIsWhite);
    bool isCheckmate = false;

    if (isCheck) {
      isCheckmate = _checkDetector.isCheckmate(opponentIsWhite, this);
    }

    // Update check status
    gameState.checkStatus = isCheckmate;

    return true;
  }

  /// Select a piece at (row, col) or move if piece is already selected
  void selectPiece(int row, int col) {
    final selected = gameState.selectedPiece;

    if (selected == null) {
      // Select piece if any on tile and it is current player's turn
      final piece = gameState.board[row][col];
      if (piece != null && piece.isWhite == gameState.isWhiteTurn) {
        gameState.selectedPiece = piece;
        gameState.selectedRow = row;
        gameState.selectedCol = col;

        // Calculate legal moves for this piece
        gameState.validMoves = calculateRealValidMoves(row, col);
      }
    } else {
      // If a piece is already selected, try to move to tapped square
      if (moveSelectedPiece(row, col)) {
        // Move successful, clear selection
        clearSelection();
      } else {
        // If move fails and tapped another piece of current player, select it instead
        final tappedPiece = gameState.board[row][col];
        if (tappedPiece != null && tappedPiece.isWhite == gameState.isWhiteTurn) {
          gameState.selectedPiece = tappedPiece;
          gameState.selectedRow = row;
          gameState.selectedCol = col;
          gameState.validMoves = calculateRealValidMoves(row, col);
        } else {
          // Otherwise clear selection if invalid move tapped
          clearSelection();
        }
      }
    }
  }

  /// Clears the current piece selection and valid moves.
  void clearSelection() {
    _gameStateUpdater.clearSelection();
  }

  /// Resets the entire game state to the initial setup.
  void resetGame() {
    initializeBoard();
  }

  /// Returns true if the player with [isWhite] color is in checkmate.
  bool isCheckmate(bool isWhite) {
    return _checkDetector.isCheckmate(isWhite, this);
  }
}
