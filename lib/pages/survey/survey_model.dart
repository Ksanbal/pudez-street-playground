import 'package:flutter/material.dart';

class SurveyModel {
  String question;
  StatefulBuilder child;

  SurveyModel({
    required this.question,
    required this.child,
  });
}
