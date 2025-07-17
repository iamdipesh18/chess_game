import 'chess_piece.dart';

class GameState {
  List<List<ChessPiece?>> board;

  ChessPiece? selectedPiece;
  int selectedRow;
  int selectedCol;
  List<List<int>> validMoves;
  List<ChessPiece> blackPiecesTaken;
  List<ChessPiece> whitePiecesTaken;

  bool isWhiteTurn;
  List<int> whiteKingPosition;
  List<int> blackKingPosition;
  bool checkStatus;

  GameState({
    required this.board,
    ChessPiece? selectedPiece,
    int selectedRow = -1,
    int selectedCol = -1,
    List<List<int>>? validMoves,
    List<ChessPiece>? blackPiecesTaken,
    List<ChessPiece>? whitePiecesTaken,
    bool isWhiteTurn = true,
    List<int>? whiteKingPosition,
    List<int>? blackKingPosition,
    bool checkStatus = false,
  })  : selectedPiece = selectedPiece,
        selectedRow = selectedRow,
        selectedCol = selectedCol,
        validMoves = validMoves ?? [],
        blackPiecesTaken = blackPiecesTaken ?? [],
        whitePiecesTaken = whitePiecesTaken ?? [],
        isWhiteTurn = isWhiteTurn,
        whiteKingPosition = whiteKingPosition ?? [7, 4],
        blackKingPosition = blackKingPosition ?? [0, 4],
        checkStatus = checkStatus;

  /// Reset the game state to initial values.
  void reset() {
    selectedPiece = null;
    selectedRow = -1;
    selectedCol = -1;
    validMoves.clear();
    blackPiecesTaken.clear();
    whitePiecesTaken.clear();
    isWhiteTurn = true;
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    checkStatus = false;
  }
}
