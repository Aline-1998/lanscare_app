import 'package:flutter/material.dart';

import 'data_store.dart';
import 'login_page.dart';
import 'notifikasi_page.dart';
import 'pengingat_obat_page.dart';
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
      const _BerandaTab(),
      const _KesehatanTab(),
      const _JadwalTab(),
      const _ArtikelTab(),
      const _AkunTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final store = DataStore();
    return AnimatedBuilder(
      animation: store,
      builder: (context, child) {
        return Scaffold(
          body: _tabs[_currentTabIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentTabIndex,
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF0F5A5C),
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
        );
      },
    );
  }
}

// ----------------------------------------------------
// TAB 1: BERANDA (HOME)
// ----------------------------------------------------
class _BerandaTab extends StatelessWidget {
  const _BerandaTab();

  @override
  Widget build(BuildContext context) {
    final store = DataStore();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Halo, ${store.userName} 👋',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F5A5C),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Semoga sehat selalu!',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      // Notification Bell with badge
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none_outlined,
                              size: 28,
                              color: Color(0xFF0F5A5C),
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
                  const Text(
                    'FITUR UTAMA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFeatureShortcut(
                          context,
                          'Pengingat Obat',
                          Icons.medication_outlined,
                          const Color(0xFF0F5A5C),
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
                  const Text(
                    'Jadwal Posyandu Terdekat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F5A5C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
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
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF4F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_month,
                            color: Color(0xFF0F5A5C),
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '15 Mei 2024',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF0F5A5C),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '08.00 - 11.00 WIB\nPosyandu Melati',
                                style: TextStyle(
                                  color: Colors.grey,
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Anda terdaftar untuk jadwal ini!',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ringkasan Kesehatan Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ringkasan Kesehatan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F5A5C),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Change tab index to 1 (Kesehatan)
                          final state = context
                              .findAncestorStateOfType<DashboardPageState>();
                          state?.changeTab(1);
                        },
                        child: const Text(
                          'Lihat semua',
                          style: TextStyle(
                            color: Color(0xFF0F5A5C),
                            fontWeight: FontWeight.bold,
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
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    children: [
                      _buildMetricCard(
                        title: 'Tekanan Darah',
                        value: latest != null ? latest.bpString : '120/80',
                        unit: 'mmHg',
                        icon: Icons.favorite_border,
                        iconColor: Colors.red,
                        bgColor: const Color(0xFFFFECEB),
                      ),
                      _buildMetricCard(
                        title: 'Gula Darah',
                        value: latest != null ? '${latest.bloodSugar}' : '90',
                        unit: 'mg/dL',
                        icon: Icons.bloodtype_outlined,
                        iconColor: const Color(0xFF22B573),
                        bgColor: const Color(0xFFE8F5E9),
                      ),
                      _buildMetricCard(
                        title: 'Berat Badan',
                        value: latest != null ? '${latest.weight}' : '55',
                        unit: 'kg',
                        icon: Icons.monitor_weight_outlined,
                        iconColor: Colors.blue,
                        bgColor: const Color(0xFFE3F2FD),
                      ),
                      _buildMetricCard(
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
                  const Text(
                    'Tips Hari Ini',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F5A5C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
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
                              const Text(
                                'Minum air putih yang cukup agar tubuh tetap terhidrasi.',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tips Hidrasi Lansia',
                                style: TextStyle(
                                  color: Colors.grey[500],
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
                            color: Color(0xFFE3F2FD),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade100),
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
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F5A5C),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                unit,
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// TAB 2: KESEHATAN (HEALTH TRACKER & GRAPH)
// ----------------------------------------------------
class _KesehatanTab extends StatefulWidget {
  const _KesehatanTab();

  @override
  State<_KesehatanTab> createState() => _KesehatanTabState();
}

class _KesehatanTabState extends State<_KesehatanTab> {
  String _activeMetric = 'Tekanan Darah';
  final DataStore _store = DataStore();

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
              color: Color(0xFF0F5A5C),
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
                  _store.addHealthRecord(
                    HealthRecord(
                      date: DateTime.now(),
                      bpSystolic: bpSysCtrl.text,
                      bpDiastolic: bpDiaCtrl.text,
                      bloodSugar: sg,
                      weight: wt,
                      heartRate: ht,
                    ),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Catatan kesehatan berhasil disimpan!'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5A5C),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.5,
        title: const Text(
          'Riwayat Kesehatan',
          style: TextStyle(
            color: Color(0xFF0F5A5C),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF0F5A5C)),
            onPressed: _showAddRecordDialog,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _store,
        builder: (context, child) {
          final records = _store.healthRecords;
          return Column(
            children: [
              // Selector Tabs
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetricButton('Tekanan Darah'),
                    _buildMetricButton('Gula Darah'),
                    _buildMetricButton('Berat Badan'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Chart Area Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F5A5C),
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
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: Text(
                          'Riwayat Terakhir',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF0F5A5C),
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    displayVal,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF0F5A5C),
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
          color: isActive ? const Color(0xFF0F5A5C) : const Color(0xFFF5F8F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF0F5A5C),
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
class _JadwalTab extends StatelessWidget {
  const _JadwalTab();

  @override
  Widget build(BuildContext context) {
    final store = DataStore();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.5,
        title: const Text(
          'Jadwal Posyandu',
          style: TextStyle(
            color: Color(0xFF0F5A5C),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, child) {
          final list = store.schedules;
          return Column(
            children: [
              // Calendar strip
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_left, color: Color(0xFF0F5A5C)),
                        Text(
                          'Mei 2024',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF0F5A5C),
                          ),
                        ),
                        Icon(Icons.arrow_right, color: Color(0xFF0F5A5C)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDayIndicator('Min', '12', false),
                        _buildDayIndicator('Sen', '13', false),
                        _buildDayIndicator('Sel', '14', false),
                        _buildDayIndicator('Rab', '15', true),
                        _buildDayIndicator('Kam', '16', false),
                        _buildDayIndicator('Jum', '17', false),
                        _buildDayIndicator('Sab', '18', false),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Schedule list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: list.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBF4F5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${item.date.day}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFF0F5A5C),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Mei',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF0F5A5C),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF0F5A5C),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 13,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.timeRange,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 13,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item.location,
                                        style: const TextStyle(
                                          color: Colors.grey,
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
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0F5A5C)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Lihat Semua Jadwal',
                      style: TextStyle(
                        color: Color(0xFF0F5A5C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
        color: isActive ? const Color(0xFF0F5A5C) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : const Color(0xFF0F5A5C),
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
class _ArtikelTab extends StatefulWidget {
  const _ArtikelTab();

  @override
  State<_ArtikelTab> createState() => _ArtikelTabState();
}

class _ArtikelTabState extends State<_ArtikelTab> {
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.5,
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
            color: Colors.white,
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: Colors.grey.shade100),
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
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF0F5A5C),
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
          //         side: const BorderSide(color: Color(0xFF0F5A5C)),
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          //       ),
          //       child: const Text(
          //         'Lihat Semua Artikel',
          //         style: TextStyle(color: Color(0xFF0F5A5C), fontWeight: FontWeight.bold),
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
                      color: const Color(0xFF0F5A5C).withOpacity(0.1),
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
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F5A5C),
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
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black54,
                    ),
                  ),
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
          color: isActive ? const Color(0xFF0F5A5C) : const Color(0xFFF5F8F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF0F5A5C),
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
class _AkunTab extends StatelessWidget {
  const _AkunTab();

  Widget _buildAvatar(String imagePath, double size) {
    Color bgColor = const Color(0xFFEBF4F5);
    Widget icon = Icon(
      Icons.person,
      color: const Color(0xFF0F5A5C),
      size: size * 0.55,
    );

    if (imagePath == 'avatar1') {
      bgColor = Colors.deepPurple[100]!;
      icon = Icon(Icons.face, color: Colors.deepPurple[700], size: size * 0.6);
    } else if (imagePath == 'avatar2') {
      bgColor = Colors.teal[100]!;
      icon = Icon(Icons.elderly, color: Colors.teal[700], size: size * 0.6);
    } else if (imagePath == 'avatar3') {
      bgColor = Colors.orange[100]!;
      icon = Icon(
        Icons.person_pin,
        color: Colors.orange[700],
        size: size * 0.6,
      );
    } else if (imagePath == 'avatar4') {
      bgColor = Colors.green[100]!;
      icon = Icon(
        Icons.elderly_woman,
        color: Colors.green[700],
        size: size * 0.6,
      );
    } else if (imagePath == 'avatar5') {
      bgColor = Colors.pink[100]!;
      icon = Icon(Icons.favorite, color: Colors.pink[700], size: size * 0.6);
    } else if (imagePath == 'avatar6') {
      bgColor = Colors.blue[100]!;
      icon = Icon(
        Icons.face_retouching_natural,
        color: Colors.blue[700],
        size: size * 0.6,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(color: const Color(0xFF0F5A5C), width: 2),
      ),
      child: icon,
    );
  }

  void _showPhotoPicker(BuildContext context) {
    final store = DataStore();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Simulasi Galeri Foto',
            style: TextStyle(
              color: Color(0xFF0F5A5C),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih foto profil Anda dari galeri hp:',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildPickerOption(
                    context,
                    store,
                    'avatar1',
                    Colors.deepPurple[100]!,
                    Icons.face,
                    Colors.deepPurple,
                  ),
                  _buildPickerOption(
                    context,
                    store,
                    'avatar2',
                    Colors.teal[100]!,
                    Icons.elderly,
                    Colors.teal,
                  ),
                  _buildPickerOption(
                    context,
                    store,
                    'avatar3',
                    Colors.orange[100]!,
                    Icons.person_pin,
                    Colors.orange,
                  ),
                  _buildPickerOption(
                    context,
                    store,
                    'avatar4',
                    Colors.green[100]!,
                    Icons.elderly_woman,
                    Colors.green,
                  ),
                  _buildPickerOption(
                    context,
                    store,
                    'avatar5',
                    Colors.pink[100]!,
                    Icons.favorite,
                    Colors.pink,
                  ),
                  _buildPickerOption(
                    context,
                    store,
                    'avatar6',
                    Colors.blue[100]!,
                    Icons.face_retouching_natural,
                    Colors.blue,
                  ),
                ],
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

  Widget _buildPickerOption(
    BuildContext context,
    DataStore store,
    String path,
    Color bgColor,
    IconData icon,
    Color iconColor,
  ) {
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
          const SnackBar(content: Text('Foto profil berhasil diubah!')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: store.userProfileImagePath == path
                ? const Color(0xFF0F5A5C)
                : Colors.grey.shade300,
            width: store.userProfileImagePath == path ? 3.0 : 1.0,
          ),
        ),
        child: Icon(icon, color: iconColor, size: 28),
      ),
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
              color: Color(0xFF0F5A5C),
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
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil berhasil diperbarui!'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5A5C),
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
                  color: Color(0xFF0F5A5C),
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
                      activeThumbColor: const Color(0xFF0F5A5C),
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
                      activeThumbColor: const Color(0xFF0F5A5C),
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
                      activeThumbColor: const Color(0xFF0F5A5C),
                      onChanged: (val) {
                        setState(() {
                          dMode = val;
                        });
                        store.toggleDarkMode(val);
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: lang,
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
                    style: TextStyle(color: Color(0xFF0F5A5C)),
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
              color: Color(0xFF0F5A5C),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildHelpItem(
                  'Bagaimana cara mencatat kesehatan?',
                  'Anda dapat menekan tab Kesehatan (kedua dari kiri) lalu tekan tombol tambah (+) di kanan atas. Masukkan vitalitas Anda dan simpan.',
                ),
                const SizedBox(height: 8),
                _buildHelpItem(
                  'Bagaimana jika terjadi keadaan darurat?',
                  'Tekan tombol SOS di halaman beranda atau tab navigasi. Halaman tersebut menyediakan tombol alarm darurat serta kontak cepat keluarga dan puskesmas.',
                ),
                const SizedBox(height: 8),
                _buildHelpItem(
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
                style: TextStyle(color: Color(0xFF0F5A5C)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpItem(String q, String a) {
    return ExpansionTile(
      title: Text(
        q,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Color(0xFF0F5A5C),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            a,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Colors.black87,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.5,
        title: const Text(
          'Profil Akun',
          style: TextStyle(
            color: Color(0xFF0F5A5C),
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
                  color: Colors.white,
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
                                  color: Color(0xFF0F5A5C),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF0F5A5C),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'NIK: ${store.userNik}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${store.userAge} Tahun • ${store.userGender}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
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
                  color: Colors.white,
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
                      _buildMenuItem(context, Icons.logout, 'Keluar', () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
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
            color: Color(0xFF0F5A5C),
          ),
        ),
        content: Text(info, style: const TextStyle(height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Color(0xFF0F5A5C)),
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
    final color = isDanger ? Colors.red : const Color(0xFF0F5A5C);
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDanger ? Colors.red : Colors.black87,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: onTap,
    );
  }
}
