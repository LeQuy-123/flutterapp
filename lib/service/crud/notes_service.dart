import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'crud_exception.dart';

const idCollumn = 'id';
const emailCollumn = 'email';
const userIdCollumn = 'user_id';
const textCollumn = 'text';
const isSyncdWithColundCollumn = 'is_synced_with_cloud';

const dbName = 'myDb.db';
const noteTable = 'note';
const userTable = 'user';

const createNoteTable = '''CREATE TABLE "note" (
	      "id"	INTEGER NOT NULL,
	      "user_id"	INTEGER NOT NULL,
      	"text"	TEXT,
	      "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	      PRIMARY KEY("id" AUTOINCREMENT),
      	FOREIGN KEY("user_id") REFERENCES "user"("id")
      );''';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
	      "id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
	      PRIMARY KEY("id" AUTOINCREMENT)
        );''';
class NotesService {
  Database? _db;
  List<DatabaseNote> _notes = [];

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance();

  factory NotesService() => _shared;

  final _noteStreamControler = StreamController<List<DatabaseNote>>.broadcast();

  Stream<List<DatabaseNote>> get allNotes => _noteStreamControler.stream;

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(userEmail: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(userEmail: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
    
  }

  Future<void> _cacheNote() async {
    final allNote = await getAllNotes();
    _notes = allNote.toList();
    _noteStreamControler.add(_notes);
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updateCount = await db.update(noteTable, {
      textCollumn: text,
      isSyncdWithColundCollumn: 0,
    }, where: '$idCollumn = ?', whereArgs: [note.id]);
    if(updateCount ==0) {
      throw Exception('Note not found');
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _noteStreamControler.add(_notes);
      return updatedNote;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      noteTable
    );
    return result.map((note) => DatabaseNote.fromRow(note));
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) {
      throw Exception('Cloud not find note with id $id');
    } else {
      final note = DatabaseNote.fromRow(result.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _noteStreamControler.add(_notes);
      return note;
    }
  }

  Future<int> deleteAllNote() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeleted =  await db.delete(noteTable);
    _notes = [];
    _noteStreamControler.add(_notes);
    return numberOfDeleted;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (deleteCount == 0) {
      throw Exception('Failed to delete note');
    } else {
      final countBF = _notes.length;
      _notes.removeWhere((note) => note.id == id);
      if(countBF != _notes.length) {
        _noteStreamControler.add(_notes);
      }
    }
  }

  Future<DatabaseNote> createNote( String text, {required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(userEmail: owner.email);

    if (dbUser != owner) {
      throw Exception('User not found');
    }
    final noteId = await db.insert(noteTable, {
      textCollumn: text,
      userIdCollumn: owner.id,
      isSyncdWithColundCollumn: 1,
    });
    final note = DatabaseNote(
      id: noteId,
      text: text,
      userId: owner.id,
      isSyncedWithCloud: true,
    );
    _notes.add(note);
    _noteStreamControler.add(_notes);
    return note;
  }

  Future<void> deleteUser ({required String userEmail}) async {
    await _ensureDbIsOpen();
    final db =  _getDatabaseOrThrow();
    final deleteCount = await db.delete(userTable, where: 'email = ?', whereArgs: [userEmail.toLowerCase()]);
    if(deleteCount != 1) {
      throw Exception('Failed to delete user');
    }
  }

  Future<DatabaseUser> createUser({required String userEmail}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable, 
      where: 'email = ?', 
      whereArgs: [userEmail.toLowerCase()]);
    if (result.isNotEmpty) {
      throw Exception('User already exists');
    }
    final userId = await db.insert(userTable, {
      emailCollumn: userEmail.toLowerCase(),
    });
    return DatabaseUser(id: userId, email: userEmail);
  }

  Future<DatabaseUser> getUser({required String userEmail}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [userEmail.toLowerCase()],
    );
    if (result.isEmpty) {
      throw Exception('Cloud not find user');
    }
    return DatabaseUser.fromRow(result.first);
  }

  Database _getDatabaseOrThrow () {
    final db = _db;
    if (db == null) {
      throw Exception('Database not initialized');
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if(db == null) {
      throw Exception('Database is not open');
    } else {
      await _db?.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // do nothing
    } catch (e) {
      rethrow;
    }
  }

  Future<void> open() async {
    if(_db != null) throw DatabaseAlreadyOpenException();

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNoteTable);
      _cacheNote();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
    catch (e) {
      rethrow;
    }
  }
}



@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idCollumn] as int,
        email = map[emailCollumn] as String;


  @override
  String toString() {
    return 'DatabaseUser{id: $id, email: $email}';
  }
  @override bool operator ==  (covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final bool isSyncedWithCloud;
  final String text;

  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.isSyncedWithCloud,
    required  this.text,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idCollumn] as int,
        userId = map[userIdCollumn] as int,
        isSyncedWithCloud = (map[isSyncdWithColundCollumn] as int) == 1 ? true : false,
        text = map[textCollumn] as String;

  @override
  String toString() {
    return 'DatabaseNote{id: $id, userId: $userId, isSyncedWithCloud: $isSyncedWithCloud, text: $text}';
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
