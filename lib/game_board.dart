import 'package:chess_game/components/piece.dart';
import 'package:chess_game/components/square.dart';
import 'package:chess_game/helper/helper_methods.dart';
import 'package:chess_game/values/colors.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //A 2-D list representing the chess board with each position possibly containing a chess piece
  late List<List<ChessPiece?>> board;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  //initialize Board
  void _initializeBoard() {
    //initialize the board with nulls, meaning no pieces in those positions
    List<List<ChessPiece?>> newBoard = List.generate(
      8,
      (index) => List.generate(8, (index) => null),
    );
    //place pawns  (we need 8)
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: false,
        imagePath: "assets/pawn.png",
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: "assets/pawn.png",
      );
    }
    //place rooks
    newBoard[0][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "assets/rook.png",
    );
    newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "assets/rook.png",
    );
    newBoard[7][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "assets/rook.png",
    );
    newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "assets/knight.png",
    );
    //place knights
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "assets/knight.png",
    );
    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "assets/knight.png",
    );
    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "assets/knight.png",
    );
    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "assets/knight.png",
    );
    //place bishops
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "assets/bishop.png",
    );
    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "assets/bishop.png",
    );
    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "assets/bishop.png",
    );
    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "assets/bishop.png",
    );
    //place queens
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "assets/queen.png",
    );
    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "assets/queen.png",
    );
    //place kings
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "assets/king.png",
    );
    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "assets/king.png",
    );
    board = newBoard;
  }

  // //create a piece
  // ChessPiece myPawn = ChessPiece(
  //   type: ChessPieceType.pawn,
  //   isWhite: true,
  //   imagePath: 'assets/pawn_white.png',
  // );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GridView.builder(
        itemCount: 8 * 8,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: (context, index) {
          //get the row and column position of this square
          int row = index ~/ 8;
          int col = index % 8;
          return Square(isWhite: isWhite(index), piece: board[row][col]);
        },
      ),
    );
  }
}
