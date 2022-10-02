import 'package:flutter/material.dart';
import 'package:region_detector/region_detector.dart';

class MatrixBox extends StatelessWidget {

  const MatrixBox({Key? key,
    required this.character,
    required this.positioon,
    required this.isSelected,
    required this.hasBeenSelected,
    required this.onCharacterEntered
  }) : super(key: key);

  final bool hasBeenSelected;
  final bool isSelected;
  final String character;
  final String positioon; // Matrix position
  final Function(String) onCharacterEntered;

  @override
  Widget build(BuildContext context) {
    return RegionDetector(
      onFocused: (){
        onCharacterEntered.call(positioon);
      },
      child: Container(
        height: 25,
        width: 25,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _getMatColor()
        ),
        alignment: Alignment.center,
        child: Text(character,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
      ),
    );
  }

  Color _getMatColor() {
    if(isSelected) return Colors.orangeAccent;
    if(hasBeenSelected) return Colors.grey.shade500;
    return Colors.grey.shade200;
  }
}
