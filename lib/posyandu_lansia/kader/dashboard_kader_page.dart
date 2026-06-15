import 'package:flutter/material.dart';

import '../dashboard_page.dart';
import '../data_store.dart';
import '../database_helper.dart';
import '../role_selection_page.dart';
import 'data_lansia_page.dart';
import 'input_pemeriksaan_page.dart';
import 'kehadiran_page.dart';
import 'manage_jadwal_page.dart';
import 'rekap_laporan_page.dart';

class DashboardKaderPage extends StatefulWidget {
  const DashboardKaderPage({super.key});

  @override
  State<DashboardKaderPage> createState() => DashboardKaderPageState();
}

class DashboardKaderPageState extends State<DashboardKaderPage> {
  final DataStore _store = DataStore();
  int _currentTabIndex = 0; // Active tab is Beranda (index 0)

  void changeTab(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  void _showAnnouncementDialog() {
    final titleCtrl = TextEditingController(text: 'Pengumuman Penting');
    final bodyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Kirim Pengumuman',
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
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Judul Pengumuman',
                  ),
                ),
                TextField(
                  controller: bodyCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Isi Pengumuman / Pesan',
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
                if (titleCtrl.text.isNotEmpty && bodyCtrl.text.isNotEmpty) {
                  _store.addNotification(
                    titleCtrl.text,
                    bodyCtrl.text,
                    'Hari ini',
                    'Informasi',
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Pengumuman berhasil disebarkan ke semua lansia!',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5A5C),
              ),
              child: const Text('Kirim', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKaderHomeView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, ${_store.userName} 👋',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _store.isDarkMode
                          ? Colors.white
                          : const Color(0xFF0F5A5C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kader ${_store.kaderPosyandu}',
                    style: TextStyle(
                      fontSize: 13,
                      color: _store.isDarkMode
                          ? Colors.white70
                          : Colors.grey[700],
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: () async {
                  await DatabaseHelper.instance.clearSession();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RoleSelectionPage(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 4 Summary Metrics Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.4,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            children: [
              _buildSummaryCard(
                'Lansia Terdaftar',
                '${_store.lansiaMembers.length} orang',
                Icons.group,
                Colors.blue,
              ),
              _buildSummaryCard(
                'Pemeriksaan Hari Ini',
                '12 orang',
                Icons.check_circle_outline,
                const Color(0xFF22B573),
              ),
              _buildSummaryCard(
                'Jadwal Terdekat',
                '15 Mei 2024',
                Icons.calendar_month,
                Colors.teal,
              ),
              _buildSummaryCard(
                'Pengingat Terkirim',
                '8 notifikasi',
                Icons.send_to_mobile,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Menu Kader Title
          Text(
            'Menu Kader',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _store.isDarkMode ? Colors.white : const Color(0xFF0F5A5C),
            ),
          ),
          const SizedBox(height: 14),

          // Grid Menu
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildMenuTile(context, 'Data Lansia', Icons.people, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DataLansiaPage(),
                  ),
                );
              }),
              _buildMenuTile(
                context,
                'Input Pemeriksaan',
                Icons.edit_document,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InputPemeriksaanPage(),
                    ),
                  );
                },
              ),
              _buildMenuTile(
                context,
                'Jadwal Posyandu',
                Icons.calendar_today,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageJadwalPage(),
                    ),
                  );
                },
              ),
              _buildMenuTile(
                context,
                'Kirim Pengumuman',
                Icons.campaign,
                _showAnnouncementDialog,
              ),
              _buildMenuTile(context, 'Rekap Laporan', Icons.bar_chart, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RekapLaporanPage(),
                  ),
                );
              }),
              _buildMenuTile(
                context,
                'Kehadiran Lansia',
                Icons.check_circle_outline,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KehadiranPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      _buildKaderHomeView(context),
      const KesehatanTab(),
      const JadwalTab(),
      const ArtikelTab(),
      const AkunTab(),
    ];

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
          child: SafeArea(
            child: AnimatedBuilder(
              animation: _store,
              builder: (context, child) {
                return tabs[_currentTabIndex];
              },
            ),
          ),
        ),
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Kesehatan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              activeIcon: Icon(Icons.article),
              label: 'Artikel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String val,
    IconData icon,
    Color color,
  ) {
    final isDark = _store.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, color: color, size: 15),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            val,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F5A5C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isDark = _store.isDarkMode;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.getCardColor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDark
                    ? const Color(0xFF4DB6AC)
                    : const Color(0xFF0F5A5C),
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
