import 'package:flutter/material.dart';

import 'database_helper.dart';

class HealthRecord {
  final DateTime date;
  final String bpSystolic;
  final String bpDiastolic;
  final int bloodSugar;
  final double weight;
  final int heartRate;

  HealthRecord({
    required this.date,
    required this.bpSystolic,
    required this.bpDiastolic,
    required this.bloodSugar,
    required this.weight,
    required this.heartRate,
  });

  String get bpString => '$bpSystolic/$bpDiastolic';
}

class Medicine {
  final String id;
  final String name;
  final String dose;
  final String time;
  final String note;
  bool isChecked;

  Medicine({
    required this.id,
    required this.name,
    required this.dose,
    required this.time,
    required this.note,
    this.isChecked = false,
  });
}

class PosyanduSchedule {
  final String id;
  final String name;
  final DateTime date;
  final String timeRange;
  final String location;

  PosyanduSchedule({
    required this.id,
    required this.name,
    required this.date,
    required this.timeRange,
    required this.location,
  });
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String timeLabel;
  final String type; // 'Pengingat' or 'Informasi'

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.type,
  });
}

class LansiaMember {
  final String id;
  String name;
  int age;
  String gender;
  List<HealthRecord> records;

  LansiaMember({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.records,
  });

  HealthRecord? get latestRecord => records.isEmpty ? null : records.first;
}

class HealthArticle {
  final String id;
  final String title;
  final String dateLabel;
  final String category; // 'Pola Makan', 'Olahraga', 'Jantung'
  final String contentSummary;

  HealthArticle({
    required this.id,
    required this.title,
    required this.dateLabel,
    required this.category,
    required this.contentSummary,
  });
}

class RegisteredUser {
  final String email;
  final String password;
  final String role; // 'Lansia' or 'Kader'
  final String name;
  final int age;
  final String gender;
  final String nik;
  final String familyContact;
  final String medicalHistory;
  String profileImage;
  final String posyandu;
  final String kaderContact;

  RegisteredUser({
    required this.email,
    required this.password,
    required this.role,
    required this.name,
    required this.age,
    required this.gender,
    required this.nik,
    required this.familyContact,
    required this.medicalHistory,
    this.profileImage = '',
    required this.posyandu,
    this.kaderContact = '',
  });
}

class DataStore extends ChangeNotifier {
  // Singleton Pattern
  static final DataStore _instance = DataStore._internal();
  factory DataStore() => _instance;
  DataStore._internal();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    final db = DatabaseHelper.instance;

    // Load users
    final dbUsers = await db.getUsers();
    if (dbUsers.isEmpty) {
      // Seed default accounts and initial mock data
      await _seedInitialData();
    } else {
      _users.clear();
      _users.addAll(dbUsers);

      _healthRecords.clear();
      _healthRecords.addAll(await db.getHealthRecords(currentUserEmail));
      if (_healthRecords.isEmpty) {
        final initialHealthRecords = [
          HealthRecord(
            date: DateTime(2026, 6, 8),
            bpSystolic: '120',
            bpDiastolic: '80',
            bloodSugar: 110,
            weight: 63.5,
            heartRate: 75,
          ),
          HealthRecord(
            date: DateTime(2026, 5, 10),
            bpSystolic: '125',
            bpDiastolic: '80',
            bloodSugar: 105,
            weight: 63.8,
            heartRate: 72,
          ),
          HealthRecord(
            date: DateTime(2026, 4, 14),
            bpSystolic: '132',
            bpDiastolic: '84',
            bloodSugar: 125,
            weight: 64.2,
            heartRate: 80,
          ),
          HealthRecord(
            date: DateTime(2026, 3, 15),
            bpSystolic: '128',
            bpDiastolic: '82',
            bloodSugar: 110,
            weight: 64.0,
            heartRate: 74,
          ),
          HealthRecord(
            date: DateTime(2026, 2, 12),
            bpSystolic: '130',
            bpDiastolic: '80',
            bloodSugar: 115,
            weight: 64.5,
            heartRate: 76,
          ),
          HealthRecord(
            date: DateTime(2026, 1, 10),
            bpSystolic: '135',
            bpDiastolic: '85',
            bloodSugar: 120,
            weight: 65.0,
            heartRate: 78,
          ),
        ];
        for (final hr in initialHealthRecords) {
          await db.insertHealthRecord(hr, 'siti.aminah@gmail.com');
        }
        _healthRecords.addAll(initialHealthRecords);
      }

      _medicines.clear();
      _medicines.addAll(await db.getMedicines());

      final dbSchedules = await db.getSchedules();
      if (dbSchedules.length < 12) {
        final dbClient = await db.database;
        await dbClient.delete('schedules');
        final initialSchedules = _generateFullYearSchedules();
        for (final sch in initialSchedules) {
          await db.insertSchedule(sch);
        }
        _schedules.clear();
        _schedules.addAll(initialSchedules);
      } else {
        _schedules.clear();
        _schedules.addAll(dbSchedules);
      }

      _notifications.clear();
      _notifications.addAll(await db.getNotifications());

      _lansiaMembers.clear();
      _lansiaMembers.addAll(await db.getLansiaMembers());
      if (_lansiaMembers.isEmpty) {
        final initialLansiaMembers = [
          LansiaMember(
            id: 'siti.aminah@gmail.com',
            name: 'Siti Aminah',
            age: 66,
            gender: 'Perempuan',
            records: [
              HealthRecord(
                date: DateTime(2026, 6, 8),
                bpSystolic: '120',
                bpDiastolic: '80',
                bloodSugar: 110,
                weight: 63.5,
                heartRate: 75,
              ),
              HealthRecord(
                date: DateTime(2026, 5, 10),
                bpSystolic: '125',
                bpDiastolic: '80',
                bloodSugar: 105,
                weight: 63.8,
                heartRate: 72,
              ),
              HealthRecord(
                date: DateTime(2026, 4, 14),
                bpSystolic: '132',
                bpDiastolic: '84',
                bloodSugar: 125,
                weight: 64.2,
                heartRate: 80,
              ),
              HealthRecord(
                date: DateTime(2026, 3, 15),
                bpSystolic: '128',
                bpDiastolic: '82',
                bloodSugar: 110,
                weight: 64.0,
                heartRate: 74,
              ),
            ],
          ),
          LansiaMember(
            id: 'budi.santoso@gmail.com',
            name: 'Budi Santoso',
            age: 70,
            gender: 'Laki-laki',
            records: [
              HealthRecord(
                date: DateTime(2026, 6, 5),
                bpSystolic: '135',
                bpDiastolic: '88',
                bloodSugar: 140,
                weight: 70.2,
                heartRate: 82,
              ),
              HealthRecord(
                date: DateTime(2026, 5, 8),
                bpSystolic: '140',
                bpDiastolic: '90',
                bloodSugar: 145,
                weight: 71.0,
                heartRate: 85,
              ),
            ],
          ),
          LansiaMember(
            id: 'sri.wahyuni@gmail.com',
            name: 'Sri Wahyuni',
            age: 62,
            gender: 'Perempuan',
            records: [
              HealthRecord(
                date: DateTime(2026, 6, 7),
                bpSystolic: '118',
                bpDiastolic: '78',
                bloodSugar: 98,
                weight: 55.0,
                heartRate: 70,
              ),
            ],
          ),
        ];
        for (final member in initialLansiaMembers) {
          await db.insertLansiaMember(member);
          for (final record in member.records) {
            await db.insertHealthRecord(record, member.id);
          }
        }
        _lansiaMembers.addAll(initialLansiaMembers);
      }

      // Initial static articles (keep static in code)
      _articles.clear();
      _articles.addAll([
        HealthArticle(
          id: '1',
          title: 'Tips Pola Makan Sehat untuk Lansia',
          dateLabel: '10 Mei 2024',
          category: 'Pola Makan',
          contentSummary:
              'Penting bagi lansia untuk mengonsumsi makanan berserat tinggi, rendah lemak jenuh, dan minum air putih yang cukup.Pola makan sehat untuk lansia berfokus pada asupan bergizi seimbang, mudah dicerna, dan terjadwal. Terapkan porsi kecil namun sering (3 kali makan utama dan 2 kali selingan), pastikan teksturnya lunak, dan batasi konsumsi gula, garam, serta lemak jenuh untuk mencegah penyakit kronis',
        ),
        HealthArticle(
          id: '2',
          title: 'Olahraga Ringan untuk Lansia',
          dateLabel: '8 Mei 2024',
          category: 'Olahraga',
          contentSummary:
              // 'Berjalan santai, senam lansia, dan peregangan otot dapat membantu menjaga kelenturan dan kesehatan jantung.',
              'Olahraga ringan untuk lansia adalah aktivitas fisik berintensitas rendah yang dirancang khusus untuk menyesuaikan penurunan fungsi tubuh. Tujuannya adalah memelihara kekuatan otot, menjaga keseimbangan, mencegah kekakuan sendi, dan meningkatkan kualitas hidup secara keseluruhan tanpa membebani jantung secara berlebihan.',
        ),
        HealthArticle(
          id: '3',
          title: 'Cara Menjaga Kesehatan Jantung Lansia',
          dateLabel: '5 Mei 2024',
          category: 'Jantung',
          contentSummary:
              // 'Hindari stres berlebihan, kurangi konsumsi garam, dan lakukan cek tekanan darah secara teratur.',
              'Menjaga kesehatan jantung lansia dapat dilakukan melalui pola makan sehat rendah garam, olahraga ringan yang teratur (seperti jalan pagi), rutin memantau tekanan darah dan kadar kolesterol, berhenti merokok, serta mengelola stres dengan baik. Langkah ini krusial untuk mencegah penurunan fungsi organ di usia senja.',
        ),
      ]);
    }

    // Dynamic Posyandu sync from existing users and schedules
    for (final u in _users) {
      if (!_posyandus.contains(u.posyandu)) {
        _posyandus.add(u.posyandu);
      }
    }
    for (final sch in _schedules) {
      if (!_posyandus.contains(sch.name)) {
        _posyandus.add(sch.name);
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _seedInitialData() async {
    final db = DatabaseHelper.instance;

    // Initial Registered Users
    final initialUsers = [
      RegisteredUser(
        email: 'siti.aminah@gmail.com',
        password: 'password123',
        role: 'Lansia',
        name: 'Siti Aminah',
        age: 66,
        gender: 'Perempuan',
        nik: '3172010101600001',
        familyContact: 'Budi Santoso - 081212345678',
        medicalHistory: 'Diabetes Melitus tipe 2, Hipertensi terkontrol',
        profileImage: '',
        posyandu: 'Posyandu Melati',
      ),
      RegisteredUser(
        email: 'kader@lanscare.com',
        password: 'kader123',
        role: 'Kader',
        name: 'Bu Rina',
        age: 40,
        gender: 'Perempuan',
        nik: '3172010101400002',
        familyContact: 'Dinas Kesehatan - 119',
        medicalHistory: 'None',
        profileImage: '',
        posyandu: 'Posyandu Melati',
      ),
    ];

    for (final u in initialUsers) {
      await db.insertUser(u);
    }
    _users.addAll(initialUsers);

    // Initial Health Records (for Siti)
    final initialHealthRecords = [
      HealthRecord(
        date: DateTime(2026, 6, 8),
        bpSystolic: '120',
        bpDiastolic: '80',
        bloodSugar: 110,
        weight: 63.5,
        heartRate: 75,
      ),
      HealthRecord(
        date: DateTime(2026, 5, 10),
        bpSystolic: '125',
        bpDiastolic: '80',
        bloodSugar: 105,
        weight: 63.8,
        heartRate: 72,
      ),
      HealthRecord(
        date: DateTime(2026, 4, 14),
        bpSystolic: '132',
        bpDiastolic: '84',
        bloodSugar: 125,
        weight: 64.2,
        heartRate: 80,
      ),
      HealthRecord(
        date: DateTime(2026, 3, 15),
        bpSystolic: '128',
        bpDiastolic: '82',
        bloodSugar: 110,
        weight: 64.0,
        heartRate: 74,
      ),
      HealthRecord(
        date: DateTime(2026, 2, 12),
        bpSystolic: '130',
        bpDiastolic: '80',
        bloodSugar: 115,
        weight: 64.5,
        heartRate: 76,
      ),
      HealthRecord(
        date: DateTime(2026, 1, 10),
        bpSystolic: '135',
        bpDiastolic: '85',
        bloodSugar: 120,
        weight: 65.0,
        heartRate: 78,
      ),
    ];

    for (final hr in initialHealthRecords) {
      await db.insertHealthRecord(hr, 'siti.aminah@gmail.com');
    }
    _healthRecords.addAll(initialHealthRecords);

    // Initial Medicines
    final initialMedicines = <Medicine>[];

    for (final med in initialMedicines) {
      await db.insertMedicine(med);
    }
    _medicines.addAll(initialMedicines);

    // Initial Schedules
    final initialSchedules = _generateFullYearSchedules();

    for (final sch in initialSchedules) {
      await db.insertSchedule(sch);
    }
    _schedules.addAll(initialSchedules);

    // Initial Notifications
    final initialNotifications = <NotificationItem>[];

    for (final notif in initialNotifications) {
      await db.insertNotification(notif);
    }
    _notifications.addAll(initialNotifications);

    // Initial Lansia Members
    final initialLansiaMembers = [
      LansiaMember(
        id: 'siti.aminah@gmail.com',
        name: 'Siti Aminah',
        age: 66,
        gender: 'Perempuan',
        records: [
          HealthRecord(
            date: DateTime(2026, 6, 8),
            bpSystolic: '120',
            bpDiastolic: '80',
            bloodSugar: 110,
            weight: 63.5,
            heartRate: 75,
          ),
          HealthRecord(
            date: DateTime(2026, 5, 10),
            bpSystolic: '125',
            bpDiastolic: '80',
            bloodSugar: 105,
            weight: 63.8,
            heartRate: 72,
          ),
          HealthRecord(
            date: DateTime(2026, 4, 14),
            bpSystolic: '132',
            bpDiastolic: '84',
            bloodSugar: 125,
            weight: 64.2,
            heartRate: 80,
          ),
          HealthRecord(
            date: DateTime(2026, 3, 15),
            bpSystolic: '128',
            bpDiastolic: '82',
            bloodSugar: 110,
            weight: 64.0,
            heartRate: 74,
          ),
        ],
      ),
      LansiaMember(
        id: 'budi.santoso@gmail.com',
        name: 'Budi Santoso',
        age: 70,
        gender: 'Laki-laki',
        records: [
          HealthRecord(
            date: DateTime(2026, 6, 5),
            bpSystolic: '135',
            bpDiastolic: '88',
            bloodSugar: 140,
            weight: 70.2,
            heartRate: 82,
          ),
          HealthRecord(
            date: DateTime(2026, 5, 8),
            bpSystolic: '140',
            bpDiastolic: '90',
            bloodSugar: 145,
            weight: 71.0,
            heartRate: 85,
          ),
        ],
      ),
      LansiaMember(
        id: 'sri.wahyuni@gmail.com',
        name: 'Sri Wahyuni',
        age: 62,
        gender: 'Perempuan',
        records: [
          HealthRecord(
            date: DateTime(2026, 6, 7),
            bpSystolic: '118',
            bpDiastolic: '78',
            bloodSugar: 98,
            weight: 55.0,
            heartRate: 70,
          ),
        ],
      ),
    ];

    for (final member in initialLansiaMembers) {
      await db.insertLansiaMember(member);
      for (final record in member.records) {
        await db.insertHealthRecord(record, member.id);
      }
    }
    _lansiaMembers.addAll(initialLansiaMembers);

    _articles.addAll([
      HealthArticle(
        id: '1',
        title: 'Tips Pola Makan Sehat untuk Lansia',
        dateLabel: '10 Mei 2024',
        category: 'Pola Makan',
        contentSummary:
            'Penting bagi lansia untuk mengonsumsi makanan berserat tinggi, rendah lemak jenuh, dan minum air putih yang cukup.',
      ),
      HealthArticle(
        id: '2',
        title: 'Olahraga Ringan untuk Lansia',
        dateLabel: '8 Mei 2024',
        category: 'Olahraga',
        contentSummary:
            'Berjalan santai, senam lansia, dan peregangan otot dapat membantu menjaga kelenturan dan kesehatan jantung.',
      ),
      HealthArticle(
        id: '3',
        title: 'Cara Menjaga Kesehatan Jantung Lansia',
        dateLabel: '5 Mei 2024',
        category: 'Jantung',
        contentSummary:
            'Hindari stres berlebihan, kurangi konsumsi garam, dan lakukan cek tekanan darah secara teratur.',
      ),
    ]);
  }

  // Active User Profile
  String currentUserEmail = 'siti.aminah@gmail.com';
  String currentUserRole = 'Lansia';

  String userName = 'Siti Aminah';
  int userAge = 66;
  String userGender = 'Perempuan';
  String userNik = '3172010101600001';
  String userFamilyContact = 'Budi Santoso - 0812-1234-5678';
  String userKaderContact = 'Bu Rina - 0813-2345-6789';
  String userPuskesmasContact = 'Puskesmas Lansia - 021-1234567';
  String userAmbulanceContact = 'Ambulans - 119';
  String userMedicalHistory = 'Diabetes Melitus tipe 2, Hipertensi terkontrol';
  String userProfileImagePath = '';
  String kaderPosyandu = 'Posyandu Melati';

  void updateKaderPosyandu(String name) {
    kaderPosyandu = name;

    // First try to find a registered Kader for this posyandu
    final registeredKader = _users.firstWhere(
      (u) =>
          u.role == 'Kader' && u.posyandu.toLowerCase() == name.toLowerCase(),
      orElse: () => RegisteredUser(
        email: '',
        password: '',
        role: 'Kader',
        name: '',
        age: 0,
        gender: '',
        nik: '',
        familyContact: '',
        medicalHistory: '',
        posyandu: name,
      ),
    );

    if (registeredKader.email.isNotEmpty && registeredKader.name.isNotEmpty) {
      userKaderContact =
          '${registeredKader.name} - ${registeredKader.familyContact}';
      notifyListeners();
      return;
    }

    final normalized = name.toLowerCase();
    if (normalized.contains('melati')) {
      userKaderContact = 'Bu Rina - 0813-2345-6789';
    } else if (normalized.contains('mawar')) {
      userKaderContact = 'Bu Siti - 0815-9876-5432';
    } else if (normalized.contains('anggrek')) {
      userKaderContact = 'Bu Yanti - 0812-3456-7890';
    } else if (normalized.contains('rt.15') || normalized.contains('rt 15')) {
      userKaderContact = 'Bu Sri - 0812-1503-1503';
    } else if (normalized.contains('rt.11') || normalized.contains('rt 11')) {
      userKaderContact = 'Bu Ani - 0813-1103-1103';
    } else if (normalized.contains('rt.10') || normalized.contains('rt 10')) {
      userKaderContact = 'Bu Dwi - 0813-1003-1003';
    } else if (normalized.contains('rt.09') || normalized.contains('rt 09')) {
      userKaderContact = 'Bu Eka - 0813-0903-0903';
    } else if (normalized.contains('rt.08') || normalized.contains('rt 08')) {
      userKaderContact = 'Bu Fitri - 0813-0803-0803';
    } else if (normalized.contains('rt.07') || normalized.contains('rt 07')) {
      userKaderContact = 'Bu Gita - 0813-0703-0703';
    } else if (normalized.contains('rt.06') || normalized.contains('rt 06')) {
      userKaderContact = 'Bu Hartati - 0813-0603-0603';
    } else if (normalized.contains('rt.05') || normalized.contains('rt 05')) {
      userKaderContact = 'Bu Ida - 0813-0503-0503';
    } else if (normalized.contains('rt.04') || normalized.contains('rt 04')) {
      userKaderContact = 'Bu Julia - 0813-0403-0403';
    } else if (normalized.contains('rt.03') || normalized.contains('rt 03')) {
      userKaderContact = 'Bu Kartika - 0813-0303-0303';
    } else if (normalized.contains('rt.02') || normalized.contains('rt 02')) {
      userKaderContact = 'Bu Lestari - 0813-0203-0203';
    } else if (normalized.contains('rt.01') || normalized.contains('rt 01')) {
      userKaderContact = 'Bu Murni - 0813-0103-0103';
    } else {
      // General dynamic fallback generation based on the name length or hash
      final names = [
        'Bu Ani',
        'Bu Dwi',
        'Bu Eka',
        'Bu Fitri',
        'Bu Gita',
        'Bu Hartati',
        'Bu Ida',
        'Bu Julia',
        'Bu Kartika',
        'Bu Lestari',
        'Bu Murni',
        'Bu Sri',
      ];
      final index = name.hashCode.abs() % names.length;
      final selectedName = names[index];

      final hash = name.hashCode.abs().toString();
      final pad = hash.padRight(8, '0').substring(0, 8);
      final generatedPhone =
          '0812-${pad.substring(0, 4)}-${pad.substring(4, 8)}';

      userKaderContact = '$selectedName - $generatedPhone';
    }
    notifyListeners();
  }

  // Dynamic Posyandu list
  final List<String> _posyandus = [
    'Posyandu Rt.11 Rw.03',
    'Posyandu Rt.10 Rw.03',
    'Posyandu Rt.09 Rw.03',
    'Posyandu Rt.08 Rw.03',
    'Posyandu Rt.07 Rw.03',
    'Posyandu Rt.06 Rw.03',
    'Posyandu Rt.05 Rw.03',
    'Posyandu Rt.04 Rw.03',
    'Posyandu Rt.03 Rw.03',
    'Posyandu Rt.02 Rw.03',
    'Posyandu Rt.01 Rw.03',
  ];

  List<String> get posyandus => List.unmodifiable(_posyandus);

  void addPosyandu(String name) {
    if (name.trim().isNotEmpty && !_posyandus.contains(name.trim())) {
      _posyandus.add(name.trim());
      notifyListeners();
    }
  }

  // Settings
  bool isDarkMode = false;
  String appLanguage = 'Indonesia';
  double fontSizeFactor =
      1.25; // Defaulting to 1.25 (Besar) to make text larger for elderly users

  void updateFontSizeFactor(double val) {
    fontSizeFactor = val;
    notifyListeners();
  }

  // State Lists
  final List<RegisteredUser> _users = [];
  final List<HealthRecord> _healthRecords = [];
  final List<Medicine> _medicines = [];
  final List<PosyanduSchedule> _schedules = [];
  final List<NotificationItem> _notifications = [];
  final List<LansiaMember> _lansiaMembers = [];
  final Map<String, List<String>> _attendance = {};

  List<String> getAttendance(String scheduleId) {
    return _attendance[scheduleId] ?? [];
  }

  void setAttendance(String scheduleId, List<String> memberIds) {
    _attendance[scheduleId] = memberIds;
    notifyListeners();
  }

  final List<HealthArticle> _articles = [];

  List<RegisteredUser> get users => List.unmodifiable(_users);
  List<HealthRecord> get healthRecords => List.unmodifiable(_healthRecords);
  List<Medicine> get medicines => _medicines;
  List<PosyanduSchedule> get schedules => _schedules;
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);
  List<LansiaMember> get lansiaMembers => _lansiaMembers;
  List<HealthArticle> get articles => List.unmodifiable(_articles);

  // State Modifiers
  void updateProfile({
    required String name,
    required int age,
    required String gender,
    required String nik,
    required String familyContact,
    required String medicalHistory,
    String? profileImage,
    String? posyandu,
    String? kaderContact,
  }) {
    userName = name;
    userAge = age;
    userGender = gender;
    userNik = nik;
    userFamilyContact = familyContact;
    userMedicalHistory = medicalHistory;
    if (profileImage != null) {
      userProfileImagePath = profileImage;
    }
    if (posyandu != null) {
      updateKaderPosyandu(posyandu);
    }
    if (kaderContact != null) {
      userKaderContact = kaderContact;
    }

    // Update matching user in RegisteredUser list
    final userIdx = _users.indexWhere((u) => u.nik == nik);
    if (userIdx != -1) {
      final old = _users[userIdx];
      final updated = RegisteredUser(
        email: old.email,
        password: old.password,
        role: old.role,
        name: name,
        age: age,
        gender: gender,
        nik: nik,
        familyContact: familyContact,
        medicalHistory: medicalHistory,
        profileImage: profileImage ?? old.profileImage,
        posyandu: posyandu ?? old.posyandu,
        kaderContact: kaderContact ?? old.kaderContact,
      );
      _users[userIdx] = updated;
      DatabaseHelper.instance.insertUser(updated);

      // Update matching record in Kader's list too, only if this is a Lansia user
      if (old.role == 'Lansia') {
        final idx = _lansiaMembers.indexWhere(
          (m) => m.id == old.email || m.name == 'Siti Aminah' || m.id == '1',
        );
        if (idx != -1) {
          _lansiaMembers[idx].name = name;
          _lansiaMembers[idx].age = age;
          _lansiaMembers[idx].gender = gender;
          DatabaseHelper.instance.insertLansiaMember(_lansiaMembers[idx]);
        }
      }
    }

    notifyListeners();
  }

  void updateSosContacts({
    required String familyContact,
    required String kaderContact,
    required String puskesmasContact,
    required String ambulanceContact,
  }) {
    userFamilyContact = familyContact;
    userKaderContact = kaderContact;
    userPuskesmasContact = puskesmasContact;
    userAmbulanceContact = ambulanceContact;
    notifyListeners();
  }

  void toggleDarkMode(bool val) {
    isDarkMode = val;
    notifyListeners();
  }

  void setLanguage(String val) {
    appLanguage = val;
    notifyListeners();
  }

  String translate(String key) {
    final translations = {
      'Indonesia': {
        'beranda': 'Beranda',
        'kesehatan': 'Kesehatan',
        'jadwal': 'Jadwal',
        'artikel': 'Artikel',
        'akun': 'Akun',
        'pengaturan': 'Pengaturan',
        'bantuan': 'Bantuan',
        'keluar': 'Keluar',
        'sos': 'SOS Darurat',
        'tekanan_darah': 'Tekanan Darah',
        'gula_darah': 'Gula Darah',
        'berat_badan': 'Berat Badan',
        'nadi': 'Denyut Nadi',
        'hubungi_cepat': 'Hubungi Cepat',
        'pengingat_obat': 'Pengingat Obat',
        'riwayat_penyakit': 'Riwayat Penyakit',
        'kontak_keluarga': 'Kontak Keluarga',
        'mulai_sekarang': 'Mulai Sekarang',
        'selanjutnya': 'Selanjutnya',
        'lewatih': 'Lewati',
      },
      'Jawa': {
        'beranda': 'Omah',
        'kesehatan': 'Kasarasan',
        'jadwal': 'Jadwal',
        'artikel': 'Artikel',
        'akun': 'Akun',
        'pengaturan': 'Setelan',
        'bantuan': 'Pitulung',
        'keluar': 'Metu',
        'sos': 'SOS Bebaya',
        'tekanan_darah': 'Tensi Darah',
        'gula_darah': 'Gula Darah',
        'berat_badan': 'Bobot Awak',
        'nadi': 'Denyut Nadi',
        'hubungi_cepat': 'Telpon Cepet',
        'pengingat_obat': 'Eling Obat',
        'riwayat_penyakit': 'Riwayat Penyakit',
        'kontak_keluarga': 'Kontak Keluarga',
        'mulai_sekarang': 'Mulai Saiki',
        'selanjutnya': 'Lajengipun',
        'lewatih': 'Lewati',
      },
      'Sunda': {
        'beranda': 'Bumi',
        'kesehatan': 'Kasehatan',
        'jadwal': 'Jadwal',
        'artikel': 'Artikel',
        'akun': 'Akun',
        'pengaturan': 'Setélan',
        'bantuan': 'Pitulung',
        'keluar': 'Kaluar',
        'sos': 'SOS Bahaya',
        'tekanan_darah': 'Tensi Getih',
        'gula_darah': 'Gula Darah',
        'berat_badan': 'Beurat Awak',
        'nadi': 'Ketug Nadi',
        'hubungi_cepat': 'Telepon Gancang',
        'pengingat_obat': 'Pangeling Obat',
        'riwayat_penyakit': 'Riwayat Panyakit',
        'kontak_keluarga': 'Kontak Kulawarga',
        'mulai_sekarang': 'Mimitian Ayeuna',
        'selanjutnya': 'Salajengna',
        'lewatih': 'Lewati',
      },
    };
    return translations[appLanguage]?[key] ??
        translations['Indonesia']?[key] ??
        key;
  }

  Future<void> loadHealthRecords(String email) async {
    _healthRecords.clear();
    _healthRecords.addAll(await DatabaseHelper.instance.getHealthRecords(email));
    notifyListeners();
  }

  void addHealthRecord(HealthRecord record) {
    _healthRecords.insert(0, record);
    DatabaseHelper.instance.insertHealthRecord(record, currentUserEmail);

    // Sync with the member in the Kader list (using currentUserEmail as id)
    final idx = _lansiaMembers.indexWhere((m) => m.id == currentUserEmail || m.id == 'siti.aminah@gmail.com' || m.id == '1');
    if (idx != -1) {
      _lansiaMembers[idx].records.insert(0, record);
      DatabaseHelper.instance.insertHealthRecord(record, _lansiaMembers[idx].id);
    }

    notifyListeners();
  }

  void toggleMedicine(String id) {
    final idx = _medicines.indexWhere((m) => m.id == id);
    if (idx != -1) {
      _medicines[idx].isChecked = !_medicines[idx].isChecked;
      DatabaseHelper.instance.updateMedicine(_medicines[idx]);
      notifyListeners();
    }
  }

  void addMedicine(String name, String dose, String time, String note) {
    final newMed = Medicine(
      id: DateTime.now().toIso8601String(),
      name: name,
      dose: dose,
      time: time,
      note: note,
      isChecked: false,
    );
    _medicines.add(newMed);
    DatabaseHelper.instance.insertMedicine(newMed);

    // Trigger notification
    addNotification(
      'Pengingat Obat Baru',
      'Jangan lupa jadwal $name pada jam $time',
      time,
      'Pengingat',
    );
    notifyListeners();
  }

  void addNotification(
    String title,
    String body,
    String timeLabel,
    String type,
  ) {
    final notif = NotificationItem(
      id: DateTime.now().toIso8601String(),
      title: title,
      body: body,
      timeLabel: timeLabel,
      type: type,
    );
    _notifications.insert(0, notif);
    DatabaseHelper.instance.insertNotification(notif);
    notifyListeners();
  }

  void addLansiaMember(String name, int age, String gender) {
    final newLansia = LansiaMember(
      id: DateTime.now().toIso8601String(),
      name: name,
      age: age,
      gender: gender,
      records: [],
    );
    _lansiaMembers.add(newLansia);
    DatabaseHelper.instance.insertLansiaMember(newLansia);
    notifyListeners();
  }

  void addKaderRecord(String memberId, HealthRecord record) {
    final idx = _lansiaMembers.indexWhere((m) => m.id == memberId);
    if (idx != -1) {
      _lansiaMembers[idx].records.insert(0, record);
      DatabaseHelper.instance.insertHealthRecord(record, memberId);

      // If updating the currently logged-in user, update the active user health records too
      if (memberId == currentUserEmail || (currentUserEmail == 'siti.aminah@gmail.com' && (memberId == 'siti.aminah@gmail.com' || memberId == '1'))) {
        _healthRecords.insert(0, record);
        if (memberId != currentUserEmail) {
          DatabaseHelper.instance.insertHealthRecord(record, currentUserEmail);
        }
      }
      notifyListeners();
    }
  }

  void addPosyanduSchedule(
    String name,
    DateTime date,
    String timeRange,
    String location,
  ) {
    final newSchedule = PosyanduSchedule(
      id: DateTime.now().toIso8601String(),
      name: name,
      date: date,
      timeRange: timeRange,
      location: location,
    );
    _schedules.add(newSchedule);
    _schedules.sort((a, b) => a.date.compareTo(b.date));
    DatabaseHelper.instance.insertSchedule(newSchedule);
    addPosyandu(name);
    notifyListeners();
  }

  void deletePosyanduSchedule(String id) {
    _schedules.removeWhere((sch) => sch.id == id);
    DatabaseHelper.instance.deleteSchedule(id);
    notifyListeners();
  }

  void registerUser({
    required String email,
    required String password,
    required String name,
    required int age,
    required String gender,
    required String role,
    required String nik,
    required String familyContact,
    required String medicalHistory,
    required String posyandu,
    String profileImage = '',
    String kaderContact = '',
  }) {
    String finalKaderContact = kaderContact;
    if (role == 'Lansia' && finalKaderContact.isEmpty) {
      final registeredKader = _users.firstWhere(
        (u) =>
            u.role == 'Kader' &&
            u.posyandu.toLowerCase() == posyandu.toLowerCase(),
        orElse: () => RegisteredUser(
          email: '',
          password: '',
          role: 'Kader',
          name: '',
          age: 0,
          gender: '',
          nik: '',
          familyContact: '',
          medicalHistory: '',
          posyandu: posyandu,
        ),
      );
      if (registeredKader.email.isNotEmpty && registeredKader.name.isNotEmpty) {
        finalKaderContact =
            '${registeredKader.name} - ${registeredKader.familyContact}';
      } else {
        final normalized = posyandu.toLowerCase();
        if (normalized.contains('melati')) {
          finalKaderContact = 'Bu Rina - 0813-2345-6789';
        } else if (normalized.contains('mawar')) {
          finalKaderContact = 'Bu Siti - 0815-9876-5432';
        } else if (normalized.contains('anggrek')) {
          finalKaderContact = 'Bu Yanti - 0812-3456-7890';
        } else if (normalized.contains('rt.15') ||
            normalized.contains('rt 15')) {
          finalKaderContact = 'Bu Sri - 0812-1503-1503';
        } else if (normalized.contains('rt.11') ||
            normalized.contains('rt 11')) {
          finalKaderContact = 'Bu Ani - 0813-1103-1103';
        } else if (normalized.contains('rt.10') ||
            normalized.contains('rt 10')) {
          finalKaderContact = 'Bu Dwi - 0813-1003-1003';
        } else if (normalized.contains('rt.09') ||
            normalized.contains('rt 09')) {
          finalKaderContact = 'Bu Eka - 0813-0903-0903';
        } else if (normalized.contains('rt.08') ||
            normalized.contains('rt 08')) {
          finalKaderContact = 'Bu Fitri - 0813-0803-0803';
        } else if (normalized.contains('rt.07') ||
            normalized.contains('rt 07')) {
          finalKaderContact = 'Bu Gita - 0813-0703-0703';
        } else if (normalized.contains('rt.06') ||
            normalized.contains('rt 06')) {
          finalKaderContact = 'Bu Hartati - 0813-0603-0603';
        } else if (normalized.contains('rt.05') ||
            normalized.contains('rt 05')) {
          finalKaderContact = 'Bu Ida - 0813-0503-0503';
        } else if (normalized.contains('rt.04') ||
            normalized.contains('rt 04')) {
          finalKaderContact = 'Bu Julia - 0813-0403-0403';
        } else if (normalized.contains('rt.03') ||
            normalized.contains('rt 03')) {
          finalKaderContact = 'Bu Kartika - 0813-0303-0303';
        } else if (normalized.contains('rt.02') ||
            normalized.contains('rt 02')) {
          finalKaderContact = 'Bu Lestari - 0813-0203-0203';
        } else if (normalized.contains('rt.01') ||
            normalized.contains('rt 01')) {
          finalKaderContact = 'Bu Murni - 0813-0103-0103';
        } else {
          final names = [
            'Bu Ani',
            'Bu Dwi',
            'Bu Eka',
            'Bu Fitri',
            'Bu Gita',
            'Bu Hartati',
            'Bu Ida',
            'Bu Julia',
            'Bu Kartika',
            'Bu Lestari',
            'Bu Murni',
            'Bu Sri',
          ];
          final index = posyandu.hashCode.abs() % names.length;
          final selectedName = names[index];
          final hash = posyandu.hashCode.abs().toString();
          final pad = hash.padRight(8, '0').substring(0, 8);
          final generatedPhone =
              '0812-${pad.substring(0, 4)}-${pad.substring(4, 8)}';
          finalKaderContact = '$selectedName - $generatedPhone';
        }
      }
    }

    final newUser = RegisteredUser(
      email: email,
      password: password,
      name: name,
      age: age,
      gender: gender,
      role: role,
      nik: nik,
      familyContact: familyContact,
      medicalHistory: medicalHistory,
      profileImage: profileImage,
      posyandu: posyandu,
      kaderContact: finalKaderContact,
    );
    _users.add(newUser);
    if (role == 'Lansia') {
      userKaderContact = finalKaderContact;
    }
    DatabaseHelper.instance.insertUser(newUser);

    if (role == 'Lansia') {
      final newMember = LansiaMember(
        id: email,
        name: name,
        age: age,
        gender: gender,
        records: [],
      );
      _lansiaMembers.add(newMember);
      DatabaseHelper.instance.insertLansiaMember(newMember);
    }
    notifyListeners();
  }

  List<PosyanduSchedule> _generateFullYearSchedules() {
    final names = ['Posyandu Melati', 'Posyandu Mawar', 'Posyandu Anggrek'];
    final locations = [
      'Jl. Melati No. 10',
      'Jl. Mawar No. 5',
      'Jl. Anggrek No. 3',
    ];
    return List.generate(12, (index) {
      final month = index + 1;
      return PosyanduSchedule(
        id: 'full_year_$month',
        name: names[index % 3],
        date: DateTime(2026, month, 15),
        timeRange: '08.00 - 11.00 WIB',
        location: locations[index % 3],
      );
    });
  }

  RegisteredUser? authenticate(String emailOrNik, String password) {
    for (final u in _users) {
      if ((u.email.toLowerCase() == emailOrNik.toLowerCase() ||
              u.nik == emailOrNik) &&
          u.password == password) {
        return u;
      }
    }
    return null;
  }
}

class AppTheme {
  static Color getBgColor(BuildContext context) {
    final store = DataStore();
    return store.isDarkMode ? const Color(0xFF031A24) : const Color(0xFFF5F7FA);
  }

  static BoxDecoration getBgDecoration(BuildContext context) {
    final store = DataStore();
    if (store.isDarkMode) {
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF007E8A), // Cyan/teal top-right
            Color(0xFF004666), // Medium dark blue/teal
            Color(0xFF001F33), // Deep blue/black
            Color(0xFF000814), // Pitch black at bottom
          ],
          stops: [0.0, 0.35, 0.75, 1.0],
        ),
      );
    } else {
      return const BoxDecoration(
        color: Color(0xFFF5F7FA), // Plain solid background color in light mode
      );
    }
  }

  static Color getCardColor(BuildContext context) {
    final store = DataStore();
    return store.isDarkMode ? const Color(0x28FFFFFF) : Colors.white;
  }

  static Color getTextColor(BuildContext context) {
    final store = DataStore();
    return store.isDarkMode ? Colors.white : const Color(0xFF051B20);
  }

  static Color getPrimaryColor(BuildContext context) {
    final store = DataStore();
    return store.isDarkMode ? const Color(0xFF27A1A6) : const Color(0xFF085B66);
  }

  static Color getSubtextColor(BuildContext context) {
    final store = DataStore();
    return store.isDarkMode ? Colors.white70 : const Color(0xFF1B3D44);
  }
}

void showScheduleDetailDialog(BuildContext context, PosyanduSchedule item) {
  final months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  final formattedDate =
      '${item.date.day} ${months[item.date.month - 1]} ${item.date.year}';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          item.name,
          style: const TextStyle(
            color: Color(0xFF27A1A6),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF27A1A6),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Color(0xFF27A1A6),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  item.timeRange,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.getSubtextColor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF27A1A6),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.location,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.getSubtextColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Anda terdaftar untuk menghadiri ${item.name}!',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27A1A6),
            ),
            child: const Text('Hadir', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
