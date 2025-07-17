// // ignore_for_file: unnecessary_null_comparison

// import 'package:chess_game/components/dead_piece.dart';
// import 'package:chess_game/components/piece.dart';
// import 'package:chess_game/components/square.dart';
// import 'package:chess_game/helper/helper_methods.dart';
// import 'package:chess_game/values/colors.dart';
// import 'package:flutter/material.dart';

// class GameBoard extends StatefulWidget {
//   const GameBoard({super.key});

//   @override
//   State<GameBoard> createState() => _GameBoardState();
// }

// class _GameBoardState extends State<GameBoard> {
//   //A 2-D list representing the chess board with each position possibly containing a chess piece
//   late List<List<ChessPiece?>> board;

//   @override
//   void initState() {
//     super.initState();
//     _initializeBoard();
//   }

//   //seleted piece currently on the chess board
//   // if no piece selected then it will be null
//   ChessPiece? selectedPiece;
//   //keeping track of the row/column of the selected piece
//   //Default Value as nothing has been selected
//   int selectedRow = -1;
//   int selectedCol = -1;

//   //A list of valid moves for currently selected piece
//   //each move is represented as a list with two elements
//   List<List<int>> validMoves = [];

//   //A list of black pieces that have been taken by white player
// List<ChessPiece> blackPiecesTaken = [];

//   //A list of white pieces that have been taken by black player
// List<ChessPiece> whitePiecesTaken = [];

//   //initialize Board
//   void _initializeBoard() {
//     //initialize the board with nulls, meaning no pieces in those positions
//     List<List<ChessPiece?>> newBoard = List.generate(
//       8,
//       (index) => List.generate(8, (index) => null),
//     );

//     // //place random piece in the middle to test
//     // newBoard[3][3] = ChessPiece(
//     //   type: ChessPieceType.king,
//     //   isWhite: true,
//     //   imagePath: "assets/king.png",
//     // );

//     //place pawns  (we need 8)
//     for (int i = 0; i < 8; i++) {
//       newBoard[1][i] = ChessPiece(
//         type: ChessPieceType.pawn,
//         isWhite: false,
//         imagePath: "assets/pawn.png",
//       );
//       newBoard[6][i] = ChessPiece(
//         type: ChessPieceType.pawn,
//         isWhite: true,
//         imagePath: "assets/pawn.png",
//       );
//     }

//     //place rooks
//     newBoard[0][0] = ChessPiece(
//       type: ChessPieceType.rook,
//       isWhite: false,
//       imagePath: "assets/rook.png",
//     );
//     newBoard[0][7] = ChessPiece(
//       type: ChessPieceType.rook,
//       isWhite: false,
//       imagePath: "assets/rook.png",
//     );
//     newBoard[7][0] = ChessPiece(
//       type: ChessPieceType.rook,
//       isWhite: true,
//       imagePath: "assets/rook.png",
//     );
//     newBoard[7][7] = ChessPiece(
//       type: ChessPieceType.rook,
//       isWhite: true,
//       imagePath: "assets/rook.png",
//     );

//     //place knights
//     newBoard[0][1] = ChessPiece(
//       type: ChessPieceType.knight,
//       isWhite: false,
//       imagePath: "assets/knight.png",
//     );
//     newBoard[0][6] = ChessPiece(
//       type: ChessPieceType.knight,
//       isWhite: false,
//       imagePath: "assets/knight.png",
//     );
//     newBoard[7][1] = ChessPiece(
//       type: ChessPieceType.knight,
//       isWhite: true,
//       imagePath: "assets/knight.png",
//     );
//     newBoard[7][6] = ChessPiece(
//       type: ChessPieceType.knight,
//       isWhite: true,
//       imagePath: "assets/knight.png",
//     );

//     //place bishops
//     newBoard[0][2] = ChessPiece(
//       type: ChessPieceType.bishop,
//       isWhite: false,
//       imagePath: "assets/bishop.png",
//     );
//     newBoard[0][5] = ChessPiece(
//       type: ChessPieceType.bishop,
//       isWhite: false,
//       imagePath: "assets/bishop.png",
//     );
//     newBoard[7][2] = ChessPiece(
//       type: ChessPieceType.bishop,
//       isWhite: true,
//       imagePath: "assets/bishop.png",
//     );
//     newBoard[7][5] = ChessPiece(
//       type: ChessPieceType.bishop,
//       isWhite: true,
//       imagePath: "assets/bishop.png",
//     );

//     //place queens
//     newBoard[0][3] = ChessPiece(
//       type: ChessPieceType.queen,
//       isWhite: false,
//       imagePath: "assets/queen.png",
//     );
//     newBoard[7][4] = ChessPiece(
//       type: ChessPieceType.queen,
//       isWhite: true,
//       imagePath: "assets/queen.png",
//     );

//     //place kings
//     newBoard[0][4] = ChessPiece(
//       type: ChessPieceType.king,
//       isWhite: false,
//       imagePath: "assets/king.png",
//     );
//     newBoard[7][3] = ChessPiece(
//       type: ChessPieceType.king,
//       isWhite: true,
//       imagePath: "assets/king.png",
//     );

//     board = newBoard;
//   }

//   //user selected a piece
//   // void pieceSelected(int row, int col) {
//   //   setState(() {
//   //     //selected a piece if there is a piece in that position
//   //     if (board[row][col] != null) {
//   //       selectedPiece = board[row][col];
//   //       selectedRow = row;
//   //       selectedCol = col;
//   //     }
//   //     //if there is a piece selected and user taps on a square that is a valid move, then move there
//   //     //if a piece is selected, calculate its valid moves
//   //     else if (selectedPiece != null &&
//   //         validMoves.any((element) => element[0] == row && element[1] == col)) {
//   //       movePiece(row, col);
//   //     }
//   //     validMoves = calculateRawValidMoves(
//   //       selectedRow,
//   //       selectedCol,
//   //       selectedPiece!,
//   //     );
//   //   });
//   // }
//   void pieceSelected(int row, int col) {
//     setState(() {
//       //no piece has been selected yet, this is the first selection
//       if (selectedPiece == null && board[row][col] != null) {
//         selectedPiece = board[row][col];
//         selectedRow = row;
//         selectedCol = col;
//       }
//       //there is piece that is already selected , but user can select another one of their pieces
//       else if (board[row][col] != null &&
//           board[row][col]!.isWhite == selectedPiece!.isWhite) {
//         selectedPiece = board[row][col];
//         selectedRow = row;
//         selectedCol = col;
//       }

//       // selecting a piece
//       if (board[row][col] != null) {
//         selectedPiece = board[row][col];
//         selectedRow = row;
//         selectedCol = col;

//         // only calculate valid moves if a piece is actually selected
//         validMoves = calculateRawValidMoves(
//           selectedRow,
//           selectedCol,
//           selectedPiece,
//         );
//       }
//       // moving a selected piece
//       else if (selectedPiece != null &&
//           validMoves.any((element) => element[0] == row && element[1] == col)) {
//         movePiece(row, col);
//       }
//     });
//   }

//   //Calculate the Raw Valid Moves
//   List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
//     List<List<int>> candidateMoves = [];

//     if (piece == null) {
//       return [];
//     }

//     //Different Directions based on their color
//     int direction = piece.isWhite ? -1 : 1;

//     switch (piece.type) {
//       // case ChessPieceType.pawn:
//       //   //pawns can move forward if the square is not occupied
//       //   if (isInBoard(row + direction, col) &&
//       //       board[row + direction][col] == null) {
//       //     candidateMoves.add([row + direction, col]);
//       //   }

//       //   //pawns can move 2 squares forward if they are at their initial positions
//       //   if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
//       //     if (isInBoard(row + 2 * direction, col) &&
//       //         board[row + 2 * direction][col] == null &&
//       //         board[row + 2 * direction][col] == null) {
//       //       candidateMoves.add([row + 2 * direction, col]);
//       //     }
//       //   }

//       //   // pawns can kill diagonally
//       //   if (isInBoard(row + direction, col - 1) &&
//       //       board[row + direction][col - 1]! == null &&
//       //       board[row + direction][col - 1]!.isWhite) {
//       //     candidateMoves.add([row + direction, col - 1]);
//       //   }
//       //   if (isInBoard(row + direction, col + 1) &&
//       //       board[row + direction][col + 1]! == null &&
//       //       board[row + direction][col + 1]!.isWhite) {
//       //     candidateMoves.add([row + direction, col + 1]);
//       //   }

//       //   break;
//       case ChessPieceType.pawn:
//         // 1-step forward
//         if (isInBoard(row + direction, col) &&
//             board[row + direction][col] == null) {
//           candidateMoves.add([row + direction, col]);

//           // 2-step forward from initial position
//           if ((piece.isWhite && row == 6) || (!piece.isWhite && row == 1)) {
//             if (isInBoard(row + 2 * direction, col) &&
//                 board[row + 2 * direction][col] == null) {
//               candidateMoves.add([row + 2 * direction, col]);
//             }
//           }
//         }

//         // Capture diagonally left
//         if (isInBoard(row + direction, col - 1)) {
//           ChessPiece? left = board[row + direction][col - 1];
//           if (left != null && left.isWhite != piece.isWhite) {
//             candidateMoves.add([row + direction, col - 1]);
//           }
//         }

//         // Capture diagonally right
//         if (isInBoard(row + direction, col + 1)) {
//           ChessPiece? right = board[row + direction][col + 1];
//           if (right != null && right.isWhite != piece.isWhite) {
//             candidateMoves.add([row + direction, col + 1]);
//           }
//         }
//         break;

//       case ChessPieceType.rook:
//         //horizontal and virtical directions
//         var directions = [
//           [-1, 0], //up
//           [1, 0], //down
//           [0, -1], //left
//           [0, 1], //right
//         ];

//         for (var direction in directions) {
//           var i = 1;
//           while (true) {
//             var newRow = row + i * direction[0];
//             var newCol = col + i * direction[1];
//             if (!isInBoard(newRow, newCol)) {
//               break;
//             }
//             if (board[newRow][newCol] != null) {
//               if (board[newRow][newCol]!.isWhite != piece.isWhite) {
//                 candidateMoves.add([newRow, newCol]); //kill
//               }
//               break; //blocked
//             }
//             candidateMoves.add([newRow, newCol]);
//             i++;
//           }
//         }
//         break;
//       case ChessPieceType.knight:
//         //All Eight Possible Lshapes the Knight can Move
//         var knightMoves = [
//           [-2, -1], //up 2 left 1
//           [-2, 1], //up 2 right 1
//           [-1, -2], // up 1 left 2
//           [-1, 2], // up 1 right 2
//           [1, -2], //down 1 left 2
//           [1, 2], //down 1 right 2
//           [2, -1], //down 2 left 1
//           [2, 1], //down 2 right 1
//         ];

//         for (var move in knightMoves) {
//           var newRow = row + move[0];
//           var newCol = col + move[1];
//           if (!isInBoard(newRow, newCol)) {
//             continue;
//           }
//           if (board[newRow][newCol] != null) {
//             if (board[newRow][newCol]!.isWhite != piece.isWhite) {
//               candidateMoves.add([newRow, newCol]); //capture
//             }
//             continue; //blocked
//           }
//           candidateMoves.add([newRow, newCol]);
//         }

//         break;
//       case ChessPieceType.bishop:
//         //Diagonal directions
//         var directions = [
//           [-1, -1], //up left
//           [-1, 1], //up right
//           [1, -1], //down left
//           [1, 1], //down right
//         ];

//         for (var direction in directions) {
//           var i = 1;
//           while (true) {
//             var newRow = row + i * direction[0];
//             var newCol = col + i * direction[1];
//             if (!isInBoard(newRow, newCol)) {
//               break;
//             }
//             if (board[newRow][newCol] != null) {
//               if (board[newRow][newCol]!.isWhite != piece.isWhite) {
//                 candidateMoves.add([newRow, newCol]); //capture
//               }
//               break; //blocked
//             }
//             candidateMoves.add([newRow, newCol]);
//             i++;
//           }
//         }
//         break;
//       case ChessPieceType.queen:
//         //All Eight Direction up down left right and 4 diagonalls
//         var directions = [
//           [-1, 0], //up 2 left 1
//           [1, 0], //up 2 right 1
//           [0, -1], // up 1 left 2
//           [0, 1], // up 1 right 2
//           [-1, -1], //down 1 left 2
//           [-1, 1], //down 1 right 2
//           [1, -1], //down 2 left 1
//           [1, 1], //down 2 right 1
//         ];

//         for (var direction in directions) {
//           var i = 1;
//           while (true) {
//             var newRow = row + i * direction[0];
//             var newCol = col + i * direction[1];
//             if (!isInBoard(newRow, newCol)) {
//               break;
//             }
//             if (board[newRow][newCol] != null) {
//               if (board[newRow][newCol]!.isWhite != piece.isWhite) {
//                 candidateMoves.add([newRow, newCol]); //capture
//               }
//               break; //blocked
//             }
//             candidateMoves.add([newRow, newCol]);
//             i++;
//           }
//         }
//         break;
//       // case ChessPieceType.king:
//       //All Eight Direction up down left right and 4 diagonalls
//       // var directions = [
//       //   [-1, 0], //up 2 left 1
//       //   [1, 0], //up 2 right 1
//       //   [0, -1], // up 1 left 2
//       //   [0, 1], // up 1 right 2
//       //   [-1, -1], //down 1 left 2
//       //   [-1, 1], //down 1 right 2
//       //   [1, -1], //down 2 left 1
//       //   [1, 1], //down 2 right 1
//       // ];
//       // for (var direction in directions) {
//       //   while (true) {
//       //     var newRow = row + direction[0];
//       //     var newCol = col + direction[1];
//       //     if (!isInBoard(newRow, newCol)) {
//       //       continue;
//       //     }
//       //     if (board[newRow][newCol] != null) {
//       //       if (board[newRow][newCol]!.isWhite != piece.isWhite) {
//       //         candidateMoves.add([newRow, newCol]); //capture
//       //       }
//       //       break; //blocked
//       //     }
//       //     candidateMoves.add([newRow, newCol]);
//       //   }
//       // }
//       case ChessPieceType.king:
//         // One-step in all directions
//         var directions = [
//           [-1, 0],
//           [1, 0],
//           [0, -1],
//           [0, 1],
//           [-1, -1],
//           [-1, 1],
//           [1, -1],
//           [1, 1],
//         ];

//         for (var direction in directions) {
//           var newRow = row + direction[0];
//           var newCol = col + direction[1];
//           if (!isInBoard(newRow, newCol)) continue;

//           if (board[newRow][newCol] != null) {
//             if (board[newRow][newCol]!.isWhite != piece.isWhite) {
//               candidateMoves.add([newRow, newCol]); // capture
//             }
//           } else {
//             candidateMoves.add([newRow, newCol]);
//           }
//         }
//         break;
//     }
//     return candidateMoves;
//   }

//   //move piece
//   void movePiece(int newRow, int newCol) {
//     // if the new spot has an enemy piece
//     if (board[newRow][newCol] != null) {
//       //add the captured piece to the appropriate list
//       var capturedPiece = board[newRow][newCol];
//       if (capturedPiece!.isWhite) {
//         whitePiecesTaken.add(capturedPiece);
//       } else {
//         blackPiecesTaken.add(capturedPiece);
//       }
//     }
//     //move the piece and clear the old spot
//     board[newRow][newCol] = selectedPiece;
//     board[selectedRow][selectedCol] = null;

//     //clear selection
//     setState(() {
//       selectedPiece = null;
//       selectedRow = -1;
//       selectedCol = -1;
//       validMoves = [];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Column(
//         children: [
//           // white pieces taken
//           Expanded(
//             child: GridView.builder(
//               itemCount: whitePiecesTaken.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemBuilder: (context, index) => DeadPiece(
//                 imagePath: whitePiecesTaken[index].imagePath,
//                 isWhite: true,
//               ),
//             ),
//           ),

//           // chess board (main content)
//           Expanded(
//             flex: 3,
//             child: GridView.builder(
//               itemCount: 8 * 8,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemBuilder: (context, index) {
//                 int row = index ~/ 8;
//                 int col = index % 8;

//                 bool isSelected = selectedRow == row && selectedCol == col;

//                 bool isValidMove = validMoves.any(
//                   (position) => position[0] == row && position[1] == col,
//                 );

//                 return Square(
//                   isWhite: isWhite(index),
//                   piece: board[row][col],
//                   isSelected: isSelected,
//                   isValidMove: isValidMove,
//                   onTap: () => pieceSelected(row, col),
//                 );
//               },
//             ),
//           ),

//           // black pieces taken
//           Expanded(
//             child: GridView.builder(
//               itemCount: blackPiecesTaken.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemBuilder: (context, index) => DeadPiece(
//                 imagePath: blackPiecesTaken[index].imagePath,
//                 isWhite: false,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// ignore_for_file: unnecessary_null_comparison, duplicate_ignore

// import 'package:chess_game/components/dead_piece.dart';
// import 'package:chess_game/components/piece.dart';
// import 'package:chess_game/components/square.dart';
// import 'package:chess_game/helper/helper_methods.dart';
// import 'package:chess_game/values/colors.dart';
// import 'package:flutter/material.dart';

// class GameBoard extends StatefulWidget {
//   const GameBoard({super.key});

//   @override
//   State<GameBoard> createState() => _GameBoardState();
// }

// class _GameBoardState extends State<GameBoard> {
//   late List<List<ChessPiece?>> board;

//   ChessPiece? selectedPiece;
//   int selectedRow = -1;
//   int selectedCol = -1;
//   List<List<int>> validMoves = [];
//   List<ChessPiece> blackPiecesTaken = [];
//   List<ChessPiece> whitePiecesTaken = [];

//   //A Boolean to indicate whos turn it is
//   bool isWhiteTurn = true;

//   //initial position of the kings to keep track for making easy to see if king is in check or not
//   List<int> whiteKingPosition = [7, 4];
//   List<int> blackKingPosition = [0, 4];
//   bool checkStatus = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeBoard();
//   }

//   // Initializes the chess board with all the pieces in their default position
//   void _initializeBoard() {
//     List<List<ChessPiece?>> newBoard = List.generate(
//       8,
//       (index) => List.generate(8, (index) => null),
//     );

//     // Place pawns
//     for (int i = 0; i < 8; i++) {
//       newBoard[1][i] = ChessPiece(
//         type: ChessPieceType.pawn,
//         isWhite: false,
//         imagePath: "assets/pawn.png",
//       );
//       newBoard[6][i] = ChessPiece(
//         type: ChessPieceType.pawn,
//         isWhite: true,
//         imagePath: "assets/pawn.png",
//       );
//     }

//     // Place rooks
//     newBoard[0][0] = newBoard[0][7] = ChessPiece(
//       type: ChessPieceType.rook,
//       isWhite: false,
//       imagePath: "assets/rook.png",
//     );
//     newBoard[7][0] = newBoard[7][7] = ChessPiece(
//       type: ChessPieceType.rook,
//       isWhite: true,
//       imagePath: "assets/rook.png",
//     );

//     // Place knights
//     newBoard[0][1] = newBoard[0][6] = ChessPiece(
//       type: ChessPieceType.knight,
//       isWhite: false,
//       imagePath: "assets/knight.png",
//     );
//     newBoard[7][1] = newBoard[7][6] = ChessPiece(
//       type: ChessPieceType.knight,
//       isWhite: true,
//       imagePath: "assets/knight.png",
//     );

//     // Place bishops
//     newBoard[0][2] = newBoard[0][5] = ChessPiece(
//       type: ChessPieceType.bishop,
//       isWhite: false,
//       imagePath: "assets/bishop.png",
//     );
//     newBoard[7][2] = newBoard[7][5] = ChessPiece(
//       type: ChessPieceType.bishop,
//       isWhite: true,
//       imagePath: "assets/bishop.png",
//     );

//     // Place queens
//     newBoard[0][3] = ChessPiece(
//       type: ChessPieceType.queen,
//       isWhite: false,
//       imagePath: "assets/queen.png",
//     );
//     newBoard[7][4] = ChessPiece(
//       type: ChessPieceType.queen,
//       isWhite: true,
//       imagePath: "assets/queen.png",
//     );

//     // Place kings
//     newBoard[0][4] = ChessPiece(
//       type: ChessPieceType.king,
//       isWhite: false,
//       imagePath: "assets/king.png",
//     );
//     newBoard[7][3] = ChessPiece(
//       type: ChessPieceType.king,
//       isWhite: true,
//       imagePath: "assets/king.png",
//     );

//     board = newBoard;
//   }

//   // Handles selection and movement of pieces
//   void pieceSelected(int row, int col) {
//     //see if any king are under attack
//     if (isKingInCheck(!isWhiteTurn)) {
//       checkStatus = true;
//     } else {
//       checkStatus = false;
//     }

//     setState(() {
//       // Selecting a new piece
//       if (board[row][col] != null &&
//           (selectedPiece == null ||
//               board[row][col]!.isWhite == selectedPiece!.isWhite)) {
//         if (board[row][col]!.isWhite == isWhiteTurn) {
//           selectedPiece = board[row][col];
//           selectedRow = row;
//           selectedCol = col;
//           validMoves = calculateRawValidMoves(row, col, selectedPiece);
//         }
//         return;
//       }

//       // Moving to a valid position
//       if (selectedPiece != null &&
//           validMoves.any((move) => move[0] == row && move[1] == col)) {
//         movePiece(row, col);
//       }
//     });
//   }

//   // Move the selected piece to a new location and handle capturing
//   void movePiece(int newRow, int newCol) {
//     if (board[newRow][newCol] != null) {
//       var captured = board[newRow][newCol]!;
//       if (captured.isWhite) {
//         whitePiecesTaken.add(captured);
//       } else {
//         blackPiecesTaken.add(captured);
//       }
//     }

//     board[newRow][newCol] = selectedPiece;
//     board[selectedRow][selectedCol] = null;

//     setState(() {
//       selectedPiece = null;
//       selectedRow = -1;
//       selectedCol = -1;
//       validMoves = [];
//     });
//     //change turns
//     isWhiteTurn = !isWhiteTurn;
//   }

//   // Calculates potential moves for a given piece
//   List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
//     if (piece == null) return [];

//     List<List<int>> moves = [];
//     int dir = piece.isWhite ? -1 : 1;

//     switch (piece.type) {
//       case ChessPieceType.pawn:
//         // Move forward
//         if (isInBoard(row + dir, col) && board[row + dir][col] == null) {
//           moves.add([row + dir, col]);
//           if ((piece.isWhite && row == 6) || (!piece.isWhite && row == 1)) {
//             if (board[row + 2 * dir][col] == null) {
//               moves.add([row + 2 * dir, col]);
//             }
//           }
//         }
//         // Captures
//         for (var dc in [-1, 1]) {
//           int newRow = row + dir;
//           int newCol = col + dc;
//           if (isInBoard(newRow, newCol) &&
//               board[newRow][newCol]?.isWhite != piece.isWhite &&
//               board[newRow][newCol] != null) {
//             moves.add([newRow, newCol]);
//           }
//         }
//         break;

//       case ChessPieceType.rook:
//         moves.addAll(
//           slideMoves(row, col, piece, [
//             [-1, 0],
//             [1, 0],
//             [0, -1],
//             [0, 1],
//           ]),
//         );
//         break;

//       case ChessPieceType.knight:
//         var steps = [
//           [-2, -1],
//           [-2, 1],
//           [-1, -2],
//           [-1, 2],
//           [1, -2],
//           [1, 2],
//           [2, -1],
//           [2, 1],
//         ];
//         for (var s in steps) {
//           int r = row + s[0], c = col + s[1];
//           if (!isInBoard(r, c)) continue;
//           if (board[r][c] == null || board[r][c]!.isWhite != piece.isWhite) {
//             moves.add([r, c]);
//           }
//         }
//         break;

//       case ChessPieceType.bishop:
//         moves.addAll(
//           slideMoves(row, col, piece, [
//             [-1, -1],
//             [-1, 1],
//             [1, -1],
//             [1, 1],
//           ]),
//         );
//         break;

//       case ChessPieceType.queen:
//         moves.addAll(
//           slideMoves(row, col, piece, [
//             [-1, 0],
//             [1, 0],
//             [0, -1],
//             [0, 1],
//             [-1, -1],
//             [-1, 1],
//             [1, -1],
//             [1, 1],
//           ]),
//         );
//         break;

//       case ChessPieceType.king:
//         for (var d in [
//           [-1, 0],
//           [1, 0],
//           [0, -1],
//           [0, 1],
//           [-1, -1],
//           [-1, 1],
//           [1, -1],
//           [1, 1],
//         ]) {
//           int r = row + d[0], c = col + d[1];
//           if (!isInBoard(r, c)) continue;
//           if (board[r][c] == null || board[r][c]!.isWhite != piece.isWhite) {
//             moves.add([r, c]);
//           }
//         }
//         break;
//     }
//     return moves;
//   }

//   // Shared logic for sliding pieces like rook, bishop, and queen
//   List<List<int>> slideMoves(
//     int row,
//     int col,
//     ChessPiece piece,
//     List<List<int>> directions,
//   ) {
//     List<List<int>> moves = [];
//     for (var d in directions) {
//       int i = 1;
//       while (true) {
//         int r = row + i * d[0];
//         int c = col + i * d[1];
//         if (!isInBoard(r, c)) break;
//         if (board[r][c] != null) {
//           if (board[r][c]!.isWhite != piece.isWhite) moves.add([r, c]);
//           break;
//         }
//         moves.add([r, c]);
//         i++;
//       }
//     }
//     return moves;
//   }

//   // is king in check
//   bool isKingInCheck(bool isWhiteKing) {
//     //get the position of the king
//     List<int> kingPosition = isWhiteKing
//         ? whiteKingPosition
//         : blackKingPosition;
//     //check if any enemy piece can attack the king
//     for (int i = 0; i < 8; i++) {
//       for (int j = 0; j < 8; j++) {
//         //skip empty squares and pieces of the same color as the king
//         if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
//           continue;
//         }
//         List<List<int>> pieceValidMoves = calculateRawValidMoves(
//           i,
//           j,
//           board[i][j],
//         );

//         //check if the kking's position is in this piece's valid moves
//         if (pieceValidMoves.any(
//           (move) => move[0] == kingPosition[0] && move[1] == kingPosition[1],
//         )) {
//           return true;
//         }
//       }
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Column(
//         children: [
//           // Display white's captured pieces
//           Expanded(
//             child: GridView.builder(
//               itemCount: whitePiecesTaken.length,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemBuilder: (context, index) => DeadPiece(
//                 imagePath: whitePiecesTaken[index].imagePath,
//                 isWhite: true,
//               ),
//             ),
//           ),
//           //Game Status
//           Text(checkStatus?"CHECK!":""),

//           // Main chessboard grid
//           Expanded(
//             flex: 3,
//             child: GridView.builder(
//               itemCount: 64,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemBuilder: (context, index) {
//                 int row = index ~/ 8;
//                 int col = index % 8;

//                 return Square(
//                   isWhite: isWhite(index),
//                   piece: board[row][col],
//                   isSelected: selectedRow == row && selectedCol == col,
//                   isValidMove: validMoves.any(
//                     (m) => m[0] == row && m[1] == col,
//                   ),
//                   onTap: () => pieceSelected(row, col),
//                 );
//               },
//             ),
//           ),

//           // Display black's captured pieces
//           Expanded(
//             child: GridView.builder(
//               itemCount: blackPiecesTaken.length,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemBuilder: (context, index) => DeadPiece(
//                 imagePath: blackPiecesTaken[index].imagePath,
//                 isWhite: false,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// ignore_for_file: unnecessary_null_comparison

// import 'package:chess_game/components/dead_piece.dart';
// import 'package:chess_game/components/piece.dart';
// import 'package:chess_game/components/square.dart';
// import 'package:chess_game/helper/helper_methods.dart';
// import 'package:chess_game/values/colors.dart';
// import 'package:flutter/material.dart';

// class GameBoard extends StatefulWidget {
//   const GameBoard({super.key});

//   @override
//   State<GameBoard> createState() => _GameBoardState();
// }

// class _GameBoardState extends State<GameBoard> {
//   late List<List<ChessPiece?>> board;

//   ChessPiece? selectedPiece;
//   int selectedRow = -1;
//   int selectedCol = -1;
//   List<List<int>> validMoves = [];
//   List<ChessPiece> blackPiecesTaken = [];
//   List<ChessPiece> whitePiecesTaken = [];

//   // Track whose turn it is
//   bool isWhiteTurn = true;

//   // King positions for check detection
//   List<int> whiteKingPosition = [7, 4];
//   List<int> blackKingPosition = [0, 4];
//   bool checkStatus = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeBoard();
//   }

//   // Initializes board with pieces at default positions
//   void _initializeBoard() {
//     List<List<ChessPiece?>> newBoard = List.generate(
//       8,
//       (index) => List.generate(8, (index) => null),
//     );

//     // Pawns
//     for (int i = 0; i < 8; i++) {
//       newBoard[1][i] = ChessPiece(
//         type: ChessPieceType.pawn,
//         isWhite: false,
//         imagePath: "assets/pawn.png",
//       );
//       newBoard[6][i] = ChessPiece(
//         type: ChessPieceType.pawn,
//         isWhite: true,
//         imagePath: "assets/pawn.png",
//       );
//     }

//     // Rooks
//     newBoard[0][0] = newBoard[0][7] = ChessPiece(
//       type: ChessPieceType.rook,
//       isWhite: false,
//       imagePath: "assets/rook.png",
//     );
//     newBoard[7][0] = newBoard[7][7] = ChessPiece(
//       type: ChessPieceType.rook,
//       isWhite: true,
//       imagePath: "assets/rook.png",
//     );

//     // Knights
//     newBoard[0][1] = newBoard[0][6] = ChessPiece(
//       type: ChessPieceType.knight,
//       isWhite: false,
//       imagePath: "assets/knight.png",
//     );
//     newBoard[7][1] = newBoard[7][6] = ChessPiece(
//       type: ChessPieceType.knight,
//       isWhite: true,
//       imagePath: "assets/knight.png",
//     );

//     // Bishops
//     newBoard[0][2] = newBoard[0][5] = ChessPiece(
//       type: ChessPieceType.bishop,
//       isWhite: false,
//       imagePath: "assets/bishop.png",
//     );
//     newBoard[7][2] = newBoard[7][5] = ChessPiece(
//       type: ChessPieceType.bishop,
//       isWhite: true,
//       imagePath: "assets/bishop.png",
//     );

//     // Queens
//     newBoard[0][3] = ChessPiece(
//       type: ChessPieceType.queen,
//       isWhite: false,
//       imagePath: "assets/queen.png",
//     );
//     newBoard[7][3] = ChessPiece(
//       type: ChessPieceType.queen,
//       isWhite: true,
//       imagePath: "assets/queen.png",
//     );

//     // Kings
//     newBoard[0][4] = ChessPiece(
//       type: ChessPieceType.king,
//       isWhite: false,
//       imagePath: "assets/king.png",
//     );
//     newBoard[7][4] = ChessPiece(
//       type: ChessPieceType.king,
//       isWhite: true,
//       imagePath: "assets/king.png",
//     );

//     board = newBoard;
//   }

//   // Handles selection and movement of pieces
//   void pieceSelected(int row, int col) {
//     // Check if the current player's king is in check
//     if (isKingInCheck(!isWhiteTurn)) {
//       checkStatus = true;
//     } else {
//       checkStatus = false;
//     }

//     setState(() {
//       // Selecting a new piece
//       if (board[row][col] != null &&
//           (selectedPiece == null ||
//               board[row][col]!.isWhite == selectedPiece!.isWhite)) {
//         if (board[row][col]!.isWhite == isWhiteTurn) {
//           selectedPiece = board[row][col];
//           selectedRow = row;
//           selectedCol = col;
//           validMoves = calculateRawValidMoves(row, col, selectedPiece);
//         }
//         return;
//       }

//       // Moving to a valid position
//       if (selectedPiece != null &&
//           validMoves.any((move) => move[0] == row && move[1] == col)) {
//         movePiece(row, col);
//       }
//     });
//   }

//   // Calculate Real Valid Moves
//   List<List<int>> calculateRealValidMoves(
//     int row,
//     int col,
//     ChessPiece? piece,
//     bool checkSimulation,
//   ) {
//     List<List<int>> realValidMoves = [];
//     List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);
//     //after generating all candidaate moves , filter out any that would result in a check
//     if (checkSimulation) {
//       for (var move in candidateMoves) {
//         int endRow = move[0];
//         int endCol = move[1];

//         //this will simulate the futue move to see if it's safe
//         if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
//           realValidMoves.add(move);
//         }
//       }
//     } else {
//       realValidMoves = candidateMoves;
//     }
//     return realValidMoves;
//   }

//   // Move selected piece and handle captures
//   void movePiece(int newRow, int newCol) {
//     if (board[newRow][newCol] != null) {
//       var captured = board[newRow][newCol]!;
//       if (captured.isWhite) {
//         whitePiecesTaken.add(captured);
//       } else {
//         blackPiecesTaken.add(captured);
//       }
//     }
//     //check if the piece being moved is a king

//     board[newRow][newCol] = selectedPiece;
//     board[selectedRow][selectedCol] = null;

//     // Update king position if the king moved
//     if (selectedPiece!.type == ChessPieceType.king) {
//       if (selectedPiece!.isWhite) {
//         whiteKingPosition = [newRow, newCol];
//       } else {
//         blackKingPosition = [newRow, newCol];
//       }
//     }

//     setState(() {
//       selectedPiece = null;
//       selectedRow = -1;
//       selectedCol = -1;
//       validMoves = [];
//     });

//     // Change turns
//     isWhiteTurn = !isWhiteTurn;
//   }

//   // Returns basic raw valid moves (does not consider checks yet)
//   List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
//     if (piece == null) return [];

//     List<List<int>> moves = [];
//     int dir = piece.isWhite ? -1 : 1;

//     switch (piece.type) {
//       case ChessPieceType.pawn:
//         if (isInBoard(row + dir, col) && board[row + dir][col] == null) {
//           moves.add([row + dir, col]);
//           if ((piece.isWhite && row == 6) || (!piece.isWhite && row == 1)) {
//             if (board[row + 2 * dir][col] == null) {
//               moves.add([row + 2 * dir, col]);
//             }
//           }
//         }
//         for (var dc in [-1, 1]) {
//           int newRow = row + dir;
//           int newCol = col + dc;
//           if (isInBoard(newRow, newCol) &&
//               board[newRow][newCol]?.isWhite != piece.isWhite &&
//               board[newRow][newCol] != null) {
//             moves.add([newRow, newCol]);
//           }
//         }
//         break;

//       case ChessPieceType.rook:
//         moves.addAll(
//           slideMoves(row, col, piece, [
//             [-1, 0],
//             [1, 0],
//             [0, -1],
//             [0, 1],
//           ]),
//         );
//         break;

//       case ChessPieceType.knight:
//         var steps = [
//           [-2, -1],
//           [-2, 1],
//           [-1, -2],
//           [-1, 2],
//           [1, -2],
//           [1, 2],
//           [2, -1],
//           [2, 1],
//         ];
//         for (var s in steps) {
//           int r = row + s[0], c = col + s[1];
//           if (!isInBoard(r, c)) continue;
//           if (board[r][c] == null || board[r][c]!.isWhite != piece.isWhite) {
//             moves.add([r, c]);
//           }
//         }
//         break;

//       case ChessPieceType.bishop:
//         moves.addAll(
//           slideMoves(row, col, piece, [
//             [-1, -1],
//             [-1, 1],
//             [1, -1],
//             [1, 1],
//           ]),
//         );
//         break;

//       case ChessPieceType.queen:
//         moves.addAll(
//           slideMoves(row, col, piece, [
//             [-1, 0],
//             [1, 0],
//             [0, -1],
//             [0, 1],
//             [-1, -1],
//             [-1, 1],
//             [1, -1],
//             [1, 1],
//           ]),
//         );
//         break;

//       case ChessPieceType.king:
//         for (var d in [
//           [-1, 0],
//           [1, 0],
//           [0, -1],
//           [0, 1],
//           [-1, -1],
//           [-1, 1],
//           [1, -1],
//           [1, 1],
//         ]) {
//           int r = row + d[0], c = col + d[1];
//           if (!isInBoard(r, c)) continue;
//           if (board[r][c] == null || board[r][c]!.isWhite != piece.isWhite) {
//             moves.add([r, c]);
//           }
//         }
//         break;
//     }
//     return moves;
//   }

//   // Reusable logic for sliding pieces (rook, bishop, queen)
//   List<List<int>> slideMoves(
//     int row,
//     int col,
//     ChessPiece piece,
//     List<List<int>> directions,
//   ) {
//     List<List<int>> moves = [];
//     for (var d in directions) {
//       int i = 1;
//       while (true) {
//         int r = row + i * d[0];
//         int c = col + i * d[1];
//         if (!isInBoard(r, c)) break;
//         if (board[r][c] != null) {
//           if (board[r][c]!.isWhite != piece.isWhite) moves.add([r, c]);
//           break;
//         }
//         moves.add([r, c]);
//         i++;
//       }
//     }
//     return moves;
//   }

//   // Detects whether a king is in check
//   bool isKingInCheck(bool isWhiteKing) {
//     List<int> kingPos = isWhiteKing ? whiteKingPosition : blackKingPosition;
//     for (int i = 0; i < 8; i++) {
//       for (int j = 0; j < 8; j++) {
//         if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
//           continue;
//         }
//         List<List<int>> moves = calculateRawValidMoves(i, j, board[i][j]);
//         if (moves.any((m) => m[0] == kingPos[0] && m[1] == kingPos[1])) {
//           return true;
//         }
//       }
//     }
//     return false;
//   }

//   //Simulate the future move to see if its safe (Doesn't put our own king under attack)
//   bool simulatedMoveIsSafe(
//     ChessPiece piece,
//     int startRow,
//     int startCol,
//     int endRow,
//     int endCol,
//   ) {
//     //save the current board state
//     ChessPiece? originalDestinationPiece = board[endRow][endCol];

//     //if the piece is the king, save it's current position and update the new one
//     List<int>? originalKingPosition;
//     if (piece.type == ChessPieceType.king) {
//       originalKingPosition = piece.isWhite
//           ? whiteKingPosition
//           : blackKingPosition;
//       //update the king's position
//       if (piece.isWhite) {
//         whiteKingPosition = [endRow, endCol];
//       } else {
//         blackKingPosition = [endRow, endCol];
//       }
//     }

//     //simulate the move
//     board[endRow][endCol] = piece;
//     board[startRow][startCol] = null;

//     //check if our own kin is under attack
//     bool kingInCheck = isKingInCheck(piece.isWhite);

//     //restore board to original state
//     board[endRow][endCol] = piece;
//     board[startRow][startCol] = originalDestinationPiece;

//     //if the piece was the king , restore its original position
//     if (piece.type == ChessPieceType.king) {
//       if (piece.isWhite) {
//         whiteKingPosition = originalKingPosition!;
//       } else {
//         blackKingPosition = originalKingPosition!;
//       }
//     }
//     //if the king is in check then it is not safe
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Column(
//         children: [
//           // White captured pieces
//           Expanded(
//             child: GridView.builder(
//               itemCount: whitePiecesTaken.length,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemBuilder: (context, index) => DeadPiece(
//                 imagePath: whitePiecesTaken[index].imagePath,
//                 isWhite: true,
//               ),
//             ),
//           ),

//           // Check Status Text
//           Text(
//             checkStatus ? "CHECK!" : "",
//             style: TextStyle(
//               color: Colors.red,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),

//           // Main board
//           Expanded(
//             flex: 3,
//             child: GridView.builder(
//               itemCount: 64,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemBuilder: (context, index) {
//                 int row = index ~/ 8;
//                 int col = index % 8;
//                 return Square(
//                   isWhite: isWhite(index),
//                   piece: board[row][col],
//                   isSelected: selectedRow == row && selectedCol == col,
//                   isValidMove: validMoves.any(
//                     (m) => m[0] == row && m[1] == col,
//                   ),
//                   onTap: () => pieceSelected(row, col),
//                 );
//               },
//             ),
//           ),

//           // Black captured pieces
//           Expanded(
//             child: GridView.builder(
//               itemCount: blackPiecesTaken.length,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemBuilder: (context, index) => DeadPiece(
//                 imagePath: blackPiecesTaken[index].imagePath,
//                 isWhite: false,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:chess_game/components/dead_piece_working.dart';
import 'package:chess_game/components/piece_working.dart';
import 'package:chess_game/components/square_working.dart';
import 'package:chess_game/helper/helper_methods_working.dart';
import 'package:chess_game/values/colors_working.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<ChessPiece?>> board;

  ChessPiece? selectedPiece;
  int selectedRow = -1;
  int selectedCol = -1;
  List<List<int>> validMoves = [];
  List<ChessPiece> blackPiecesTaken = [];
  List<ChessPiece> whitePiecesTaken = [];

  // Track whose turn it is
  bool isWhiteTurn = true;

  // Track king positions
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];

  bool checkStatus = false;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  // Initializes board with standard chess setup
  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard = List.generate(
      8,
      (index) => List.generate(8, (index) => null),
    );

    // Pawns
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

    // Rooks
    newBoard[0][0] = newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "assets/rook.png",
    );
    newBoard[7][0] = newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "assets/rook.png",
    );

    // Knights
    newBoard[0][1] = newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: "assets/knight.png",
    );
    newBoard[7][1] = newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: "assets/knight.png",
    );

    // Bishops
    newBoard[0][2] = newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: "assets/bishop.png",
    );
    newBoard[7][2] = newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: "assets/bishop.png",
    );

    // Queens
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: "assets/queen.png",
    );
    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: "assets/queen.png",
    );

    // Kings
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: "assets/king.png",
    );
    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: "assets/king.png",
    );

    board = newBoard;
  }

  // Handles selecting and moving pieces
  void pieceSelected(int row, int col) {
    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    setState(() {
      // Select new piece
      if (board[row][col] != null &&
          (selectedPiece == null ||
              board[row][col]!.isWhite == selectedPiece!.isWhite)) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
          validMoves = calculateRealValidMoves(row, col, selectedPiece, true);
        }
        return;
      }

      // Move piece to new position
      if (selectedPiece != null &&
          validMoves.any((move) => move[0] == row && move[1] == col)) {
        movePiece(row, col);
      }
    });
  }

  // Returns real valid moves (filters out moves that would expose own king)
  List<List<int>> calculateRealValidMoves(
    int row,
    int col,
    ChessPiece? piece,
    bool checkSimulation,
  ) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);

    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];

        // Only allow move if it keeps king safe
        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }

    return realValidMoves;
  }

  // Move the piece and handle state updates
  void movePiece(int newRow, int newCol) {
    if (board[newRow][newCol] != null) {
      var captured = board[newRow][newCol]!;
      if (captured.isWhite) {
        whitePiecesTaken.add(captured);
      } else {
        blackPiecesTaken.add(captured);
      }
    }

    // Move piece
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    // Update king's position
    if (selectedPiece!.type == ChessPieceType.king) {
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    //check if it's a checkmate
    if (isCheckMate(!isWhiteTurn)) {
      showDialog(context: context, builder: (context)=>AlertDialog(title: const Text('CHECK MATE!'),
      actions: [
        //play again button
        TextButton(onPressed: resetGame, child: const Text("Play Again"))
      ],));
    }

    //change turns
    isWhiteTurn = !isWhiteTurn;
  }

  // Returns raw valid moves for a piece (does not consider king safety)
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    if (piece == null) return [];

    List<List<int>> moves = [];
    int dir = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        if (isInBoard(row + dir, col) && board[row + dir][col] == null) {
          moves.add([row + dir, col]);
          if ((piece.isWhite && row == 6) || (!piece.isWhite && row == 1)) {
            if (board[row + 2 * dir][col] == null) {
              moves.add([row + 2 * dir, col]);
            }
          }
        }
        for (var dc in [-1, 1]) {
          int newRow = row + dir;
          int newCol = col + dc;
          if (isInBoard(newRow, newCol) &&
              board[newRow][newCol]?.isWhite != piece.isWhite &&
              board[newRow][newCol] != null) {
            moves.add([newRow, newCol]);
          }
        }
        break;

      case ChessPieceType.rook:
        moves.addAll(
          slideMoves(row, col, piece, [
            [-1, 0],
            [1, 0],
            [0, -1],
            [0, 1],
          ]),
        );
        break;

      case ChessPieceType.knight:
        var steps = [
          [-2, -1],
          [-2, 1],
          [-1, -2],
          [-1, 2],
          [1, -2],
          [1, 2],
          [2, -1],
          [2, 1],
        ];
        for (var s in steps) {
          int r = row + s[0], c = col + s[1];
          if (!isInBoard(r, c)) continue;
          if (board[r][c] == null || board[r][c]!.isWhite != piece.isWhite) {
            moves.add([r, c]);
          }
        }
        break;

      case ChessPieceType.bishop:
        moves.addAll(
          slideMoves(row, col, piece, [
            [-1, -1],
            [-1, 1],
            [1, -1],
            [1, 1],
          ]),
        );
        break;

      case ChessPieceType.queen:
        moves.addAll(
          slideMoves(row, col, piece, [
            [-1, 0],
            [1, 0],
            [0, -1],
            [0, 1],
            [-1, -1],
            [-1, 1],
            [1, -1],
            [1, 1],
          ]),
        );
        break;

      case ChessPieceType.king:
        for (var d in [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1],
        ]) {
          int r = row + d[0], c = col + d[1];
          if (!isInBoard(r, c)) continue;
          if (board[r][c] == null || board[r][c]!.isWhite != piece.isWhite) {
            moves.add([r, c]);
          }
        }
        break;
    }

    return moves;
  }

  // Sliding piece movement logic (rook, bishop, queen)
  List<List<int>> slideMoves(
    int row,
    int col,
    ChessPiece piece,
    List<List<int>> directions,
  ) {
    List<List<int>> moves = [];
    for (var d in directions) {
      int i = 1;
      while (true) {
        int r = row + i * d[0];
        int c = col + i * d[1];
        if (!isInBoard(r, c)) break;
        if (board[r][c] != null) {
          if (board[r][c]!.isWhite != piece.isWhite) moves.add([r, c]);
          break;
        }
        moves.add([r, c]);
        i++;
      }
    }
    return moves;
  }

  // Checks if a king of given color is in check
  bool isKingInCheck(bool isWhiteKing) {
    List<int> kingPos = isWhiteKing ? whiteKingPosition : blackKingPosition;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> moves = calculateRawValidMoves(i, j, board[i][j]);
        if (moves.any((m) => m[0] == kingPos[0] && m[1] == kingPos[1])) {
          return true;
        }
      }
    }
    return false;
  }

  // Simulates a move and checks if it exposes own king
  bool simulatedMoveIsSafe(
    ChessPiece piece,
    int startRow,
    int startCol,
    int endRow,
    int endCol,
  ) {
    ChessPiece? capturedPiece = board[endRow][endCol];
    List<int>? originalKingPos;

    // Update temporary king position
    if (piece.type == ChessPieceType.king) {
      originalKingPos = piece.isWhite ? whiteKingPosition : blackKingPosition;
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    bool kingInCheck = isKingInCheck(piece.isWhite);

    // Restore
    board[startRow][startCol] = piece;
    board[endRow][endCol] = capturedPiece;
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPos!;
      } else {
        blackKingPosition = originalKingPos!;
      }
    }

    return !kingInCheck;
  }
      //is it a check mate?
    bool isCheckMate(bool isWhiteKing) {
      // if the king is not in check , then its not a checkmate
      if (!isKingInCheck(isWhiteKing)) {
        return false;
      }
      //if there is at least one legal move for ant of the player's pieces then its not checkmate
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          //Skips empty squares and pieces of the other color
          if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
            continue;
          }
          List<List<int>> pieceValidMoves = calculateRealValidMoves(
            i,
            j,
            board[i][j],
            true,
          );
          //if this piece has any valid moves, then it's not checkmate
          if (pieceValidMoves.isNotEmpty) {
            return false;
          }
        }
      }
      // if nonr of the above conditions are met , then there are no legal moves left to make

      // its a check mate
      return true;
    }

  //Reset the game
  void resetGame(){
    Navigator.pop(context);
    _initializeBoard();
    checkStatus=false;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    whiteKingPosition=[7,4];
    blackKingPosition=[0,4];
    isWhiteTurn=true;
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // White captured pieces
          Expanded(
            child: GridView.builder(
              itemCount: whitePiecesTaken.length,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: whitePiecesTaken[index].imagePath,
                isWhite: true,
              ),
            ),
          ),

          // Display check text
          Text(
            checkStatus ? "CHECK!" : "",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Main board UI
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
                  isWhite: isWhite(index),
                  piece: board[row][col],
                  isSelected: selectedRow == row && selectedCol == col,
                  isValidMove: validMoves.any(
                    (m) => m[0] == row && m[1] == col,
                  ),
                  onTap: () => pieceSelected(row, col),
                );
              },
            ),
          ),

          // Black captured pieces
          Expanded(
            child: GridView.builder(
              itemCount: blackPiecesTaken.length,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: blackPiecesTaken[index].imagePath,
                isWhite: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
