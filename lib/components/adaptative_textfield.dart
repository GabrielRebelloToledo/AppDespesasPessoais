import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// ignore: must_be_immutable
class AdaptativeTextfield extends StatelessWidget {

  final TextEditingController controller;
  final TextInputType keyboardType ;
  final String label;
  Function(String) onSubmitted;
  


  AdaptativeTextfield({
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onSubmitted,
    this.label
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS 

    ? Padding(
      padding: const EdgeInsets.only(bottom:10),
      child: CupertinoTextField(
        controller: controller,
        keyboardType: keyboardType,
        onSubmitted: (_) => onSubmitted,
        placeholder: label,
        padding: EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 12
        ),

      ),
    ) :
    TextField(
                controller: controller,
                keyboardType: keyboardType,
                onSubmitted: (_) => onSubmitted,
                decoration: InputDecoration(
                labelText: label,
    ),
    );

  }
}