import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lista_tarefas/repository/repository.dart';
import 'package:lista_tarefas/entity/task.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> _taskList = [];
  TaskRepository _repository = TaskRepository();
  bool _loading = true;

  final TextEditingController taskController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _repository.getAll().then((list) {
      setState(() {
        _taskList = list;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Tarefas'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: <Widget>[
              Form(
                  child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextFormField(
                    controller: taskController,
                    style: const TextStyle(fontSize: 32, color: Colors.black87),
                    decoration: const InputDecoration(
                        hintText: 'Informe nova tarefa',
                        hintStyle: TextStyle(fontSize: 20)),
                    keyboardType: TextInputType.text,
                  )),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: ElevatedButton(
                      child: const Icon(Icons.add, size: 30),
                      onPressed: () {
                        if (taskController.text.isNotEmpty) {
                          String taskName = taskController.text;
                          _addNewTask(taskName);
                          taskController.clear();
                        }
                      },
                    ),
                  ),
                ],
              )),
              SingleChildScrollView(
                padding: EdgeInsets.only(top: 50),
                physics: ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _taskList.length,
                        itemBuilder: (context, index) {
                          Task task = _taskList[index];
                          return Row(
                            children: [
                              Flexible(
                                  child: Checkbox(
                                value: task.isDone,
                                onChanged: _updateTask(task),
                              )),
                              const Spacer(),
                              Flexible(
                                  child: Text(
                                task.title,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black87),
                              )),
                              const Spacer(),
                              Flexible(
                                  child: ElevatedButton(
                                onPressed: _deleteTask(task),
                                child: Icon(Icons.delete),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red.shade400)),
                              ))
                            ],
                          );
                        })
                  ],
                ),
              )
            ],
          ),
        ));
  }

  _updateTask(Task task) {
    _repository.update(task).then((value) => null);
    _repository.getAll().then((list) {
      setState(() {
        _taskList = list;
      });
    });
  }

  _deleteTask(Task task) {
    _repository.delete(task.id).then((value) => null);
    _repository.getAll().then((list) {
      setState(() {
        _taskList = list;
      });
    });
  }

  Future _addNewTask(String nameTask) async {
    if (nameTask != null) {
      Task task = Task(id: 0, title: nameTask);
      _repository.save(task);
      _repository.getAll().then((list) {
        setState(() {
          _taskList = list;
          _loading = false;
        });
      });
    } else {
      return Fluttertoast.showToast(
          msg: "This is Center Short Toast",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Informe um valor"),
        ],
      ),
    );
  }
}
