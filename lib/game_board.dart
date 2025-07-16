// ignore_for_file: unnecessary_null_comparison

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

  //seleted piece currently on the chess board
  // if no piece selected then it will be null
  ChessPiece? selectedPiece;
  //keeping track of the row/column of the selected piece
  //Default Value as nothing has been selected
  int selectedRow = -1;
  int selectedCol = -1;

  //A list of valid moves for currently selected piece
  //each move is represented as a list with two elements
  List<List<int>> validMoves = [];

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
      imagePath: "assets/rook.png",
    );

    //place knights
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: "assets/knight.png",
    );
    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: "assets/knight.png",
    );
    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: "assets/knight.png",
    );
    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: "assets/knight.png",
    );

    //place bishops
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: "assets/bishop.png",
    );
    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: "assets/bishop.png",
    );
    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: "assets/bishop.png",
    );
    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: "assets/bishop.png",
    );

    //place queens
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: "assets/queen.png",
    );
    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: "assets/queen.png",
    );

    //place kings
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: "assets/king.png",
    );
    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: "assets/king.png",
    );

    board = newBoard;
  }

  //user selected a piece
  void pieceSelected(int row, int col) {
    setState(() {
      //selected a piece if there is a piece in that position
      if (board[row][col] != null) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
      //if a piece is selected, calculate its valid moves
      validMoves = calculateRawValidMoves(
        selectedRow,
        selectedCol,
        selectedPiece!,
      );
    });
  }

  //Calculate the Raw Valid Moves
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    //Different Directions based on their color
    int direction = piece!.isWhite ? -1 : 1;

    switch (piece.type) {
      // case ChessPieceType.pawn:
      //   //pawns can move forward if the square is not occupied
      //   if (isInBoard(row + direction, col) &&
      //       board[row + direction][col] == null) {
      //     candidateMoves.add([row + direction, col]);
      //   }

      //   //pawns can move 2 squares forward if they are at their initial positions
      //   if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
      //     if (isInBoard(row + 2 * direction, col) &&
      //         board[row + 2 * direction][col] == null &&
      //         board[row + 2 * direction][col] == null) {
      //       candidateMoves.add([row + 2 * direction, col]);
      //     }
      //   }

      //   // pawns can kill diagonally
      //   if (isInBoard(row + direction, col - 1) &&
      //       board[row + direction][col - 1]! == null &&
      //       board[row + direction][col - 1]!.isWhite) {
      //     candidateMoves.add([row + direction, col - 1]);
      //   }
      //   if (isInBoard(row + direction, col + 1) &&
      //       board[row + direction][col + 1]! == null &&
      //       board[row + direction][col + 1]!.isWhite) {
      //     candidateMoves.add([row + direction, col + 1]);
      //   }

      //   break;
      case ChessPieceType.pawn:
        // 1-step forward
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);

          // 2-step forward from initial position
          if ((piece.isWhite && row == 6) || (!piece.isWhite && row == 1)) {
            if (isInBoard(row + 2 * direction, col) &&
                board[row + 2 * direction][col] == null) {
              candidateMoves.add([row + 2 * direction, col]);
            }
          }
        }

        // Capture diagonally left
        if (isInBoard(row + direction, col - 1)) {
          ChessPiece? left = board[row + direction][col - 1];
          if (left != null && left.isWhite != piece.isWhite) {
            candidateMoves.add([row + direction, col - 1]);
          }
        }

        // Capture diagonally right
        if (isInBoard(row + direction, col + 1)) {
          ChessPiece? right = board[row + direction][col + 1];
          if (right != null && right.isWhite != piece.isWhite) {
            candidateMoves.add([row + direction, col + 1]);
          }
        }
        break;

      case ChessPieceType.rook:
        //horizontal and virtical directions
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); //kill
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        //All Eight Possible Lshapes the Knight can Move
        var knightMoves = [
          [-2, -1], //up 2 left 1
          [-2, 1], //up 2 right 1
          [-1, -2], // up 1 left 2
          [-1, 2], // up 1 right 2
          [1, -2], //down 1 left 2
          [1, 2], //down 1 right 2
          [2, -1], //down 2 left 1
          [2, 1], //down 2 right 1
        ];

        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); //capture
            }
            continue; //blocked
          }
          candidateMoves.add([newRow, newCol]);
        }

        break;
      case ChessPieceType.bishop:
        //Diagonal directions
        var directions = [
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];

        for (var direction in directions) {
          var i = 0;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); //capture
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        //All Eight Direction up down left right and 4 diagonalls
        var directions = [
          [-1, 0], //up 2 left 1
          [1, 0], //up 2 right 1
          [0, -1], // up 1 left 2
          [0, 1], // up 1 right 2
          [-1, -1], //down 1 left 2
          [-1, 1], //down 1 right 2
          [1, -1], //down 2 left 1
          [1, 1], //down 2 right 1
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); //capture
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        break;
      default:
    }
    return candidateMoves;
  }

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

          //check if this square is selected or not
          bool isSelected = selectedRow == row && selectedCol == col;

          //check if the square is a valid move or no
          bool isValidMove = false;
          for (var position in validMoves) {
            //compare row and column
            if (position[0] == row && position[1] == col) {
              isValidMove = true;
            }
          }

          return Square(
            isWhite: isWhite(index),
            piece: board[row][col],
            isSelected: isSelected,
            isValidMove: isValidMove,
            onTap: () => pieceSelected(row, col),
          );
        },
      ),
    );
  }
}
