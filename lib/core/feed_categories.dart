import 'package:flutter/material.dart';

Widget feedCategories(List<String> categories) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Text(
      '#${categories.join(' ')}',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}
