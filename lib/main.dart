import 'package:flutter/material.dart';
import 'package:intl/number_symbols_data.dart';
import 'src/models/task.dart';
import 'pages/add_task.dart';
import "package:scoped_model/scoped_model.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tasks(),
    );
  }
}

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    TaskModel tasks = TaskModel();

    return ScopedModel<TaskModel>(
      model: tasks,
      child: ScopedModelDescendant<TaskModel>(
        builder: (BuildContext context, Widget child, TaskModel model) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.lightBlue,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                "Tasks",
                style: TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    TaskModel newtask = TaskModel();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTask(newtask, ''),
                      ),
                    );
                  },
                )
              ],
            ),
            body: ListView.builder(
              itemCount: model.tasklist.length,
              itemBuilder: (BuildContext context, int index) {
                TaskModel currentTask = model.tasklist[index];
                return Dismissible(
                  direction: DismissDirection.startToEnd, //left to right,
                  key: Key(currentTask.id.toString()),
                  onDismissed: (direction) {
                    setState(() {
                      model.deleteTask(currentTask);
                      model.tasklist.removeAt(index);
                    });
                  },
                  child: ListTile(
                    title: Text(
                      '${currentTask.title}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${currentTask.note}"),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Widget todoItemBuilder(BuildContext context, int index) {
  //    TaskModel currentTask = widget.model.tasklist[index];
  //               return Dismissible(
  //                 direction: DismissDirection.startToEnd, //left to right,
  //                 key: Key(currentTask.id.toString()),
  //                 onDismissed: (direction) {
  //                   setState(() {
  //                     model.deleteTask(currentTask);
  //                     model.tasklist.removeAt(index);
  //                   });
  //                 },
  //                 child: ListTile(
  //                   title: Text(
  //                     '${currentTask.title}',
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                   ),
  //                   subtitle: Text("${currentTask.note}"),
  //                 ),
  //               );
  // }
}
