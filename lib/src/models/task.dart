import "package:scoped_model/scoped_model.dart";
import '../resources/database_helper.dart';

class TaskModel extends Model {
  int _id;
  String _title;
  String _note;
  String _dueDateTime;
  String _completedDateTime;
  String _createdDateTime;
  int _category; //category - work, personal, other
  int _priority; //priority - low, medium, high

  TaskModel();

  // @override
  void addListener(listener) {
    super.addListener(listener);
    loadData();
    notifyListeners();
  }

  String toString() {
    return "{ title=$_title, note=$_note }";
  }

  // getters
  int get id => _id;
  String get title => _title;
  String get note => _note;
  String get dueDateTime => _dueDateTime;
  String get completedDateTime => _completedDateTime;
  String get createdDateTime => _createdDateTime;

  int get priority => _priority;
  int get category => _category;

  List tasklist = <TaskModel>[];

  // setters
  set title(String title) {
    if (title.length > 0) {
      this._title = title;
    }
  }

  set note(String note) {
    if (note.length > 0) {
      this._note = note;
    }
  }

  set dueDateTime(String date) {
    if (date.length > 0) {
      this._dueDateTime = date;
    }
  }

  set createdDateTime(String date) {
    this._createdDateTime = date;
  }

  // priority -  1 - low, 2 - medium, 3 - high
  set priority(int priority) {
    if ((priority > 0) && (priority < 4)) {
      this._priority = priority;
    }
  }

  // priority -  1 - work, 2 - personal, 3 - other
  set category(int category) {
    if ((category > 0) && (category < 4)) {
      this._category = category;
    }
  }

  set completedDateTime(String date) {
    if (date.length > 0) {
      this._completedDateTime = date;
    }
  }

  void loadData() async {
    DatabaseHelper dbhelper = DatabaseHelper();
    this.tasklist = await dbhelper.getTaskList();
    loadData(); //refresh data to view
    notifyListeners();
  }

  // convert Task obj into a Map obj
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['due_date_time'] = _dueDateTime;
    map['completed_date_time'] = _completedDateTime;
    map['note'] = _note;
    map['title'] = _title;
    map['category'] = _category; //category - work, personal, other
    map['priority'] = _priority; //priority - low, medium, high
    map['created_date_time'] = _createdDateTime;

    return map;
  }

  //named constructor
  TaskModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._dueDateTime = map['due_date_time'];
    this._completedDateTime = map['completed_date_time'];
    this._createdDateTime = map['created_date_time'];

    this._category = map['category'];
    this._priority = map['priority'];
    this._note = map['note'];
    this._title = map['title'];
  }

  void addTask(TaskModel task) async {
    //tasklist.add(task);
    DatabaseHelper dbhelper = DatabaseHelper();
    await dbhelper.insertTask(task);
    loadData();
    notifyListeners();
  }

  void updateTask(TaskModel task) async {
    loadData();
    notifyListeners();
  }

  void deleteTask(TaskModel task) async {
    DatabaseHelper dbhelper = DatabaseHelper();
    await dbhelper.deleteTask(task.id);
    notifyListeners();
  }
}

// The one and only instance of this model.
TaskModel tasksmodel = TaskModel();
