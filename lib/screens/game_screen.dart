import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as en;
import 'package:region_detector/region_detector.dart';
import 'package:wordfun/custom_widgets/matrix_box.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  final wordsList = en.all;
  Set<String> wordSet = HashSet<String>();
  Set<String> selectedWordSet = HashSet<String>();
  Set<String> selectedMatrixSet = LinkedHashSet<String>();
  Set<String> matrixSet = HashSet<String>();
  String selectedWord = '';

  int wordsNum = 10;
  int maxHeight = 30;
  int maxWidth = 30;

  final random = Random();
  late List<List<MatrixBox>>  matrix;
  final List<String> characters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
    'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'r', 's', 't'];

  final textStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30);

  @override
  void initState() {
    initSet();
  }

  @override
  Widget build(BuildContext context) {
    print('${matrixSet.length} ${selectedMatrixSet.length}');

    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text('Total words: ${wordSet.length}', style: textStyle,),
            Text('Words found: ${selectedWordSet.length}', style: textStyle,),

            SizedBox(height: 50,),
            Center(
              child: FocusArea(
                onPointerDown: resetSelectedWord,
                onPointerUp: resolveSelectedWord,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for(List<MatrixBox> list in matrix)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for(MatrixBox matrixBox in list)
                            MatrixBox(character: matrixBox.character, positioon: matrixBox.positioon,
                                isSelected: isBoxSelected(matrixBox.positioon),
                                hasBeenSelected: hasBeenSelected(matrixBox.positioon),
                                onCharacterEntered: onCharacterEntered)
                        ],
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void initSet() {
    String tempWord = '';
    while (wordSet.length < 10 ){
      tempWord = wordsList[random.nextInt(wordsList.length)];
      if(tempWord.length <= 13 && !wordSet.contains(tempWord)){
        wordSet.add(tempWord);
      }
    }
    initMatrix();
  }

  void initMatrix() {
    List<List<Widget>> mat = [for(int i=0; i<wordsNum; i++) [for(int j=0; j<wordsNum; j++) Container()] ];
    for(String word in wordsList){
      mat = insertWordInMat(word, mat);
    }
    matrix = fillUpMatCharacters(mat);
  }

  List<List<Widget>> insertWordInMat(String word, List<List<Widget>> mat){
    insertloop:
    for(int i=0; i<mat.length; i++){
      for(int j=0; j<mat[i].length; j++){
        if(mat[i][j].runtimeType != MatrixBox){
          bool isHorizontal =  random.nextInt(10)%2 == 0;
          bool canBeInserted = checkIfCanBeInsertedAtPos(word, mat, i, j, isHorizontal);
          if(!canBeInserted){
            isHorizontal = !isHorizontal;
            canBeInserted = checkIfCanBeInsertedAtPos(word, mat, i, j, isHorizontal);
          }
          if(canBeInserted){
            insertInMatAtPos(word, mat, i, j, isHorizontal);
            wordSet.add(word);
            break insertloop;
          }
        }
      }
    }
    return mat;
  }

  bool checkIfCanBeInsertedAtPos(String word, List<List<Widget>> mat, int row, int col, bool isHorizontal) {
    int i=0, j=0;
    for(int k=0; k<word.length; k++){
      if(isHorizontal){
        j = col+k;
      }else{
        i = row+k;
      }
      if(i>=mat.length || j>= mat[i].length || mat[i][j].runtimeType == MatrixBox){
        return false;
      }
    }
    return false;
  }

  List<List<Widget>> insertInMatAtPos(String word, List<List<Widget>> mat,
      int row, int col, bool isHorizontal) {
    int i=0, j=0;
    for(int k=0; k<word.length; k++){
      if(isHorizontal){
        j = col+k;
      }else{
        i = row+k;
      }
      mat[row][col] = MatrixBox(character: word[k], positioon: '$i,$j',
          isSelected: isBoxSelected('$i,$j'), onCharacterEntered: onCharacterEntered,
        hasBeenSelected: hasBeenSelected('$i,$j')
      );
    }
    return mat;
  }

  bool isBoxSelected(String s) {
    return selectedMatrixSet.contains(s);
  }

  bool hasBeenSelected(String s) {
    return matrixSet.contains(s);
  }

  onCharacterEntered(String p1) {
    if(selectedMatrixSet.contains(p1))return;
    final wordData = p1.split(',');
    selectedMatrixSet.add(p1);
    selectedWord += matrix[int.parse(wordData[0])][int.parse(wordData[1])].character;
    setState(() {});
    print('p1  $p1, $selectedWord');
  }

  List<List<MatrixBox>> fillUpMatCharacters(List<List<Widget>> mat) {
    List<List<MatrixBox>> result = [for(int i=0; i<wordsNum; i++) [for(int j=0; j<wordsNum; j++)
      MatrixBox(character: 'character', positioon: 'positioon', isSelected: false, hasBeenSelected: false,
          onCharacterEntered: onCharacterEntered)] ];
    for(int i=0; i<result.length; i++){
      for(int j=0; j<result[i].length; j++){
        if(mat[i][j].runtimeType != MatrixBox){
          result[i][j] = MatrixBox(character: characters[random.nextInt(26)], positioon: '$i,$j',
              isSelected: isBoxSelected('$i,$j'), onCharacterEntered: onCharacterEntered,
            hasBeenSelected: hasBeenSelected('$i,$j')
          );
        }else{
          result[i][j] = mat[i][j] as MatrixBox;
        }
      }
    }
    return result as List<List<MatrixBox>>;
  }

  resetSelectedWord() {
    selectedWord = '';
    selectedMatrixSet.clear();
  }

  resolveSelectedWord() {
    /// If word is already selected, cancel
    /// If word is n
    // if(wordSet.contains(selectedWord)){
      selectedMatrixSet.add(selectedWord);
      matrixSet.addAll(selectedMatrixSet);
      selectedWordSet.add(selectedWord);
    // }
    resetSelectedWord();
    // if(mounted){
      setState(() { });
    // }
  }
}


