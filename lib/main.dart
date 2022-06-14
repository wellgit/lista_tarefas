import 'package:flutter/material.dart';
import 'package:lista_tarefas/view/home_page.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.teal)));
}
