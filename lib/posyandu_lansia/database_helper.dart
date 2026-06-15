import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'data_store.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('lanscare.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE users ADD COLUMN posyandu TEXT NOT NULL DEFAULT 'Posyandu Melati'");
    }
    if (oldVersion < 3) {
      await db.delete('health_records');
      await db.delete('medicines');
      await db.delete('schedules');
      await db.delete('notifications');
      await db.delete('lansia_members');
    }
    
    if (oldVersion < 4) {
      try {
        await db.execute("ALTER TABLE users ADD COLUMN kaderContact TEXT NOT NULL DEFAULT ''");
      } catch (_) {}
    }

    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE session (
          email TEXT PRIMARY KEY,
          role TEXT NOT NULL
        )
      ''');
    }
  }

  Future _createDB(Database db, int version) async {
    // 1. Users Table
    await db.execute('''
      CREATE TABLE users (
        email TEXT PRIMARY KEY,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        gender TEXT NOT NULL,
        nik TEXT NOT NULL,
        familyContact TEXT NOT NULL,
        medicalHistory TEXT NOT NULL,
        profileImage TEXT NOT NULL,
        posyandu TEXT NOT NULL,
        kaderContact TEXT NOT NULL DEFAULT ''
      )
    ''');

    // 2. Health Records Table
    await db.execute('''
      CREATE TABLE health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        bpSystolic TEXT NOT NULL,
        bpDiastolic TEXT NOT NULL,
        bloodSugar INTEGER NOT NULL,
        weight REAL NOT NULL,
        heartRate INTEGER NOT NULL,
        memberId TEXT NOT NULL
      )
    ''');

    // 3. Medicines Table
    await db.execute('''
      CREATE TABLE medicines (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        dose TEXT NOT NULL,
        time TEXT NOT NULL,
        note TEXT NOT NULL,
        isChecked INTEGER NOT NULL
      )
    ''');

    // 4. Schedules Table
    await db.execute('''
      CREATE TABLE schedules (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        timeRange TEXT NOT NULL,
        location TEXT NOT NULL
      )
    ''');

    // 5. Notifications Table
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        timeLabel TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');

    // 6. Lansia Members Table (for Kader Dashboard)
    await db.execute('''
      CREATE TABLE lansia_members (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        gender TEXT NOT NULL
      )
    ''');

    // 7. Session Table
    await db.execute('''
      CREATE TABLE session (
        email TEXT PRIMARY KEY,
        role TEXT NOT NULL
      )
    ''');
  }

  // --- CRUD OPERATIONS ---

  // Users
  Future<void> insertUser(RegisteredUser user) async {
    final db = await instance.database;
    await db.insert(
      'users',
      {
        'email': user.email,
        'password': user.password,
        'role': user.role,
        'name': user.name,
        'age': user.age,
        'gender': user.gender,
        'nik': user.nik,
        'familyContact': user.familyContact,
        'medicalHistory': user.medicalHistory,
        'profileImage': user.profileImage,
        'posyandu': user.posyandu,
        'kaderContact': user.kaderContact,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RegisteredUser>> getUsers() async {
    final db = await instance.database;
    final maps = await db.query('users');
    return maps.map((map) {
      return RegisteredUser(
        email: map['email'] as String,
        password: map['password'] as String,
        role: map['role'] as String,
        name: map['name'] as String,
        age: map['age'] as int,
        gender: map['gender'] as String,
        nik: map['nik'] as String,
        familyContact: map['familyContact'] as String,
        medicalHistory: map['medicalHistory'] as String,
        profileImage: map['profileImage'] as String,
        posyandu: (map['posyandu'] as String?) ?? 'Posyandu Melati',
        kaderContact: (map['kaderContact'] as String?) ?? '',
      );
    }).toList();
  }

  // Health Records
  Future<int> insertHealthRecord(HealthRecord record, String memberId) async {
    final db = await instance.database;
    return await db.insert(
      'health_records',
      {
        'date': record.date.toIso8601String(),
        'bpSystolic': record.bpSystolic,
        'bpDiastolic': record.bpDiastolic,
        'bloodSugar': record.bloodSugar,
        'weight': record.weight,
        'heartRate': record.heartRate,
        'memberId': memberId,
      },
    );
  }

  Future<List<HealthRecord>> getHealthRecords(String memberId) async {
    final db = await instance.database;
    final maps = await db.query(
      'health_records',
      where: 'memberId = ?',
      whereArgs: [memberId],
      orderBy: 'date DESC',
    );
    return maps.map((map) {
      return HealthRecord(
        date: DateTime.parse(map['date'] as String),
        bpSystolic: map['bpSystolic'] as String,
        bpDiastolic: map['bpDiastolic'] as String,
        bloodSugar: map['bloodSugar'] as int,
        weight: map['weight'] as double,
        heartRate: map['heartRate'] as int,
      );
    }).toList();
  }

  // Medicines
  Future<void> insertMedicine(Medicine med) async {
    final db = await instance.database;
    await db.insert(
      'medicines',
      {
        'id': med.id,
        'name': med.name,
        'dose': med.dose,
        'time': med.time,
        'note': med.note,
        'isChecked': med.isChecked ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMedicine(Medicine med) async {
    final db = await instance.database;
    await db.update(
      'medicines',
      {
        'isChecked': med.isChecked ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [med.id],
    );
  }

  Future<List<Medicine>> getMedicines() async {
    final db = await instance.database;
    final maps = await db.query('medicines');
    return maps.map((map) {
      return Medicine(
        id: map['id'] as String,
        name: map['name'] as String,
        dose: map['dose'] as String,
        time: map['time'] as String,
        note: map['note'] as String,
        isChecked: (map['isChecked'] as int) == 1,
      );
    }).toList();
  }

  // Schedules
  Future<void> insertSchedule(PosyanduSchedule schedule) async {
    final db = await instance.database;
    await db.insert(
      'schedules',
      {
        'id': schedule.id,
        'name': schedule.name,
        'date': schedule.date.toIso8601String(),
        'timeRange': schedule.timeRange,
        'location': schedule.location,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PosyanduSchedule>> getSchedules() async {
    final db = await instance.database;
    final maps = await db.query('schedules', orderBy: 'date ASC');
    return maps.map((map) {
      return PosyanduSchedule(
        id: map['id'] as String,
        name: map['name'] as String,
        date: DateTime.parse(map['date'] as String),
        timeRange: map['timeRange'] as String,
        location: map['location'] as String,
      );
    }).toList();
  }

  Future<void> deleteSchedule(String id) async {
    final db = await instance.database;
    await db.delete(
      'schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Notifications
  Future<void> insertNotification(NotificationItem notification) async {
    final db = await instance.database;
    await db.insert(
      'notifications',
      {
        'id': notification.id,
        'title': notification.title,
        'body': notification.body,
        'timeLabel': notification.timeLabel,
        'type': notification.type,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NotificationItem>> getNotifications() async {
    final db = await instance.database;
    final maps = await db.query('notifications');
    return maps.map((map) {
      return NotificationItem(
        id: map['id'] as String,
        title: map['title'] as String,
        body: map['body'] as String,
        timeLabel: map['timeLabel'] as String,
        type: map['type'] as String,
      );
    }).toList();
  }

  // Lansia Members
  Future<void> insertLansiaMember(LansiaMember member) async {
    final db = await instance.database;
    await db.insert(
      'lansia_members',
      {
        'id': member.id,
        'name': member.name,
        'age': member.age,
        'gender': member.gender,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LansiaMember>> getLansiaMembers() async {
    final db = await instance.database;
    final maps = await db.query('lansia_members');
    final List<LansiaMember> members = [];
    for (final map in maps) {
      final id = map['id'] as String;
      final name = map['name'] as String;
      final age = map['age'] as int;
      final gender = map['gender'] as String;
      final records = await getHealthRecords(id);
      members.add(LansiaMember(
        id: id,
        name: name,
        age: age,
        gender: gender,
        records: records,
      ));
    }
    return members;
  }

  // Session Management
  Future<void> saveSession(String email, String role) async {
    final db = await instance.database;
    await db.delete('session');
    await db.insert('session', {
      'email': email,
      'role': role,
    });
  }

  Future<Map<String, String>?> getSession() async {
    final db = await instance.database;
    final maps = await db.query('session');
    if (maps.isNotEmpty) {
      return {
        'email': maps.first['email'] as String,
        'role': maps.first['role'] as String,
      };
    }
    return null;
  }

  Future<void> clearSession() async {
    final db = await instance.database;
    await db.delete('session');
  }
}
