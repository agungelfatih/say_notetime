import 'dart:async';

import 'package:say_notetime/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  // getter untuk mendapatkan data base
  Future<Database> get database async{
    if (_database != null) {
      return _database!;
    } else {
      // jika database null, maka akan membuat database baru
      _database = await _initDB('notes.db');
      return _database!;
    }
  }

  Future<Database> _initDB(String filename) async {
    // mendapatkan path database dari device
    final dbPath = await getDatabasesPath();
    // mendapatkan path file database secara lengkap
    final path = join(dbPath, filename);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // membuat tabel database baru, hanya dijalankan ketika database tidak ada
  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $tableNotes (
      ${NoteFields.id} $idType,
      ${NoteFields.title} $textType,
      ${NoteFields.description} $textType,
      ${NoteFields.time} $textType
    )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    //variable ini akan menyimpan id unik yang digenerated
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
        tableNotes,
        columns: NoteFields.values,
        where: '${NoteFields.id} = ?',
        whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    }  else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${NoteFields.time} ASC';

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((e) => Note.fromJson(e)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
        tableNotes,
        note.toJson(),
        where: '${NoteFields.id} = ?',
        whereArgs: [note.id]
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
        tableNotes,
        where: '${NoteFields.id} = ?',
        whereArgs: [id]
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

}