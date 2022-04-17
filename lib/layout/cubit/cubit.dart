import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/layout/cubit/satet.dart';
import 'package:note_app/module/archive_screen/archive.dart';
import 'package:note_app/module/done_screen/done.dart';
import 'package:note_app/module/tasks_screen/tasks.dart';
import 'package:note_app/shared/components/constant.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayoutCubit extends Cubit<HomeLayoutStates> {
  HomeLayoutCubit() : super(HomeLayoutInitialState());

  static HomeLayoutCubit get(context) => BlocProvider.of(context);

  List<String> screenTittle = [
    "Tasks",
    "Done ",
    "Archived",
  ];
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  var currentIndex = 0;
  late Database database;
  bool bottomSheetUp = false;

  void changeBottomNaviState(int index) {
    currentIndex = index;
    emit(HomeLayoutChangeBottomNaviState());
  }

  void trueAndFalse({required bool isShow}) {
    bottomSheetUp = isShow;
    emit(HomeLayoutChangeTrueAndFalseState());
  }

  void updateDB({
    required String status,
    required int id,
  }) {
    database.rawUpdate(
      'UPDATE Tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDb(database);
      emit(HomeLayoutUpdateDBState());
    });
  }

  void deleteDB({
    required int id,
  }) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ? ', [id]).then((value) {
      getDb(database);
      emit(HomeLayoutDeleteDBState());
    });
  }

  createDB() {
    openDatabase(
      'Note.db',
      version: 1,
      onCreate: (database, version) {
        // print("Database Created");
        database
            .execute(
                'CREATE TABLE Tasks ( id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {
          // print("Table Created");
        }).catchError((error) {
          // print("error : ${error.toString()}");
        });
      },
      onOpen: (database) {
        getDb(database);
      },
    ).then((value) {
      database = value;
      emit(HomeLayoutCreateDBState());
      print("Database Opend");
    });
  }

  Future insertIntoDB({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Tasks(title, date, time,status) VALUES("$title", "$date", "$time","new")')
          .then((value) {
        print("$value inserted successfully");
        emit(HomeLayoutInsertDbState());
        getDb(database);
      }).catchError((error) {
        print("Error when Inserting ${error.toString()}");
      });
    });
  }

  void getDb(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      for (var element in value) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      }
      emit(HomeLayoutGetDBState());
    });
    ;
  }
}
