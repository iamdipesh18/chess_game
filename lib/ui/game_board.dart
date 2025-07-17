import 'package:chess_game/models/chess_piece.dart';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../services/chess_game_service.dart';
import 'game_board_view.dart';

/// The main GameBoard widget that holds the state and game logic.
/// It uses ChessGameService to handle moves and GameBoardView to render UI.
class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late GameState gameState;
  late ChessGameService gameService;

  @override
  void initState() {
    super.initState();

    // Initialize empty 8x8 board with nulls
    List<List<ChessPiece?>> initialBoard = List.generate(
      8,
      (_) => List.filled(8, null),
    );

    // Create GameState with initial empty board
    gameState = GameState(board: initialBoard);

    // Initialize ChessGameService with gameState
    gameService = ChessGameService(gameState);

    // Set up initial chess pieces on the board
    gameService.initializeBoard();
  }

  /// Handle taps on the chessboard tiles
  void handleTileTap(int row, int col) {
    setState(() {
      // Use gameService to select piece or move if valid
      gameService.selectPiece(row, col);
    });

    // Check if the game is in check status
    if (gameState.checkStatus) {
      // Check if it's checkmate for the current player
      bool isCheckMate = gameService.isCheckmate(!gameState.isWhiteTurn);

      if (isCheckMate) {
        // Show checkmate alert dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('CHECK MATE!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  // Reset the game on Play Again
                  setState(() {
                    gameService.resetGame();
                  });
                },
                child: const Text('Play Again'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameBoardView(gameState: gameState, onTileTap: handleTileTap);
  }
}
