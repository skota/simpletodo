import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../src/resources/database_helper.dart';
import '../src/models/task.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  String appBarTitle;
  TaskModel task;

  AddTask(this.task, this.appBarTitle);

  @override
  _AddTaskState createState() => _AddTaskState(this.task, this.appBarTitle);
}

class _AddTaskState extends State<AddTask> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  TaskModel task;
  int currentPrioSelection = 1;
  int currentCategorySelection = 1;

  TextStyle textStyle = TextStyle(color: Colors.grey);
  TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontSize: 16.0,
  );

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  //constructor
  _AddTaskState(this.task, this.appBarTitle);

  var today = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    titleController.text = task.title;
    noteController.text = task.note;
    dateController.text = task.dueDateTime;
    categoryController.text = task.category.toString();
    priorityController.text = task.priority.toString();

    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          dispose();
          Navigator.pop(context);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
            title: Text(
              appBarTitle,
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  Navigator.pop(context);
                }),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _save();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Text(
                        "Save",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0),
            child: ListView(
              children: <Widget>[
                // First element -- title
                _Title(textStyle),
                Divider(),
                // Second Element -- note
                _Notes(textStyle),
                // Third Element - time of day
                Divider(),
                _taskPriority(textStyle),
                Divider(),
                _taskCategory(textStyle),
                Divider(),
                // Fourth Element - date and time
                _dateAndTime(textStyle),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen(retval) {
    Navigator.pop(context, retval);
  }

  Widget _categoryButtonBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _raisedButtonCategory("Work", 1),
        _raisedButtonCategory("Family", 2),
        _raisedButtonCategory("Other", 3),
      ],
    );
  }

  Widget _raisedButtonCategory(String title, int index) {
    return RaisedButton(
      elevation: 0.0,
      onPressed: () {
        setState(() {
          this.currentCategorySelection = index;
        });
      },
      color:
          (this.currentCategorySelection == index) ? Colors.blue : Colors.white,
      child: Text(
        "$title",
        style: TextStyle(
            color: (this.currentCategorySelection == index)
                ? Colors.white
                : Colors.black,
            fontWeight: (this.currentCategorySelection == index)
                ? FontWeight.bold
                : FontWeight.normal),
      ),
    );
  }

  Widget _raisedButtonPriority(String title, int index) {
    return RaisedButton(
      elevation: 0.0,
      onPressed: () {
        setState(() {
          this.currentPrioSelection = index;
        });
      },
      color: (this.currentPrioSelection == index) ? Colors.blue : Colors.white,
      child: Text(
        "$title",
        style: TextStyle(
            color: (this.currentPrioSelection == index)
                ? Colors.white
                : Colors.black,
            fontWeight: (this.currentPrioSelection == index)
                ? FontWeight.bold
                : FontWeight.normal),
      ),
    );
  }

  Widget _priorityButtonBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _raisedButtonPriority("Low", 1),
        _raisedButtonPriority("Medium", 2),
        _raisedButtonPriority("High", 3),
      ],
    );
  }

  Widget _taskPriority(TextStyle textStyle) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "Priority",
            style: labelStyle,
          ),
        ),
        Expanded(
          flex: 3,
          child: _priorityButtonBar(),
        ),
      ],
    );
  }

  Widget _taskCategory(TextStyle textStyle) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "Category",
            style: labelStyle,
          ),
        ),
        Expanded(
          flex: 3,
          child: _categoryButtonBar(),
        ),
      ],
    );
  }

  Widget _Title(TextStyle textStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            "Title",
            style: labelStyle,
          ),
        ),
        Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: textStyle,
              controller: titleController,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                updateTitle();
              },
            ))
      ],
    );
  }

  Widget _dateAndTime(TextStyle textStyle) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "Due Date",
            style: labelStyle,
          ),
        ),
        Expanded(
          flex: 2,
          child: TextField(
            controller: dateController,
            style: textStyle,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());

              DatePicker.showDateTimePicker(context, showTitleActions: true,
                  onChanged: (date) {
                print("changed: $date");
              }, onConfirm: (date) {
                setState(() {
                  task.dueDateTime =
                      DateFormat.yMMMMd("en_US").add_jm().format(date);
                });
              }, currentTime: today);
            },
            onChanged: (value) {
              setState(() {
                dateController.text = value;
                //DateFormat.yMMMMd("en_US").add_jm().format(value);
              });
            },
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  Widget _Notes(TextStyle textStyle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: TextField(
        controller: noteController,
        keyboardType: TextInputType.multiline,
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.grey),
        // textAlignVertical: TextAlignVertical(),
        maxLines: 4,
        maxLength: 500,

        onTap: () {
          // DIDN'T WORK
          // should lose focus when clicked outside textarea
          // FocusScopeNode currentFocus = FocusScope.of(context);
        },
        onChanged: (value) {
          //debugPrint('Something changed in Description Text Field');
          updateNotes();
        },
        decoration: InputDecoration(
          labelText: 'optional notes',
          labelStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  void updateTitle() {
    task.title = titleController.text;
  }

  // void updateReadingTakenAt() {
  //   reading.readingTakenAt = timeOfDay.id;
  // }

  // void updateDate() {
  //   reading.readingDateTime = dateController.text;
  // }

  void updateNotes() {
    task.note = noteController.text;
  }

  Future<void> _requiredValuesMissing(String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Required value missing'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Task $title is requried.'),
                Text('Please add a $title and try again.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _save() async {
    int result;

    if ((task.title.length == 0) || (task.title == "Title")) {
      _requiredValuesMissing("title");
      return;
    }

    if ((task.note.length == 0) || (task.note == "Notes")) {
      _requiredValuesMissing("note");
      return;
    }
    task.category = this.currentCategorySelection;
    task.priority = this.currentPrioSelection;

    if (task.id != null) {
      // Case 1: Update operation
      //result = await helper.updateTask(task);
      task.updateTask(task);
      Navigator.pop(context);
    } else {
      // Case 2: Insert Operation
      task.addTask(task);
      Navigator.pop(context);
    }
  }

  //void _delete() {}

  // void _showAlertDialog(String title, String message) {
  //   AlertDialog alertDialog = AlertDialog(
  //     title: Text(title),
  //     content: Text(message),
  //   );
  //   showDialog(context: context, builder: (_) => alertDialog);
  // }
}
