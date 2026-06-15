import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lanscare_app/posyandu_lansia/kader/dashboard_kader_page.dart';

import 'data_store.dart';
import 'database_helper.dart';
import 'notifikasi_page.dart';
import 'pengingat_obat_page.dart';
import 'role_selection_page.dart';
import 'sos_page.dart';
import 'widgets/custom_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  int _currentTabIndex = 0;

  void changeTab(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  // Tab views
  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      const BerandaTab(),
      const KesehatanTab(),
      const JadwalTab(),
      const ArtikelTab(),
      const AkunTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final store = DataStore();
    return AnimatedBuilder(
      animation: store,
      builder: (context, child) {
        return PopScope(
          canPop: _currentTabIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (_currentTabIndex != 0) {
              setState(() {
                _currentTabIndex = 0;
              });
            }
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: AppTheme.getBgDecoration(context),
              child: _tabs[_currentTabIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentTabIndex,
              onTap: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF27A1A6),
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 11),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home),
                  label: store.translate('beranda'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite_border),
                  activeIcon: const Icon(Icons.favorite),
                  label: store.translate('kesehatan'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.calendar_month_outlined),
                  activeIcon: const Icon(Icons.calendar_month),
                  label: store.translate('jadwal'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.article_outlined),
                  activeIcon: const Icon(Icons.article),
                  label: store.translate('artikel'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline),
                  activeIcon: const Icon(Icons.person),
                  label: store.translate('akun'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------
// TAB 1: BERANDA (HOME)
// ----------------------------------------------------
class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DataStore();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: store,
          builder: (context, child) {
            final latest = store.healthRecords.isNotEmpty
                ? store.healthRecords.first
                : null;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Greeting & Notification
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, ${store.userName} 👋',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.getTextColor(context),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Semoga sehat selalu!',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.getSubtextColor(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Notification Bell with badge
                      Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.notifications_none_outlined,
                              size: 28,
                              color: AppTheme.getTextColor(context),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NotifikasiPage(),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 8,
                                minHeight: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // FITUR UTAMA Horizontal shortcut bar
                  Text(
                    'FITUR UTAMA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: store.isDarkMode
                          ? Colors.white70
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFeatureShortcut(
                          context,
                          'Pengingat Obat',
                          Icons.medication_outlined,
                          const Color(0xFF27A1A6),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PengingatObatPage(),
                              ),
                            );
                          },
                        ),
                        _buildFeatureShortcut(
                          context,
                          'SOS Darurat',
                          Icons.ring_volume,
                          Colors.red,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SosPage(),
                              ),
                            );
                          },
                        ),
                        _buildFeatureShortcut(
                          context,
                          'Notifikasi',
                          Icons.notifications_active_outlined,
                          Colors.orange,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotifikasiPage(),
                              ),
                            );
                          },
                        ),
                        _buildFeatureShortcut(
                          context,
                          'Jadwal Posyandu',
                          Icons.calendar_today,
                          Colors.teal,
                          () {
                            // Change tab index of Dashboard to 2 (Jadwal)
                            final state = context
                                .findAncestorStateOfType<DashboardPageState>();
                            state?.changeTab(2);
                          },
                        ),
                        _buildFeatureShortcut(
                          context,
                          'Pantau Kesehatan',
                          Icons.favorite_outline,
                          Colors.pink,
                          () {
                            final state = context
                                .findAncestorStateOfType<DashboardPageState>();
                            state?.changeTab(1);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Jadwal Posyandu Terdekat Card
                  Text(
                    'Jadwal Posyandu Terdekat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.getCardColor(context),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: store.isDarkMode
                            ? Colors.white12
                            : Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (store.schedules.isNotEmpty) {
                            showScheduleDetailDialog(
                              context,
                              store.schedules.first,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: store.isDarkMode
                                      ? const Color(0xFF132D3A)
                                      : const Color(0xFFCCEAEB),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: store.isDarkMode
                                      ? const Color(0xFF4DB6AC)
                                      : const Color(0xFF051B20),
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      store.schedules.isNotEmpty
                                          ? '${store.schedules.first.date.day} ${_getMonthName(store.schedules.first.date)} ${store.schedules.first.date.year}'
                                          : '15 Juni 2026',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppTheme.getTextColor(context),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      store.schedules.isNotEmpty
                                          ? '${store.schedules.first.timeRange}\n${store.schedules.first.name}'
                                          : '08.00 - 11.00 WIB\nPosyandu Melati',
                                      style: TextStyle(
                                        color: AppTheme.getSubtextColor(
                                          context,
                                        ),
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.event_available,
                                  color: Color(0xFF22B573),
                                  size: 28,
                                ),
                                onPressed: () {
                                  if (store.schedules.isNotEmpty) {
                                    showScheduleDetailDialog(
                                      context,
                                      store.schedules.first,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Anda terdaftar untuk jadwal ini!',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Ringkasan Kesehatan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.getTextColor(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: TextButton(
                          onPressed: () {
                            // Change tab index to 1 (Kesehatan)
                            final state = context
                                .findAncestorStateOfType<DashboardPageState>();
                            state?.changeTab(1);
                          },
                          child: Text(
                            'Lihat semua',
                            style: TextStyle(
                              color: store.isDarkMode
                                  ? const Color(0xFF4DB6AC)
                                  : const Color(0xFF0F5A5C),
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Grid health cards
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.3 / store.fontSizeFactor,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    children: [
                      _buildMetricCard(
                        context,
                        title: 'Tekanan Darah',
                        value: latest != null ? latest.bpString : '120/80',
                        unit: 'mmHg',
                        icon: Icons.favorite_border,
                        iconColor: Colors.red,
                        bgColor: const Color(0xFFFFECEB),
                      ),
                      _buildMetricCard(
                        context,
                        title: 'Gula Darah',
                        value: latest != null ? '${latest.bloodSugar}' : '90',
                        unit: 'mg/dL',
                        icon: Icons.bloodtype_outlined,
                        iconColor: const Color(0xFF22B573),
                        bgColor: const Color(0xFFE8F5E9),
                      ),
                      _buildMetricCard(
                        context,
                        title: 'Berat Badan',
                        value: latest != null ? '${latest.weight}' : '55',
                        unit: 'kg',
                        icon: Icons.monitor_weight_outlined,
                        iconColor: Colors.blue,
                        bgColor: const Color(0xFFE3F2FD),
                      ),
                      _buildMetricCard(
                        context,
                        title: 'Denyut Nadi',
                        value: latest != null ? '${latest.heartRate}' : '72',
                        unit: 'bpm',
                        icon: Icons.favorite_outline,
                        iconColor: Colors.pink,
                        bgColor: const Color(0xFFFCE4EC),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tips Hari Ini Card
                  Text(
                    'Tips Hari Ini',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: store.isDarkMode
                          ? Colors.white
                          : const Color(0xFF27A1A6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.getCardColor(context),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: store.isDarkMode
                            ? Colors.white12
                            : Colors.grey.shade300,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Minum air putih yang cukup agar tubuh tetap terhidrasi.',
                                style: TextStyle(
                                  color: store.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 14,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tips Hidrasi Lansia',
                                style: TextStyle(
                                  color: store.isDarkMode
                                      ? Colors.white60
                                      : Colors.grey[500],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Soft drink image/icon
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_drink,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureShortcut(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final store = DataStore();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: store.isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    final store = DataStore();
    final isDark = store.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getCardColor(context),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.getSubtextColor(context),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? bgColor.withOpacity(0.2) : bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTextColor(context),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  unit,
                  style: TextStyle(
                    color: AppTheme.getSubtextColor(context),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthName(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[dt.month - 1];
  }
}

// ----------------------------------------------------
// TAB 2: KESEHATAN (HEALTH TRACKER & GRAPH)
// ----------------------------------------------------
class KesehatanTab extends StatefulWidget {
  const KesehatanTab({super.key});

  @override
  State<KesehatanTab> createState() => KesehatanTabState();
}

class KesehatanTabState extends State<KesehatanTab> {
  String _activeMetric = 'Tekanan Darah';
  final DataStore _store = DataStore();
  LansiaMember? _selectedKaderLansia;

  @override
  void initState() {
    super.initState();
    if (_store.currentUserRole == 'Kader' && _store.lansiaMembers.isNotEmpty) {
      _selectedKaderLansia = _store.lansiaMembers.first;
    }
  }

  void _showAddRecordDialog() {
    final bpSysCtrl = TextEditingController(text: '120');
    final bpDiaCtrl = TextEditingController(text: '80');
    final sugarCtrl = TextEditingController(text: '90');
    final weightCtrl = TextEditingController(text: '55.0');
    final heartCtrl = TextEditingController(text: '72');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Catat Kesehatan Baru',
            style: TextStyle(
              color: Color(0xFF27A1A6),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: bpSysCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Sistolik (mmHg)',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: bpDiaCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Diastolik (mmHg)',
                        ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: sugarCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Gula Darah (mg/dL)',
                  ),
                ),
                TextField(
                  controller: weightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Berat Badan (kg)',
                  ),
                ),
                TextField(
                  controller: heartCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Denyut Nadi (bpm)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final double? wt = double.tryParse(weightCtrl.text);
                final int? sg = int.tryParse(sugarCtrl.text);
                final int? ht = int.tryParse(heartCtrl.text);

                if (wt != null && sg != null && ht != null) {
                  final newRecord = HealthRecord(
                    date: DateTime.now(),
                    bpSystolic: bpSysCtrl.text,
                    bpDiastolic: bpDiaCtrl.text,
                    bloodSugar: sg,
                    weight: wt,
                    heartRate: ht,
                  );

                  if (_store.currentUserRole == 'Kader') {
                    if (_selectedKaderLansia != null) {
                      _store.addKaderRecord(
                        _selectedKaderLansia!.id,
                        newRecord,
                      );
                    }
                  } else {
                    _store.addHealthRecord(newRecord);
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Catatan kesehatan berhasil disimpan!'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27A1A6),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _store.isDarkMode ? Colors.white : const Color(0xFF27A1A6),
          ),
          onPressed: () {
            final dashState = context
                .findAncestorStateOfType<DashboardPageState>();
            if (dashState != null) {
              dashState.changeTab(0);
              return;
            }
            final kaderState = context
                .findAncestorStateOfType<DashboardKaderPageState>();
            if (kaderState != null) {
              kaderState.changeTab(0);
              return;
            }
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Riwayat Kesehatan',
          style: TextStyle(
            color: _store.isDarkMode ? Colors.white : const Color(0xFF27A1A6),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: const [],
      ),
      body: AnimatedBuilder(
        animation: _store,
        builder: (context, child) {
          final List<HealthRecord> records;
          if (_store.currentUserRole == 'Kader') {
            if (_selectedKaderLansia == null &&
                _store.lansiaMembers.isNotEmpty) {
              _selectedKaderLansia = _store.lansiaMembers.first;
            }
            records = _selectedKaderLansia?.records ?? [];
          } else {
            records = _store.healthRecords;
          }
          return Column(
            children: [
              if (_store.currentUserRole == 'Kader')
                Container(
                  color: AppTheme.getCardColor(context),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Anggota Lansia:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppTheme.getSubtextColor(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: _store.isDarkMode
                              ? Colors.white10
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<LansiaMember>(
                            value: _selectedKaderLansia,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF27A1A6),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.getTextColor(context),
                            ),
                            items: _store.lansiaMembers.map((LansiaMember val) {
                              return DropdownMenuItem<LansiaMember>(
                                value: val,
                                child: Text(
                                  '${val.name} (${val.age} Thn • ${val.gender})',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.getTextColor(context),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (LansiaMember? newValue) {
                              setState(() {
                                _selectedKaderLansia = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // Selector Tabs
              Container(
                color: AppTheme.getCardColor(context),
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildMetricButton('Tekanan Darah'),
                      const SizedBox(width: 8),
                      _buildMetricButton('Gula Darah'),
                      const SizedBox(width: 8),
                      _buildMetricButton('Berat Badan'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Chart Area Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppTheme.getCardColor(context),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _activeMetric,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.getTextColor(context),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LineChartWidget(
                      records: records,
                      metricType: _activeMetric,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Vitals List
              Expanded(
                child: Container(
                  color: AppTheme.getCardColor(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: Text(
                          'Riwayat Terakhir',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppTheme.getTextColor(context),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          itemCount: records.length,
                          separatorBuilder: (context, index) =>
                              Divider(color: Colors.grey[200]),
                          itemBuilder: (context, index) {
                            final rec = records[index];
                            String displayVal = '';
                            String displayUnit = '';

                            if (_activeMetric == 'Tekanan Darah') {
                              displayVal = rec.bpString;
                              displayUnit = 'mmHg';
                            } else if (_activeMetric == 'Gula Darah') {
                              displayVal = '${rec.bloodSugar}';
                              displayUnit = 'mg/dL';
                            } else {
                              displayVal = '${rec.weight}';
                              displayUnit = 'kg';
                            }

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                _formatDate(rec.date),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: _store.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    displayVal,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: _store.isDarkMode
                                          ? const Color(0xFF4DD6DD)
                                          : const Color(0xFF27A1A6),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    displayUnit,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetricButton(String label) {
    final isActive = _activeMetric == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeMetric = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF27A1A6)
              : (_store.isDarkMode
                    ? Colors.grey.shade900
                    : const Color(0xFFF5F8F8)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : (_store.isDarkMode
                      ? Colors.white70
                      : const Color(0xFF0F5A5C)),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

// ----------------------------------------------------
// TAB 3: JADWAL (POSYANDU CALENDAR)
// ----------------------------------------------------
class JadwalTab extends StatefulWidget {
  const JadwalTab({super.key});

  @override
  State<JadwalTab> createState() => _JadwalTabState();
}

class _JadwalTabState extends State<JadwalTab> {
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDate;

  String _getMonthFullName(DateTime dt) {
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
    return months[dt.month - 1];
  }

  String _getMonthName(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[dt.month - 1];
  }

  void _showScheduleDetailDialog(BuildContext context, PosyanduSchedule item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                    '${item.date.day} ${_getMonthFullName(item.date)} ${item.date.year}',
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

  @override
  Widget build(BuildContext context) {
    final store = DataStore();
    final startOfWeek = _focusedDate.subtract(
      Duration(days: _focusedDate.weekday % 7),
    );
    final days = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: store.isDarkMode ? Colors.white : const Color(0xFF27A1A6),
          ),
          onPressed: () {
            final dashState = context
                .findAncestorStateOfType<DashboardPageState>();
            if (dashState != null) {
              dashState.changeTab(0);
              return;
            }
            final kaderState = context
                .findAncestorStateOfType<DashboardKaderPageState>();
            if (kaderState != null) {
              kaderState.changeTab(0);
              return;
            }
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Jadwal Posyandu',
          style: TextStyle(
            color: store.isDarkMode ? Colors.white : const Color(0xFF27A1A6),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, child) {
          final allSchedules = store.schedules;
          final list = _selectedDate == null
              ? allSchedules
              : allSchedules.where((item) {
                  return item.date.day == _selectedDate!.day &&
                      item.date.month == _selectedDate!.month &&
                      item.date.year == _selectedDate!.year;
                }).toList();

          return Column(
            children: [
              // Calendar strip
              Container(
                color: AppTheme.getCardColor(context),
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: store.isDarkMode
                                ? Colors.white
                                : const Color(0xFF27A1A6),
                          ),
                          onPressed: () {
                            setState(() {
                              _focusedDate = _focusedDate.subtract(
                                const Duration(days: 7),
                              );
                            });
                          },
                        ),
                        Text(
                          '${_getMonthFullName(_focusedDate)} ${_focusedDate.year}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: store.isDarkMode
                                ? Colors.white
                                : const Color(0xFF27A1A6),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.chevron_right,
                            color: store.isDarkMode
                                ? Colors.white
                                : const Color(0xFF27A1A6),
                          ),
                          onPressed: () {
                            setState(() {
                              _focusedDate = _focusedDate.add(
                                const Duration(days: 7),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(7, (index) {
                        final date = startOfWeek.add(Duration(days: index));
                        final isSelected =
                            _selectedDate != null &&
                            date.day == _selectedDate!.day &&
                            date.month == _selectedDate!.month &&
                            date.year == _selectedDate!.year;
                        final isToday =
                            date.day == DateTime.now().day &&
                            date.month == DateTime.now().month &&
                            date.year == DateTime.now().year;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedDate = null;
                              } else {
                                _selectedDate = date;
                              }
                            });
                          },
                          child: _buildDayIndicator(
                            days[index],
                            '${date.day}',
                            isSelected,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Schedule list
              Expanded(
                child: list.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'Belum ada jadwal posyandu'
                                  : 'Belum ada jadwal pada tanggal ini',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            if (_selectedDate != null) ...[
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedDate = null;
                                  });
                                },
                                child: const Text(
                                  'Tampilkan Semua Jadwal',
                                  style: TextStyle(
                                    color: Color(0xFF27A1A6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: list.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = list[index];
                          return InkWell(
                            onTap: () =>
                                _showScheduleDetailDialog(context, item),
                            borderRadius: BorderRadius.circular(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.getCardColor(context),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: store.isDarkMode
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade100,
                                ),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 55,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.getPrimaryColor(
                                        context,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppTheme.getPrimaryColor(
                                          context,
                                        ).withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${item.date.day}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.getPrimaryColor(
                                              context,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _getMonthName(
                                            item.date,
                                          ).toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.getPrimaryColor(
                                              context,
                                            ).withOpacity(0.8),
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: store.isDarkMode
                                                ? Colors.white
                                                : const Color(0xFF051B20),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 13,
                                              color: AppTheme.getSubtextColor(
                                                context,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              item.timeRange,
                                              style: TextStyle(
                                                color: AppTheme.getSubtextColor(
                                                  context,
                                                ),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 13,
                                              color: AppTheme.getSubtextColor(
                                                context,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                item.location,
                                                style: TextStyle(
                                                  color:
                                                      AppTheme.getSubtextColor(
                                                        context,
                                                      ),
                                                  fontSize: 12,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: store.isDarkMode
                                        ? Colors.grey
                                        : Colors.grey.shade700,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDayIndicator(String name, String date, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF27A1A6) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              color: isActive
                  ? Colors.white
                  : (DataStore().isDarkMode
                        ? Colors.white60
                        : Colors.grey.shade800),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isActive
                  ? Colors.white
                  : (DataStore().isDarkMode
                        ? Colors.white70
                        : const Color(0xFF051B20)),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// TAB 4: ARTIKEL (HEALTH KNOWLEDGE)
// ----------------------------------------------------
class ArtikelTab extends StatefulWidget {
  const ArtikelTab({super.key});

  @override
  State<ArtikelTab> createState() => ArtikelTabState();
}

class ArtikelTabState extends State<ArtikelTab> {
  String _activeCategory = 'Semua';
  String _searchQuery = '';
  final DataStore _store = DataStore();

  List<HealthArticle> _getFilteredArticles() {
    List<HealthArticle> res = _store.articles;
    if (_activeCategory != 'Semua') {
      res = res.where((a) => a.category == _activeCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      res = res
          .where(
            (a) => a.title.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredArticles();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: DataStore().isDarkMode
                ? Colors.white
                : const Color(0xFF27A1A6),
          ),
          onPressed: () {
            final dashState = context
                .findAncestorStateOfType<DashboardPageState>();
            if (dashState != null) {
              dashState.changeTab(0);
              return;
            }
            final kaderState = context
                .findAncestorStateOfType<DashboardKaderPageState>();
            if (kaderState != null) {
              kaderState.changeTab(0);
              return;
            }
            Navigator.pop(context);
          },
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              hintText: 'Cari artikel...',
              hintStyle: TextStyle(fontSize: 13),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Horizontal category bar
          Container(
            color: AppTheme.getCardColor(context),
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCatTab('Semua'),
                  const SizedBox(width: 8),
                  _buildCatTab('Pola Makan'),
                  const SizedBox(width: 8),
                  _buildCatTab('Olahraga'),
                  const SizedBox(width: 8),
                  _buildCatTab('Jantung'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Article list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada artikel ditemukan',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final art = filtered[index];
                      IconData categoryIcon = Icons.restaurant;
                      Color catColor = Colors.orange;
                      if (art.category == 'Olahraga') {
                        categoryIcon = Icons.directions_walk;
                        catColor = Colors.blue;
                      } else if (art.category == 'Jantung') {
                        categoryIcon = Icons.favorite;
                        catColor = Colors.red;
                      }

                      return GestureDetector(
                        onTap: () {
                          _showArticleDetail(art);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.getCardColor(context),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: _store.isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade100,
                            ),
                          ),
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: [
                              // Visual dummy thumbnail
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: catColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  categoryIcon,
                                  color: catColor,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      art.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: _store.isDarkMode
                                            ? Colors.white
                                            : const Color(0xFF27A1A6),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      art.dateLabel,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: SizedBox(
          //     width: double.infinity,
          //     height: 44,
          //     child: OutlinedButton(
          //       onPressed: () {},
          //       style: OutlinedButton.styleFrom(
          //         side: const BorderSide(color: Color(0xFF27A1A6)),
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          //       ),
          //       child: const Text(
          //         'Lihat Semua Artikel',
          //         style: TextStyle(color: Color(0xFF27A1A6), fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _showArticleDetail(HealthArticle art) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F5A5C).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      art.category,
                      style: const TextStyle(
                        color: Color(0xFF0F5A5C),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    art.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    art.dateLabel,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                  const Divider(height: 30),
                  Text(
                    art.contentSummary,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: AppTheme.getTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCatTab(String label) {
    final isActive = _activeCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF27A1A6)
              : (_store.isDarkMode
                    ? Colors.grey.shade900
                    : const Color(0xFFF5F8F8)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : (_store.isDarkMode
                      ? Colors.white70
                      : const Color(0xFF0F5A5C)),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// TAB 5: AKUN (PROFILE & SETTINGS)
// ----------------------------------------------------
// ----------------------------------------------------
// TAB 5: AKUN (PROFILE & SETTINGS)
// ----------------------------------------------------
class AkunTab extends StatelessWidget {
  const AkunTab({super.key});

  Widget _buildFallbackInitials(String name, double size) {
    Color avatarColor = const Color(0xFF27A1A6);
    if (name == 'eren') {
      avatarColor = const Color(0xFF2E4F4F); // Green
    } else if (name == 'mikasa') {
      avatarColor = const Color(0xFF8C3333); // Red
    } else if (name == 'armin') {
      avatarColor = const Color(0xFFE4A11B); // Yellow
    } else if (name == 'levi') {
      avatarColor = const Color(0xFF2C3E50); // Charcoal
    } else if (name == 'erwin') {
      avatarColor = const Color(0xFF7F8C8D); // Silver
    } else if (name == 'sasha') {
      avatarColor = const Color(0xFFD35400); // Potato Orange
    }
    String displayName = name[0].toUpperCase() + name.substring(1);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: avatarColor,
        border: Border.all(color: const Color(0xFF27A1A6), width: 2),
      ),
      child: Center(
        child: Text(
          displayName
              .substring(0, displayName.length > 2 ? 3 : displayName.length)
              .toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.22,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String imagePath, double size) {
    Color bgColor = const Color(0xFFEBF4F5);
    Widget icon = Icon(
      Icons.person,
      color: const Color(0xFF27A1A6),
      size: size * 0.55,
    );

    bool fileExists = false;
    try {
      if (imagePath.isNotEmpty && !imagePath.startsWith('avatar')) {
        fileExists = File(imagePath).existsSync();
      }
    } catch (_) {
      fileExists = false;
    }

    if (fileExists) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF27A1A6), width: 2),
        ),
        child: ClipOval(
          child: Image.file(
            File(imagePath),
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: bgColor, child: icon);
            },
          ),
        ),
      );
    }

    if (imagePath.startsWith('avatar_')) {
      final name = imagePath.replaceAll('avatar_', '');
      final isAssetAvailable = [
        'eren',
        'mikasa',
        'levi',
        'armin',
        'erwin',
        'sasha',
      ].contains(name);

      if (isAssetAvailable) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF27A1A6), width: 2),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/$name.png',
              width: size,
              height: size,
              fit: BoxFit.cover,
              alignment: name == 'sasha'
                  ? Alignment.topCenter
                  : Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return _buildFallbackInitials(name, size);
              },
            ),
          ),
        );
      } else {
        return _buildFallbackInitials(name, size);
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(color: const Color(0xFF27A1A6), width: 2),
      ),
      child: icon,
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final store = DataStore();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        store.updateProfile(
          name: store.userName,
          age: store.userAge,
          gender: store.userGender,
          nik: store.userNik,
          familyContact: store.userFamilyContact,
          medicalHistory: store.userMedicalHistory,
          profileImage: pickedFile.path,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diubah!')),
        );
      }
    } catch (e) {
      debugPrint("Error mengambil gambar: $e");
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
    }
  }

  void _showPhotoPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Ubah Foto Profil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF27A1A6),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF27A1A6)),
                title: const Text('Ambil Foto dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF27A1A6),
                ),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.face, color: Color(0xFF27A1A6)),
                title: const Text('Gunakan Avatar'),
                onTap: () {
                  Navigator.pop(context);
                  _showSimulatedAvatarDialog(context);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showSimulatedAvatarDialog(BuildContext context) {
    final store = DataStore();
    final aotAvatars = [
      {'id': 'avatar_eren', 'name': 'Eren', 'color': const Color(0xFF2E4F4F)},
      {
        'id': 'avatar_mikasa',
        'name': 'Mikasa',
        'color': const Color(0xFF8C3333),
      },
      {'id': 'avatar_armin', 'name': 'Armin', 'color': const Color(0xFFE4A11B)},
      {'id': 'avatar_levi', 'name': 'Levi', 'color': const Color(0xFF2C3E50)},
      {'id': 'avatar_erwin', 'name': 'Erwin', 'color': const Color(0xFF7F8C8D)},
      {'id': 'avatar_sasha', 'name': 'Sasha', 'color': const Color(0xFFD35400)},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Pilih Avatar',
            style: TextStyle(
              color: Color(0xFF27A1A6),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih salah satu karakter:',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: aotAvatars.map((char) {
                  final String path = char['id'] as String;
                  final String name = char['name'] as String;
                  final Color color = char['color'] as Color;
                  final isSelected = store.userProfileImagePath == path;

                  return GestureDetector(
                    onTap: () {
                      store.updateProfile(
                        name: store.userName,
                        age: store.userAge,
                        gender: store.userGender,
                        nik: store.userNik,
                        familyContact: store.userFamilyContact,
                        medicalHistory: store.userMedicalHistory,
                        profileImage: path,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Foto profil berhasil diubah menjadi $name!',
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 70,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF27A1A6)
                                    : Colors.grey.shade300,
                                width: isSelected ? 3.0 : 1.0,
                              ),
                            ),
                            child: ClipOval(
                              child:
                                  [
                                    'eren',
                                    'mikasa',
                                    'levi',
                                    'armin',
                                    'erwin',
                                    'sasha',
                                  ].contains(name.toLowerCase())
                                  ? Image.asset(
                                      'assets/${name.toLowerCase()}.png',
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      alignment: name.toLowerCase() == 'sasha'
                                          ? Alignment.topCenter
                                          : Alignment.center,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Center(
                                              child: Text(
                                                name
                                                    .substring(
                                                      0,
                                                      name.length > 2
                                                          ? 3
                                                          : name.length,
                                                    )
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            );
                                          },
                                    )
                                  : Center(
                                      child: Text(
                                        name
                                            .substring(
                                              0,
                                              name.length > 2 ? 3 : name.length,
                                            )
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? const Color(0xFF27A1A6)
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final store = DataStore();
    final nameCtrl = TextEditingController(text: store.userName);
    final ageCtrl = TextEditingController(text: '${store.userAge}');
    final nikCtrl = TextEditingController(text: store.userNik);
    final contactCtrl = TextEditingController(text: store.userFamilyContact);
    final historyCtrl = TextEditingController(text: store.userMedicalHistory);
    String gender = store.userGender;
    if (gender != 'Perempuan' && gender != 'Laki-laki') {
      gender = 'Perempuan';
    }
    String selectedPosyandu = store.kaderPosyandu;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Edit Profil Anda',
            style: TextStyle(
              color: Color(0xFF27A1A6),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                ),
                TextField(
                  controller: nikCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'NIK (16 Digit)',
                  ),
                ),
                TextField(
                  controller: ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Umur (Tahun)'),
                ),
                TextField(
                  controller: contactCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Kontak Keluarga',
                  ),
                ),
                TextField(
                  controller: historyCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Riwayat Penyakit',
                  ),
                ),
                const SizedBox(height: 12),
                StatefulBuilder(
                  builder: (context, setStateDialog) {
                    return InkWell(
                      onTap: () {
                        _showSearchablePosyanduPicker(
                          context: context,
                          currentValue: selectedPosyandu,
                          onSelected: (val) {
                            setStateDialog(() {
                              selectedPosyandu = val;
                            });
                          },
                        );
                      },
                      child: IgnorePointer(
                        child: TextFormField(
                          controller: TextEditingController(
                            text: selectedPosyandu,
                          ),
                          key: ValueKey(selectedPosyandu),
                          decoration: const InputDecoration(
                            labelText: 'Posyandu yang Didatangi',
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: gender,
                  items: ['Perempuan', 'Laki-laki'].map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) gender = val;
                  },
                  decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty &&
                    ageCtrl.text.isNotEmpty &&
                    nikCtrl.text.isNotEmpty) {
                  store.updateProfile(
                    name: nameCtrl.text,
                    age: int.tryParse(ageCtrl.text) ?? store.userAge,
                    gender: gender,
                    nik: nikCtrl.text.trim(),
                    familyContact: contactCtrl.text,
                    medicalHistory: historyCtrl.text,
                  );
                  store.updateKaderPosyandu(selectedPosyandu);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil berhasil diperbarui!'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27A1A6),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    final store = DataStore();
    bool nDay = true;
    bool nMed = true;
    bool dMode = store.isDarkMode;
    String lang = store.appLanguage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Pengaturan Aplikasi',
                style: TextStyle(
                  color: Color(0xFF27A1A6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'Notifikasi Posyandu',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text(
                        'Kirim pengingat jadwal posyandu',
                        style: TextStyle(fontSize: 11),
                      ),
                      value: nDay,
                      activeThumbColor: const Color(0xFF27A1A6),
                      onChanged: (val) {
                        setState(() {
                          nDay = val;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text(
                        'Notifikasi Obat',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text(
                        'Kirim alarm jadwal minum obat',
                        style: TextStyle(fontSize: 11),
                      ),
                      value: nMed,
                      activeThumbColor: const Color(0xFF27A1A6),
                      onChanged: (val) {
                        setState(() {
                          nMed = val;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text(
                        'Mode Gelap',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text(
                        'Ubah tampilan layar ke tema gelap',
                        style: TextStyle(fontSize: 11),
                      ),
                      value: dMode,
                      activeThumbColor: const Color(0xFF27A1A6),
                      onChanged: (val) {
                        setState(() {
                          dMode = val;
                        });
                        store.toggleDarkMode(val);
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<double>(
                      initialValue: store.fontSizeFactor,
                      decoration: const InputDecoration(
                        labelText: 'Ukuran Tulisan',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      items: const [
                        DropdownMenuItem<double>(
                          value: 1.0,
                          child: Text('Biasa (Sedang)'),
                        ),
                        DropdownMenuItem<double>(
                          value: 1.25,
                          child: Text('Besar'),
                        ),
                        DropdownMenuItem<double>(
                          value: 1.5,
                          child: Text('Sangat Besar'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            store.updateFontSizeFactor(val);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: lang,
                      decoration: const InputDecoration(
                        labelText: 'Bahasa Aplikasi',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      items: ['Indonesia', 'Jawa', 'Sunda'].map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            lang = val;
                          });
                          store.setLanguage(val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(color: Color(0xFF27A1A6)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Pusat Bantuan LansCare',
            style: TextStyle(
              color: Color(0xFF27A1A6),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildHelpItem(
                  context,
                  'Bagaimana cara mencatat kesehatan?',
                  'Anda dapat menekan tab Kesehatan (kedua dari kiri) lalu tekan tombol tambah (+) di kanan atas. Masukkan vitalitas Anda dan simpan.',
                ),
                const SizedBox(height: 8),
                _buildHelpItem(
                  context,
                  'Bagaimana jika terjadi keadaan darurat?',
                  'Tekan tombol SOS di halaman beranda atau tab navigasi. Halaman tersebut menyediakan tombol alarm darurat serta kontak cepat keluarga dan puskesmas.',
                ),
                const SizedBox(height: 8),
                _buildHelpItem(
                  context,
                  'Bagaimana cara kerja pengingat obat?',
                  'Alarm minum obat akan aktif pada waktu yang Anda buat di menu Pengingat Obat. Centang lingkaran di sebelah kanan obat jika Anda sudah meminumnya.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Mengerti',
                style: TextStyle(color: Color(0xFF27A1A6)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpItem(BuildContext context, String q, String a) {
    return ExpansionTile(
      title: Text(
        q,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Color(0xFF27A1A6),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            a,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: AppTheme.getSubtextColor(context),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = DataStore();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: store.isDarkMode ? Colors.white : const Color(0xFF27A1A6),
          ),
          onPressed: () {
            final dashState = context
                .findAncestorStateOfType<DashboardPageState>();
            if (dashState != null) {
              dashState.changeTab(0);
              return;
            }
            final kaderState = context
                .findAncestorStateOfType<DashboardKaderPageState>();
            if (kaderState != null) {
              kaderState.changeTab(0);
              return;
            }
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profil Akun',
          style: TextStyle(
            color: Color(0xFF27A1A6),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Banner
                Container(
                  color: AppTheme.getCardColor(context),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    children: [
                      // Avatar circular frame with simulated gallery click
                      GestureDetector(
                        onTap: () => _showPhotoPicker(context),
                        child: Stack(
                          children: [
                            _buildAvatar(store.userProfileImagePath, 75.0),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF27A1A6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.userName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppTheme.getTextColor(context),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'NIK: ${store.userNik}',
                              style: TextStyle(
                                color: AppTheme.getSubtextColor(context),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${store.userAge} Tahun • ${store.userGender}',
                              style: TextStyle(
                                color: AppTheme.getSubtextColor(context),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Posyandu: ${store.kaderPosyandu}',
                              style: TextStyle(
                                color: store.isDarkMode
                                    ? const Color(0xFF40C4FF)
                                    : const Color(0xFF0F5A5C),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => _showEditProfileDialog(context),
                              child: const Text(
                                'Edit Profil',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Settings List
                Container(
                  color: AppTheme.getCardColor(context),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context,
                        Icons.person_outline,
                        'Data Pribadi',
                        () => _showEditProfileDialog(context),
                      ),
                      _buildMenuItem(
                        context,
                        Icons.history_edu,
                        'Riwayat Penyakit',
                        () {
                          _showInfoDialog(
                            context,
                            'Riwayat Penyakit',
                            store.userMedicalHistory,
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        Icons.group_outlined,
                        'Kontak Keluarga',
                        () {
                          _showInfoDialog(
                            context,
                            'Kontak Keluarga',
                            store.userFamilyContact,
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        Icons.settings_outlined,
                        'Pengaturan',
                        () => _showSettingsDialog(context),
                      ),
                      _buildMenuItem(
                        context,
                        Icons.help_outline,
                        'Bantuan',
                        () => _showHelpDialog(context),
                      ),
                      _buildMenuItem(
                        context,
                        Icons.info_outline,
                        'Tentang Aplikasi',
                        () {
                          _showInfoDialog(
                            context,
                            'Tentang LansCare',
                            'LansCare v1.0.0\nProgram Posyandu Lansia Digital untuk Kesehatan Masa Tua.',
                          );
                        },
                      ),
                      Divider(color: Colors.grey[200]),
                      _buildMenuItem(context, Icons.logout, 'Keluar', () async {
                        await DatabaseHelper.instance.clearSession();
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RoleSelectionPage(),
                            ),
                          );
                        }
                      }, isDanger: true),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String info) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF27A1A6),
          ),
        ),
        content: Text(info, style: const TextStyle(height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Color(0xFF27A1A6)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDanger = false,
  }) {
    final color = isDanger ? Colors.red : const Color(0xFF27A1A6);
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDanger ? Colors.red : AppTheme.getTextColor(context),
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: onTap,
    );
  }

  void _showSearchablePosyanduPicker({
    required BuildContext context,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    final store = DataStore();
    final searchCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final query = searchCtrl.text.trim();
            final filteredList = store.posyandus
                .where(
                  (item) => item.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Pilih Posyandu',
                style: TextStyle(
                  color: Color(0xFF27A1A6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Cari Posyandu...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF27A1A6),
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade900
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) {
                        setStateDialog(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (filteredList.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text('Posyandu tidak ditemukan'),
                            ),
                          if (filteredList.isNotEmpty)
                            Flexible(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final item = filteredList[index];
                                  final isSelected = item == currentValue;
                                  return ListTile(
                                    title: Text(
                                      item,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? const Color(0xFF27A1A6)
                                            : null,
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            color: Color(0xFF27A1A6),
                                          )
                                        : null,
                                    onTap: () {
                                      onSelected(item);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
