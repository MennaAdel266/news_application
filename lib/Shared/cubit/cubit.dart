import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_application/Shared/cubit/states.dart';
import 'package:news_application/Shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';


class AppCubit extends Cubit <AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);


  Database database;


  void createDatabase()
  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when created table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value)
    {
      database = value;
      emit(AppCreateDatabaseState());
    });

  }

  insertDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn.rawInsert(
        'INSERT INTO tasks (title,date, time, status) VALUES(" $title","$date","$time","new")',
      ).then((value) {
        print('$value insert successed');

        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when inserting new ${error.toString()}');
      });

      return null;
    });
  }
  void getDataFromDatabase(database)
  {

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element)
      {

      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    @required String status,
    @required int id,
  }) async
  {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    @required int id,
  }) async
  {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isDark = false;
  ThemeMode appMode = ThemeMode.dark;
  void changeAppMode({bool fromShared})
  {
    if(fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeMoodState());
    } else
    {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeMoodState());
      });
    }
  }
}