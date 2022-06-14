/**
 * Site com app stilo whatsapp: https://www.macoratti.net/19/09/flut_circimg1.htm
 * Ajuda: banco de dados app to-do list: https://github.com/kleberandrade/todo-list-aulas-flutter/blob/master/lib/views/home_page.dart
 * Videos ajuda: https://youtu.be/S676OGGF-w0
 * 
*/
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController taskController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> _tarefas = [];

  var value;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Lista de Tarefas'),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          controller: taskController,
                          style: TextStyle(fontSize: 32, color: Colors.black87),
                          decoration: InputDecoration(
                              hintText: 'Informe nova tarefa',
                              hintStyle: TextStyle(fontSize: 20)),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.toString().trim().isEmpty) {
                              return 'Informe um valor';
                            }
                            return null;
                          },
                        )),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: ElevatedButton(
                            child: Icon(Icons.add, size: 30),
                            onPressed: () {
                              bool formValido =
                                  _formKey.currentState?.validate() != null;
                              if (formValido) {
                                setState(() {
                                  _tarefas.add(taskController.text);
                                });
                                taskController.clear();
                              }
                            },
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    child: ListView.builder(
                  itemCount: _tarefas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_tarefas[index]),
                    );
                  },
                ))
              ],
            ),
          )),
    );
  }

  _validarCampoVazio(String _value) {
    if (_value != null) {
      return 'Informe um valor';
    }
    return '';
  }
}
