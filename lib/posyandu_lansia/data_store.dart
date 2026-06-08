import 'package:flutter/material.dart';

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
  });
}

class DataStore extends ChangeNotifier {
  // Singleton Pattern
  static final DataStore _instance = DataStore._internal();
  factory DataStore() => _instance;
  DataStore._internal() {
    _initMockData();
  }

  // Active User Profile
  String userName = 'Siti Aminah';
  int userAge = 66;
  String userGender = 'Perempuan';
  String userNik = '3172010101600001';
  String userFamilyContact = 'Budi Santoso - 0812-1234-5678';
  String userKaderContact = 'Bu Rina (Kader) - 0813-2345-6789';
  String userPuskesmasContact = 'Puskesmas Lansia - 021-1234567';
  String userAmbulanceContact = 'Ambulans - 119';
  String userMedicalHistory = 'Diabetes Melitus tipe 2, Hipertensi terkontrol';
  String userProfileImagePath = '';

  // Settings
  bool isDarkMode = false;
  String appLanguage = 'Indonesia';

  // State Lists
  final List<RegisteredUser> _users = [];
  final List<HealthRecord> _healthRecords = [];
  final List<Medicine> _medicines = [];
  final List<PosyanduSchedule> _schedules = [];
  final List<NotificationItem> _notifications = [];
  final List<LansiaMember> _lansiaMembers = [];
  final List<HealthArticle> _articles = [];

  List<RegisteredUser> get users => List.unmodifiable(_users);
  List<HealthRecord> get healthRecords => List.unmodifiable(_healthRecords);
  List<Medicine> get medicines => _medicines;
  List<PosyanduSchedule> get schedules => _schedules; // Remove unmodifiable to support direct manipulation or sorting if needed
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);
  List<LansiaMember> get lansiaMembers => _lansiaMembers;
  List<HealthArticle> get articles => List.unmodifiable(_articles);

  void _initMockData() {
    // 0. Seed default accounts
    _users.addAll([
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
      ),
    ]);

    // 1. Initial Health Records (for active user, Siti)
    _healthRecords.addAll([
      HealthRecord(date: DateTime(2026, 5, 12), bpSystolic: '120', bpDiastolic: '80', bloodSugar: 90, weight: 55.0, heartRate: 72),
      HealthRecord(date: DateTime(2026, 5, 9), bpSystolic: '130', bpDiastolic: '85', bloodSugar: 96, weight: 55.2, heartRate: 76),
      HealthRecord(date: DateTime(2026, 5, 2), bpSystolic: '125', bpDiastolic: '82', bloodSugar: 88, weight: 55.5, heartRate: 70),
      HealthRecord(date: DateTime(2026, 4, 25), bpSystolic: '128', bpDiastolic: '86', bloodSugar: 92, weight: 55.8, heartRate: 74),
      HealthRecord(date: DateTime(2026, 4, 18), bpSystolic: '130', bpDiastolic: '86', bloodSugar: 95, weight: 56.0, heartRate: 75),
    ]);

    // 2. Initial Medicines
    _medicines.addAll([
      Medicine(id: '1', name: 'Amlodipin 5 mg', dose: '1 tablet', time: '07.00', note: 'sesudah makan', isChecked: true),
      Medicine(id: '2', name: 'Metformin 500 mg', dose: '1 tablet', time: '12.00', note: 'sesudah makan', isChecked: false),
      Medicine(id: '3', name: 'Simvastatin 20 mg', dose: '1 tablet', time: '19.00', note: 'sesudah makan', isChecked: false),
    ]);

    // 3. Initial Posyandu Schedules
    _schedules.addAll([
      PosyanduSchedule(id: '1', name: 'Posyandu Melati', date: DateTime(2026, 6, 15), timeRange: '08.00 - 11.00 WIB', location: 'Jl. Melati No. 10'),
      PosyanduSchedule(id: '2', name: 'Posyandu Mawar', date: DateTime(2026, 6, 22), timeRange: '08.00 - 11.00 WIB', location: 'Jl. Mawar No. 5'),
      PosyanduSchedule(id: '3', name: 'Posyandu Anggrek', date: DateTime(2026, 6, 29), timeRange: '08.00 - 11.00 WIB', location: 'Jl. Anggrek No. 3'),
    ]);

    // 4. Initial Notifications
    _notifications.addAll([
      NotificationItem(id: '1', title: 'Pengingat Posyandu', body: 'Posyandu Melati\n15 Mei 2024, 08.00 WIB', timeLabel: '08.00', type: 'Pengingat'),
      NotificationItem(id: '2', title: 'Minum Obat', body: 'Jangan lupa minum obat hari ini yaa', timeLabel: '07.30', type: 'Pengingat'),
      NotificationItem(id: '3', title: 'Cek Kesehatan', body: 'Yuk cek kesehatan rutin di posyandu terdekat', timeLabel: 'Kemarin', type: 'Informasi'),
      NotificationItem(id: '4', title: 'Informasi Kesehatan', body: 'Tips menjaga kesehatan jantung lansia', timeLabel: '2 hari lalu', type: 'Informasi'),
      NotificationItem(id: '5', title: 'Pengingat Posyandu', body: 'Posyandu Mawar\n22 Mei 2024, 08.00 WIB', timeLabel: '3 hari lalu', type: 'Pengingat'),
    ]);

    // 5. Initial Lansia Members (for Kader dashboard)
    _lansiaMembers.addAll([
      LansiaMember(
        id: '1',
        name: 'Siti Aminah',
        age: 66,
        gender: 'Perempuan',
        records: List.from(_healthRecords),
      ),
      LansiaMember(
        id: '2',
        name: 'Budi Santoso',
        age: 67,
        gender: 'Laki-laki',
        records: [
          HealthRecord(date: DateTime(2026, 5, 12), bpSystolic: '135', bpDiastolic: '85', bloodSugar: 110, weight: 64.0, heartRate: 78),
          HealthRecord(date: DateTime(2026, 5, 2), bpSystolic: '130', bpDiastolic: '80', bloodSugar: 105, weight: 64.5, heartRate: 74),
        ],
      ),
      LansiaMember(
        id: '3',
        name: 'Maryati',
        age: 63,
        gender: 'Perempuan',
        records: [
          HealthRecord(date: DateTime(2026, 5, 12), bpSystolic: '118', bpDiastolic: '78', bloodSugar: 95, weight: 52.0, heartRate: 70),
        ],
      ),
      LansiaMember(
        id: '4',
        name: 'Slamet Riyadi',
        age: 70,
        gender: 'Laki-laki',
        records: [
          HealthRecord(date: DateTime(2026, 5, 10), bpSystolic: '140', bpDiastolic: '90', bloodSugar: 125, weight: 68.0, heartRate: 82),
        ],
      ),
    ]);

    // 6. Initial Health Articles
    _articles.addAll([
      HealthArticle(id: '1', title: 'Tips Pola Makan Sehat untuk Lansia', dateLabel: '10 Mei 2024', category: 'Pola Makan', contentSummary: 'Penting bagi lansia untuk mengonsumsi makanan berserat tinggi, rendah lemak jenuh, dan minum air putih yang cukup.'),
      HealthArticle(id: '2', title: 'Olahraga Ringan untuk Lansia', dateLabel: '8 Mei 2024', category: 'Olahraga', contentSummary: 'Berjalan santai, senam lansia, dan peregangan otot dapat membantu menjaga kelenturan dan kesehatan jantung.'),
      HealthArticle(id: '3', title: 'Cara Menjaga Kesehatan Jantung Lansia', dateLabel: '5 Mei 2024', category: 'Jantung', contentSummary: 'Hindari stres berlebihan, kurangi konsumsi garam, dan lakukan cek tekanan darah secara teratur.'),
    ]);
  }

  // State Modifiers
  void updateProfile({
    required String name,
    required int age,
    required String gender,
    required String nik,
    required String familyContact,
    required String medicalHistory,
    String? profileImage,
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
    
    // Update matching user in RegisteredUser list
    final userIdx = _users.indexWhere((u) => u.email == 'siti.aminah@gmail.com' || u.nik == nik);
    if (userIdx != -1) {
      final old = _users[userIdx];
      _users[userIdx] = RegisteredUser(
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
      );
    }
    
    // Update matching record in Kader's list too
    final idx = _lansiaMembers.indexWhere((m) => m.id == '1' || m.name == 'Siti Aminah');
    if (idx != -1) {
      _lansiaMembers[idx].name = name;
      _lansiaMembers[idx].age = age;
      _lansiaMembers[idx].gender = gender;
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
      }
    };
    return translations[appLanguage]?[key] ?? translations['Indonesia']?[key] ?? key;
  }

  void addHealthRecord(HealthRecord record) {
    _healthRecords.insert(0, record);
    
    // Sync with Siti Aminah's profile in the Kader list
    final idx = _lansiaMembers.indexWhere((m) => m.id == '1');
    if (idx != -1) {
      _lansiaMembers[idx].records.insert(0, record);
    }
    
    notifyListeners();
  }

  void toggleMedicine(String id) {
    final idx = _medicines.indexWhere((m) => m.id == id);
    if (idx != -1) {
      _medicines[idx].isChecked = !_medicines[idx].isChecked;
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
    
    // Trigger notification
    addNotification('Pengingat Obat Baru', 'Jangan lupa jadwal $name pada jam $time', time, 'Pengingat');
    notifyListeners();
  }

  void addNotification(String title, String body, String timeLabel, String type) {
    _notifications.insert(0, NotificationItem(
      id: DateTime.now().toIso8601String(),
      title: title,
      body: body,
      timeLabel: timeLabel,
      type: type,
    ));
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
    notifyListeners();
  }

  void addKaderRecord(String memberId, HealthRecord record) {
    final idx = _lansiaMembers.indexWhere((m) => m.id == memberId);
    if (idx != -1) {
      _lansiaMembers[idx].records.insert(0, record);
      
      // If updating Siti Aminah, update active user health records too
      if (memberId == '1') {
        _healthRecords.insert(0, record);
      }
      notifyListeners();
    }
  }

  void addPosyanduSchedule(String name, DateTime date, String timeRange, String location) {
    _schedules.add(PosyanduSchedule(
      id: DateTime.now().toIso8601String(),
      name: name,
      date: date,
      timeRange: timeRange,
      location: location,
    ));
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
    String profileImage = '',
  }) {
    _users.add(RegisteredUser(
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
    ));

    if (role == 'Lansia') {
      _lansiaMembers.add(LansiaMember(
        id: email,
        name: name,
        age: age,
        gender: gender,
        records: [],
      ));
    }
    notifyListeners();
  }

  RegisteredUser? authenticate(String emailOrNik, String password) {
    for (final u in _users) {
      if ((u.email.toLowerCase() == emailOrNik.toLowerCase() || u.nik == emailOrNik) && u.password == password) {
        return u;
      }
    }
    return null;
  }
}

class AppTheme {
  static Color getBgColor(BuildContext context) {
    final store = DataStore();
    return store.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F8F8);
  }

  static Color getCardColor(BuildContext context) {
    final store = DataStore();
    return store.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }

  static Color getTextColor(BuildContext context) {
    final store = DataStore();
    return store.isDarkMode ? Colors.white : Colors.black87;
  }

  static Color getSubtextColor(BuildContext context) {
    final store = DataStore();
    return store.isDarkMode ? Colors.white70 : Colors.grey[700]!;
  }
}
