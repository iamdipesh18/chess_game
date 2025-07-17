import 'package:chess_game/services/chess_game_service.dart';
import 'package:flutter/material.dart';
import '../components/square.dart';
import '../components/dead_piece.dart';

class GameBoardView extends StatelessWidget {
  final ChessGameService game;
  final void Function(int row, int col) onTileTap;

  const GameBoardView({Key? key, required this.game, required this.onTileTap})
    : super(key: key);

  Color get _backgroundColor => const Color(0xFF121212);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boardSize = constraints.maxWidth < constraints.maxHeight
                ? constraints.maxWidth
                : constraints.maxHeight * 0.75;

            return Column(
              children: [
                const SizedBox(height: 20),

                // Modern Turn Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_buildTurnIndicator()],
                  ),
                ),

                const SizedBox(height: 20),

                // Chessboard container
                Container(
                  width: boardSize,
                  height: boardSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.brown.shade700.withOpacity(0.8),
                        Colors.brown.shade900,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        offset: const Offset(0, 8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8,
                          ),
                      itemCount: 64,
                      itemBuilder: (context, index) {
                        final row = index ~/ 8;
                        final col = index % 8;

                        final isSelected =
                            game.gameState.selectedRow == row &&
                            game.gameState.selectedCol == col;

                        final isValidMove = game.gameState.validMoves.any(
                          (pos) => pos[0] == row && pos[1] == col,
                        );

                        final isCheckSquare =
                            game.gameState.checkStatus &&
                            ((game.gameState.isWhiteTurn &&
                                    game.gameState.whiteKingPosition[0] ==
                                        row &&
                                    game.gameState.whiteKingPosition[1] ==
                                        col) ||
                                (!game.gameState.isWhiteTurn &&
                                    game.gameState.blackKingPosition[0] ==
                                        row &&
                                    game.gameState.blackKingPosition[1] ==
                                        col));

                        return Square(
                          isWhite: (row + col) % 2 == 0,
                          piece: game.gameState.board[row][col],
                          isSelected: isSelected,
                          isValidMove: isValidMove,
                          isCheckSquare: isCheckSquare,
                          onTap: () => onTileTap(row, col),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Captured pieces container
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _buildCapturedRow(
                        capturedPieces: game.gameState.whitePiecesTaken,
                        isWhite: true,
                      ),
                      const SizedBox(height: 12),
                      _buildCapturedRow(
                        capturedPieces: game.gameState.blackPiecesTaken,
                        isWhite: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTurnIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: game.gameState.isWhiteTurn ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: (game.gameState.isWhiteTurn ? Colors.white : Colors.black)
                .withOpacity(0.6),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            game.gameState.isWhiteTurn ? Icons.circle : Icons.circle_outlined,
            color: game.gameState.isWhiteTurn ? Colors.blueAccent : Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            game.gameState.isWhiteTurn ? "White's Turn ♔" : "Black's Turn ♚",
            style: TextStyle(
              color: game.gameState.isWhiteTurn
                  ? Colors.brown.shade900
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapturedRow({
    required List capturedPieces,
    required bool isWhite,
  }) {
    if (capturedPieces.isEmpty) {
      return SizedBox(
        height: 48,
        child: Center(
          child: Text(
            isWhite ? 'No captured white pieces' : 'No captured black pieces',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: capturedPieces.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final piece = capturedPieces[index];
          return DeadPiece(imagePath: piece.imagePath, isWhite: isWhite);
        },
      ),
    );
  }
}
