// ignore_for_file: avoid_print
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tudo_app/data/datasources/event_local_database.dart';
import 'package:tudo_app/data/models/event_model.dart';

class EventLocalDataSourcePerf implements EventLocalDataSource {
  static final EventLocalDataSourcePerf _instance = EventLocalDataSourcePerf._init();
  static Database? _eventDatabase;

  EventLocalDataSourcePerf._init();

  factory EventLocalDataSourcePerf() {
    return _instance;
  }

  Future<Database> get eventDatabase async {
    if (_eventDatabase != null) return _eventDatabase!;
    try {
      _eventDatabase = await _initDB('eventsBase.db');
      return _eventDatabase!;
    } catch (e) {
      print('Error opening database: $e');
      rethrow;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE eventsBase (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        event_name TEXT,
        event_description TEXT,
        event_location TEXT,
        event_color INTEGER,
        event_date_time TEXT,
        event_end_time TEXT,
        event_date_time_info TEXT
      )
    ''');
  }

  

  @override
  Future<void> insertEvent(EventModel event) async {
    final db = await eventDatabase;
    try {
      await db.insert('eventsBase', event.toMap());
    } catch (e) {
      print('Error inserting event: $e');
      print('Event data: ${event.toMap()}');
      rethrow;
    }
  }

  @override
  Future<List<EventModel>> getEvents() async {
    final db = await eventDatabase;
    try {
      final result = await db.query('eventsBase');
      return result.map((json) => EventModel.fromMap(json)).toList();
    } catch (e) {
      print('Error getting events: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteEvent(int id) async {
    final db = await eventDatabase;
    try {
      await db.delete(
        'eventsBase',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting event: $e');
      rethrow;
    }
  }

  @override
  Future<void> editEvent(EventModel event) async {
    final db = await eventDatabase;
    try {
      await db.update(
        'eventsBase',
        event.toMap(),
        where: 'id = ?',
        whereArgs: [event.id],
      );
    } catch (e) {
      print('Error editing event: $e');
      rethrow;
    }
  }

  Future<void> checkTableStructure() async {
    final db = await eventDatabase;
    var tableInfo = await db.rawQuery("PRAGMA table_info('eventsBase')");
    print('Table structure: $tableInfo');
  }
}