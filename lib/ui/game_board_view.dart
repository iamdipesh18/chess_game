// lib/ui/game_board_view.dart

import 'package:flutter/material.dart';
import '../components/dead_piece.dart';
import '../components/square.dart';
import '../models/game_state.dart';
import '../values/colors.dart';

typedef OnTileTap = void Function(int row, int col);

/// Returns true if the tile at (row, col) should be white color, false for black
bool isWhiteTile(int row, int col) {
  return (row + col) % 2 == 0;
}

/// Pure UI widget that renders the chess board view.
/// Does not hold logic or state — receives everything via props.
class GameBoardView extends StatelessWidget {
  final GameState gameState;
  final OnTileTap onTileTap;

  const GameBoardView({
    Key? key,
    required this.gameState,
    required this.onTileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // White captured pieces (top)
          Expanded(
            child: GridView.builder(
              itemCount: gameState.whitePiecesTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: gameState.whitePiecesTaken[index].imagePath,
                isWhite: true,
              ),
            ),
          ),

          // Check status text
          Text(
            gameState.checkStatus ? "CHECK!" : "",
            style: const TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Main chess board grid
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: 64,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) {
                int row = index ~/ 8;
                int col = index % 8;

                return Square(
                  isWhite: isWhiteTile(row, col),
                  piece: gameState.board[row][col],
                  isSelected:
                      gameState.selectedRow == row &&
                      gameState.selectedCol == col,
                  isValidMove: gameState.validMoves.any(
                    (m) => m[0] == row && m[1] == col,
                  ),
                  onTap: () => onTileTap(row, col),
                );
              },
            ),
          ),

          // Black captured pieces (bottom)
          Expanded(
            child: GridView.builder(
              itemCount: gameState.blackPiecesTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: gameState.blackPiecesTaken[index].imagePath,
                isWhite: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
