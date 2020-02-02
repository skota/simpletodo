import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/task.dart';

class DatabaseHelper {
  static Database _database; //singleton database
  static DatabaseHelper _databaseHelper; //singleton database

  String tasksTable = 'tasks';
  String colId = 'id';
  String colDueDateTime = 'due_date_time';
  String colCompletedDateTime = 'completed_date_time';
  String colCreatedDateTime = 'created_date_time';

  String colPriority = 'priority';
  String colCategory = 'category';
  String colNote = 'note';
  String colTitle = 'title';

  DatabaseHelper._createInstance(); //named constructor

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper; //taskList = snapshot.data;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationSupportDirectory();
    String path = directory.path + 'tasks.db';

    var readingsDB = await openDatabase(path, version: 1, onCreate: _createDB);

    return readingsDB;
  }

  void _createDB(Database db, int newVersion) async {
    // create readings table
    await db.execute("""CREATE TABLE $tasksTable 
              (
                $colId INTEGER PRIMARY KEY AUTOINCREMENT,  
                $colDueDateTime TEXT, 
                $colCompletedDateTime TEXT, 
                $colCreatedDateTime TEXT, 
                $colPriority INTEGER, 
                $colCategory INTEGER,
                $colTitle TEXT,
                $colNote TEXT)""");

    //seed dtata
    await db.rawQuery(
        "INSERT INTO tasks (due_date_time, title, note, priority, category) values ('01-01-2020','Walk Fido','Fido wants to go for a walk',1,1)");
    await db.rawQuery(
        "INSERT INTO tasks (due_date_time, title, note, priority, category) values ('01-01-2020','Buy Milk','Stop at the store and buy milk',1,1)");
  }

  void clearDB() async {
    await _database.rawQuery("DELETE FROM TASKS");
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.database;

    var result = await db.query(tasksTable, orderBy: '$colDueDateTime DESC');
    return result;
  }

  // insert reading
  Future<int> insertTask(TaskModel task) async {
    Database db = await this.database;
    var result = await db.insert(tasksTable, task.toMap());
    return result;
  }

  // update task
  Future<int> updateTask(TaskModel task) async {
    Database db = await this.database;
    var result = await db.update(
      tasksTable,
      task.toMap(),
      where: '$colId = ?',
      whereArgs: [task.id],
    );
    return result;
  }

  // delete Task
  Future<int> deleteTask(int id) async {
    Database db = await this.database;

    int result = await db.delete(
      tasksTable,
      where: '$colId = ?',
      whereArgs: [id],
    );

    return result;
  }

  //get count
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $tasksTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Task List' [ List<Task> ]
  Future<List<TaskModel>> getTaskList() async {
    var taskMapList = await getTaskMapList(); // Get 'Map List' from database

    int count =
        taskMapList.length; // Count the number of map entries in db table

    List<TaskModel> taskList = List<TaskModel>();

    // For loop to create a 'Task List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      taskList.add(TaskModel.fromMapObject(taskMapList[i]));
    }

    return taskList;
  }
}
