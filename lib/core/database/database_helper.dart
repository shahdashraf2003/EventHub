import 'package:event_hub/model/entities/event_model.dart';
import 'package:event_hub/model/entities/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('eventhub.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path, 
      version: 2, 
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS saved_events');
      await _createDB(db, newVersion); 
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const realType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE IF NOT EXISTS users (
  id $idType,
  name $textType,
  email $textType,
  password $textType
  )
''');

    await db.execute('''
CREATE TABLE IF NOT EXISTS saved_events (
  id TEXT,
  userId INTEGER NOT NULL,
  title $textType,
  date $textType,
  day $textType,
  month $textType,
  time $textType,
  dateTimeRaw $textTypeNullable,
  location $textType,
  address $textType,
  city $textTypeNullable,
  state $textTypeNullable,
  organizer $textType,
  organizerImage $textTypeNullable,
  coverImage $textTypeNullable,
  about $textTypeNullable,
  description $textTypeNullable,
  ticketPrice $realType,
  currency $textTypeNullable,
  goingCount $intType,
  goingAvatars $textTypeNullable,
  classification $textTypeNullable,
  url $textTypeNullable,
  PRIMARY KEY (id, userId)
  )
''');
  }


  Future<int> createUser(UserModel user) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [user.email],
    );
    if (result.isNotEmpty) {
      throw Exception('User already exists');
    }
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByEmailAndPassword(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      columns: ['id', 'name', 'email', 'password'],
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    } else {
      return null;
    }
  }


  Future<void> saveEvent(EventModel event, int userId) async {
    final db = await instance.database;
    final map = event.toMap();
    map['userId'] = userId;
    await db.insert('saved_events', map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeEvent(String eventId, int userId) async {
    final db = await instance.database;
    await db.delete(
      'saved_events',
      where: 'id = ? AND userId = ?',
      whereArgs: [eventId, userId],
    );
  }

  Future<bool> isEventSaved(String eventId, int userId) async {
    final db = await instance.database;
    final maps = await db.query(
      'saved_events',
      columns: ['id'],
      where: 'id = ? AND userId = ?',
      whereArgs: [eventId, userId],
    );
    return maps.isNotEmpty;
  }

  Future<List<EventModel>> getSavedEvents(int userId) async {
    final db = await instance.database;
    final orderBy = 'date ASC';
    final result = await db.query(
      'saved_events', 
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: orderBy
    );
    return result.map((json) {
      final map = Map<String, dynamic>.from(json);
      map.remove('userId');
      return EventModel.fromMap(map);
    }).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
