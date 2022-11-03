import 'dart:ui';

import 'package:flutter/material.dart';

class WhiteButton extends StatelessWidget {
    WhiteButton({super.key, required this.onPressed,required this.buttonName, this.miniumSize = const Size(200, 50), this.isShowProgressive = false});
    final GestureTapCallback onPressed;
    String buttonName; 
    Size miniumSize;
    bool isShowProgressive;
    @override
    Widget build(BuildContext context) {
      return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                minimumSize: miniumSize,
              ),
              onPressed: () { this.onPressed(); },
              child: 
                  isShowProgressive?  SizedBox( child:const CircularProgressIndicator(color: Color.fromARGB(255, 0, 0, 0),), width: 15, height: 15.0,) :
                  Text(buttonName,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0))),
            );
  }
}